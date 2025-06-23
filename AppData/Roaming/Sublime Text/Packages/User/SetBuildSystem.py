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
            ('.js',): 'Packages/User/JavaScript.sublime-build',
            ('.go',): 'Packages/User/Go.sublime-build',
            ('.nim',): 'Packages/User/nim.sublime-build',
            ('.odin',): 'Packages/User/Odin.sublime-build',
            ('.pl',): 'Packages/Perl/Perl.sublime-build',
            ('.py',): 'Packages/User/Python.sublime-build',
            ('.r', 'Rmd'): 'Packages/R/R.sublime-build',
            ('.racket', '.rkt', '.scheme'): 'Packages/User/Racket.sublime-build',
            ('.rs', '.rust'): 'Packages/User/RustEnhanced.sublime-build',
            ('.sql', '.pgsql'): 'Packages/User/sql.sublime-build',
            ('.zig'): 'Packages/User/Zig.sublime-build'
        }

        build_system = None

        for suffixes, file in mapping.items():
            if path.suffix in suffixes:
                build_system = file
                break

        if build_system is None:
            build_system = 'Automatic'

        view.window().run_command('set_build_system', {'file': build_system})
