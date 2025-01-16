import os
import sys

from pathlib import Path
from User.build import Build
from User.process import Process
from User.shell import Shell


class Python(Build):
    def __init__(self, window):
        super().__init__(window)

    def walk(self, file: Path) -> Path:
        directories = [
            '.venv',
            '.venv_win',
            '.venv_windows',
            '.venv_unix',
            '.venv_linux',
            '.venv_mac',
            'venv',
            'venv_win',
            'venv_windows',
            'venv_unix',
            'venv_linux',
            'venv_mac',
        ]

        for parent in [file, *file.parents]:
            if parent.is_dir():
                for directory in directories:
                    path = parent.joinpath(directory)

                    if path.exists() and path.is_dir():
                        return path.parent.joinpath(directory)

        return None

    @property
    def python(self):
        path = self.walk(self.file)

        if path is None:
            python = 'python3'
        else:
            if sys.platform == 'win32':
                python = path.joinpath('Scripts/python')
            else:
                python = path.joinpath('bin/python')

            root = str(path.parent)
            os.environ['PYTHONPATH'] = root

        return python

    def handle(self, filename: str = None):
        if filename is None:
            return [self.python, '-u', self.file]

        return [
            self.python,
            '-u',
            self.root.joinpath(filename)
        ]

    def handle_project(self, project):
        if 'pioneer' in str(self.cwd):
            self.handle_pioneer()
        elif 'viking' in str(self.cwd):
            self.handle_viking()
        elif project == 'manim':
            self.handle_manim()
        else:
            self.handle_generic()

    def handle_pioneer(self):
        path = self.handle('main.py')
        self.command.extend(path)

    def handle_viking(self):
        path = self.handle('run.py')
        self.command.extend(path)

    def handle_manim(self):
        self.command.extend([
            self.python,
            '-m',
            'manim',
            '-pqk',
            # '-r',
            # '480,270',
            # '-p',
            # '-pql',
            # '--format=png',
            '--progress_bar=none',
            '--verbosity=CRITICAL',
            self.file,
        ])

    def handle_generic(self):
        path = self.handle()
        self.command.extend(path)

    def run(self, kill=False, **kwargs):
        if kill:
            if self.instance:
                self.instance.kill()

            return

        if kill and self.instance and self.instance.poll():
            self.instance.kill()

        self.panel = self.window.create_output_panel('exec')

        project = kwargs.get('project')
        shell = kwargs.get('shell')

        if shell is None:
            self.window.run_command(
                'show_panel',
                {'panel': 'output.exec'}
            )

        os.chdir(self.cwd)

        self.environment = {
            'PYTHONIOENCODING': 'utf8',
            'PYTHONDONTWRITEBYTECODE': '1'
        }

        if sys.platform == 'win32' and shell is not None:
            self.window.run_command(
                'hide_panel',
                {'panel': 'output.exec'}
            )

            command = Shell(shell)
            self.command.extend(command)

            if shell == 'cmder':
                self.command.insert(4, self.file)

        self.handle_project(project)

        try:
            self.instance = Process(
                self,
                self.command,
                self.environment,
            )

            self.instance.start()
        except Exception as e:
            self.write(str(e) + '\n')
            self.write('[Finished]')
        finally:
            self.command.clear()
            self.environment.clear()
            self.shell = None
