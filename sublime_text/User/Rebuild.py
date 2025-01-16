import sublime_plugin


class Rebuild(sublime_plugin.WindowCommand):
    def run(self):
        self.window.run_command("cancel_build")
        self.window.run_command("build")
