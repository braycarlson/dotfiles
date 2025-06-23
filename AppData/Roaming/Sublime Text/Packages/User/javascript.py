import os
import sys

from User.build import Build
from User.process import Process
from User.shell import Shell


class JavaScript(Build):
    def __init__(self, window):
        super().__init__(window)

    @property
    def node(self):
        if sys.platform == 'win32':
            node = 'node.exe'
        else:
            node = 'node'

        return node

    def handle(self, filename: str = None):
        if filename is None:
            return [self.node, self.file]
        return [
            self.node,
            self.root.joinpath(filename)
        ]

    def handle_project(self, project):
        self.handle_generic()

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
