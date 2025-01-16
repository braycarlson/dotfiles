import os

from User.build import Build
from User.process import Process
from User.shell import Shell


class Racket(Build):
    def __init__(self, window):
        super().__init__(window)

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

        self.command.extend([
            'C:/Program Files/Racket/Racket.exe',
            self.file,
        ])

        if shell is not None:
            self.window.run_command(
                'hide_panel',
                {'panel': 'output.exec'}
            )

            arguments = Shell(shell)
            self.command.extend(arguments)

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
