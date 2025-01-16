import sublime_plugin

from pathlib import Path


class SetBuildSystem(sublime_plugin.EventListener):
    def on_activated_async(self, view):
        filename = view.file_name()

        if filename is None:
            return

        path = Path(filename)

        mapping = {
            ('.c',): 'Packages/User/C.sublime-build',
            ('.cc', '.cpp', '.hpp'): 'Packages/User/C++.sublime-build',
            ('.latex', '.tex', '.text'): 'Packages/User/Latex.sublime-build',
            ('.go',): 'Packages/User/Go.sublime-build',
            ('.pl',): 'Packages/Perl/Perl.sublime-build',
            ('.py',): 'Packages/User/Python.sublime-build',
            ('.r', 'Rmd'): 'Packages/R/R.sublime-build',
            ('.racket', '.rkt', '.scheme'): 'Packages/User/Racket.sublime-build',
            ('.rs', '.rust'): 'Packages/User/RustEnhanced.sublime-build',
            ('.zig'): 'Packages/User/Zig.sublime-build'
        }

        for suffixes, file in mapping.items():
            if path.suffix in suffixes:
                build = {'file': file}
                view.window().run_command('set_build_system', build)

                return
