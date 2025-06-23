import sublime
import sublime_plugin
import subprocess

class SwarmCommand(sublime_plugin.WindowCommand):
    def run(self, paths=[]):
        file_path = None

        if paths:
            file_path = paths[0]
        else:
            view = self.window.active_view()

            if view and view.file_name():
                file_path = view.file_name()

        if file_path:
            exe = 'C:/Users/BraydenCarlson/Documents/code/personal/swarm/target/release/swarm.exe'
            subprocess.Popen([exe, file_path])
        else:
            sublime.message_dialog('No file selected or open!')

    def is_visible(self, paths=[]):
        if paths:
            return True

        view = self.window.active_view()
        return bool(view and view.file_name())
