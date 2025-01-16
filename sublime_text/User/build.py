from __future__ import annotations

import sublime
import sublime_plugin
import sys

from pathlib import Path


class EventListener:
    def on_data(self, instance, data):
        pass

    def on_finished(self, instance):
        pass


class Build(sublime_plugin.WindowCommand, EventListener):
    def __init__(self, window):
        super().__init__(window)

        self.buffer = 0
        self.instance = None
        self.limit = 2 ** 27
        self.panel = None
        self.shell = None

        self._command = []
        self._environment = {}

    @property
    def file(self):
        filename = self.window.active_view().file_name()
        return Path(filename)

    @property
    def cwd(self):
        return self.file.parent

    @property
    def environment(self):
        return self._environment

    @environment.setter
    def environment(self, e):
        self._environment.update(e)

    @property
    def command(self):
        return self._command

    @command.setter
    def command(self, c):
        self._command.extend(c)

    @property
    def root(self):
        return self.base(self.file)

    def base(self, path):
        code = []

        if sys.platform == 'win32':
            code.extend([
                Path('E:/code/personal'),
                Path('E:/code/university'),
            ])
        else:
            code.append(
                Path().home().joinpath('Documents', 'code')
            )

        code.extend([
            Path().home().joinpath('Documents'),
            Path().home().joinpath('Downloads'),
        ])

        previous = None

        for parent in path.parents:
            if parent.is_dir():
                previous = parent

                if parent.parent in code:
                    return previous

                self.base(parent.parent)

        return None

    def is_enabled(self, kill=False):
        if kill:
            return (self.instance is not None) and self.instance.poll()

        return True

    def write(self, characters):
        self.panel.run_command(
            'append',
            {
                'characters': characters,
                'force': True,
                'scroll_to_end': True
            }
        )

    def on_data(self, instance, data):
        if instance != self.instance:
            return

        if self.buffer >= self.limit:
            return

        self.write(data)
        self.buffer = self.buffer + len(data)

        if self.buffer >= self.limit:
            self.write('[Output Truncated]')

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
