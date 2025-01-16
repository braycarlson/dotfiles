from __future__ import annotations

import os
import sys

from pathlib import Path


class Shell:
    def __new__(cls, name: str):
        instance = super().__new__(cls)

        instance.name = name

        instance.os = (
            'windows'
            if sys.platform == 'win32'
            else 'unix'
        )

        method = getattr(instance, name, None)

        if callable(method):
             return method()

    @property
    def base(self) -> Path:
        if self.os == 'windows':
            variable = os.path.expandvars('$PROGRAMFILES')
        else:
            variable = '/usr/bin'

        return Path(variable)

    def cmder(self) -> list[str]:
        path = self.base.joinpath('cmder')

        return [
            path.joinpath('vendor/conemu-maximus5/ConEmu.exe'),
            '/icon',
            path.joinpath('cmder.exe'),
            '/title',
            '/single',
            '/cmd',
            '-new_console:z:c'
        ]

    def alacritty(self) -> list[str]:
        if self.os == 'windows':
            path = self.base.joinpath('Alacritty/alacritty.exe')
        else:
            path = self.base.joinpath('alacritty')

        return [
            path,
            '--hold',
            '--command'
        ]

    def commandprompt(self) -> list[str]:
        variable = os.path.expandvars('$COMSPEC')
        path = Path(variable).parent.joinpath('cmd.exe')

        return [
            'start',
            path,
            '/k'
        ]
