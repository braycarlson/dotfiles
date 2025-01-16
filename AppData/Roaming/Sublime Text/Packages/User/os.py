import os
import subprocess

from abc import ABC, abstractmethod
from signal import SIGTERM
from subprocess import PIPE


class OperatingSystem(ABC):
    @property
    def startupinfo(self):
        raise NotImplementedError

    @property
    def shell(self):
        raise NotImplementedError

    @property
    def preexec_fn(self):
        raise NotImplementedError

    @abstractmethod
    def kill(self, pid: int):
        raise NotImplementedError


class Windows(OperatingSystem):
    def __repr__(self):
        return 'windows'

    def __str__(self):
        return 'windows'

    @property
    def startupinfo(self):
        startupinfo = subprocess.STARTUPINFO()
        startupinfo.dwFlags |= subprocess.STARTF_USESHOWWINDOW
        startupinfo.wShowWindow = subprocess.SW_HIDE

        return startupinfo

    @property
    def shell(self):
        return True

    @property
    def preexec_fn(self):
        return None

    def kill(self, pid: int):
        startupinfo = subprocess.STARTUPINFO()
        startupinfo.dwFlags |= subprocess.STARTF_USESHOWWINDOW

        command = f"taskkill /PID {pid} /T /F"

        process = subprocess.Popen(
            command,
            stdout=PIPE,
            startupinfo=startupinfo
        )

        return process.communicate()


class Unix(OperatingSystem):
    def __repr__(self):
        return 'unix'

    def __str__(self):
        return 'unix'

    @property
    def startupinfo(self):
        return None

    @property
    def shell(self):
        return False

    @property
    def preexec_fn(self):
        return os.setsid

    def kill(self, pid: int):
        os.killpg(pid, SIGTERM)

