import os
import shutil
import sublime
import subprocess
import sys
import time

from pathlib import Path
from User.build import Build
from User.process import Process
from User.shell import Shell


def is_running(name):
    command = 'TASKLIST', '/FI', 'IMAGENAME eq %s' % name
    output = subprocess.check_output(command).decode()
    line = output.strip().split('\r\n')[-1]
    name = name.lower()

    return line.lower().startswith(name)


class Latex(Build):
    def __init__(self, window):
        super().__init__(window)

    def cleanup(self, extension):
        files = self.cwd.glob('*' + extension)

        for file in list(files):
            if file.exists():
                file.unlink()

    def handle(self, path: Path, filename: str = None):
        variable = os.path.expandvars('$LOCALAPPDATA')
        appdata = Path(variable)
        sumatra = appdata.joinpath('SumatraPDF/SumatraPDF.exe')

        return [
            'latexmk',
            '--shell-escape',
            '-f',
            '-halt-on-error',
            '-interaction=nonstopmode',
            '-xelatex',
            path.joinpath(filename + '.tex'),
            '&',
            sumatra,
            path.joinpath(filename + '.pdf')
        ]

    def run(self, kill=False, **kwargs):
        shell = kwargs.get('shell')

        if kill:
            if self.instance:
                self.instance.kill()

            return

        if kill and self.instance and self.instance.poll():
            self.instance.kill()

        self.panel = self.window.create_output_panel('exec')

        if shell is None:
            self.window.run_command(
                'show_panel',
                {'panel': 'output.exec'}
            )

        os.chdir(self.cwd)

        if sys.platform == 'win32' and shell is not None:
            self.window.run_command(
                'hide_panel',
                {'panel': 'output.exec'}
            )

            arguments = Shell(shell)
            self.command.extend(arguments)

        variable = os.path.expandvars('$LOCALAPPDATA')
        appdata = Path(variable)
        sumatra = appdata.joinpath('SumatraPDF/SumatraPDF.exe')

        pdf = self.cwd.joinpath(self.file.stem + '.pdf')

        if pdf.exists():
            pdf.unlink()

        if 'thesis' in str(self.cwd):
            path = Path('E:/code/university/thesis/latex/thesis/revision03')
            command = self.handle(path, 'thesis')
        else:
            command = [
                'latexmk',
                '--shell-escape',
                '-f',
                '-halt-on-error',
                # '-interaction=nonstopmode',
                '-interaction=errorstopmode',
                '-file-line-error',
                '-xelatex',
                '-verbose',
                self.file,
                '&',
                sumatra,
                self.file.stem + '.pdf'
            ]

        self.command.extend(command)

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

    def on_finished(self, instance):
        if instance != self.instance:
            return

        if instance.killed:
            sublime.status_message('Build cancelled')
            self.write('[Cancelled]')
        else:
            errors = self.panel.find_all_results()

            if len(errors) == 0:
                sublime.status_message('Build finished')
                self.write('[Finished]')
            else:
                sublime.status_message(
                    f"Build finished with {len(errors)} errors"
                )

        while True:
            if self.instance.poll():
                time.sleep(2)
                continue

            if is_running('sumatrapdf.exe'):
                time.sleep(2)
                continue

            break

        temporaries = [
            '.aux',
            '.bbl',
            '.bcf',
            '.blg',
            '.dvi',
            '.fdb_latexmk',
            '.fls',
            '.lof',
            '.log',
            '.lot',
            '.out',
            '.run.xml',
            '.toc',
            '.xdv'
        ]

        for temporary in temporaries:
            self.cleanup(temporary)

        directories = [
            directory
            for directory in self.cwd.glob('_minted*')
        ]

        for directory in directories:
            if directory.exists():
                shutil.rmtree(directory)

        self.command.clear()
        self.environment.clear()
        self.shell = None
