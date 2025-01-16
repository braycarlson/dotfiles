import os
import sys

from User.build import Build
from User.process import Process
from User.shell import Shell


class Cpp(Build):
    def __init__(self, window):
        super().__init__(window)

        self._makefile = None

    def walk(self, path):
        for p in path.parents:
            if p.is_dir():
                file = list(
                    p.glob('Makefile')
                )

                for makefile in file:
                    return makefile

                self.walk(p.parent)

        return None

    @property
    def makefile(self):
        self._makefile = self.walk(self.file)
        return self._makefile

    def run(self, kill=False, **kwargs):
        shell = kwargs.get('shell')
        version = kwargs.get('version')

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

        project = kwargs.get('project')

        if project == 'qt5':
            os.chdir(self.cwd.parent)
            makefile = self.cwd.parent.joinpath('Makefile')
            executable = self.cwd.parent.joinpath('release/app.exe')

            self.command.extend([
                'C:/Qt/Tools/mingw810_64/bin/mingw32-make.exe',
                '-f',
                makefile,
                '&&',
                executable
            ])

        elif self.makefile is None:
            os.chdir(self.file.parent)

            self.command.extend([
                'g++',
                '-std=c++' + str(version),
                '-Wall',
                self.file.name,
                '-o',
                self.file.stem,
            ])

            if sys.platform == 'win32':
                self.command.extend([
                    '&&',
                    self.file.stem
                ])
        else:
            os.chdir(self.makefile.parent)

            self.command.extend([
                'make',
                '-f',
                self.makefile,
                '&&'
            ])

        if sys.platform == 'win32' and shell is not None:
            self.window.run_command(
                'hide_panel',
                {'panel': 'output.exec'}
            )

            arguments = Shell(shell)
            self.command.extend(arguments)

            if shell == 'cmder':
                self.command.insert(8, self.file.stem)

            self.command.insert(len(self.command), self.file.stem)

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
