import os

from User.build import Build
from User.process import Process
from User.shell import Shell


class Zig(Build):
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
            'zig',
            'build-exe',
            self.file.name,
            '&&',
            self.file.stem + '.exe'
        ])

        if shell:
            self.window.run_command('hide_panel', {'panel': 'output.exec'})
            arguments = Shell(shell)
            self.command.extend(arguments)

            if shell == 'cmder':
                self.command.insert(11, self.file.stem + '.exe')
                self.command.insert(15, self.file.stem + '.exe')

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
