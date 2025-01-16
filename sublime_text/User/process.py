import os
import subprocess
import sys
import threading

from codecs import getincrementaldecoder
from User.os import Unix, Windows


class Process:
    def __init__(self, listener, args, environment):
        self.killed = False
        self.listener = listener

        self.os = (
            Windows()
            if sys.platform == 'win32'
            else Unix()
        )

        preexec_fn = self.os.preexec_fn
        shell = self.os.shell
        startupinfo = self.os.startupinfo

        env = os.environ.copy()
        env.update(environment)

        for k, v in env.items():
            env[k] = os.path.expandvars(v)

        self.instance = subprocess.Popen(
            args,
            bufsize=0,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            stdin=subprocess.PIPE,
            startupinfo=startupinfo,
            env=env,
            preexec_fn=preexec_fn,
            shell=shell
        )

        self.stdout_thread = threading.Thread(
            target=self.read_fileno,
            args=(self.instance.stdout, True)
        )

    def start(self):
        self.stdout_thread.start()

    def kill(self):
        if not self.killed:
            self.killed = True

            self.os.kill(self.instance.pid)
            self.instance.terminate()

    def poll(self):
        return self.instance.poll() is None

    def exit_code(self):
        return self.instance.poll()

    def read_fileno(self, file, execute_finished):
        decoder = getincrementaldecoder('utf8')('replace')

        while True:
            data = decoder.decode(
                file.read(2 ** 16)
            )

            data = (
                data
                .replace('\r\n', '\n')
                .replace('\r', '\n')
            )

            if len(data) > 0 and not self.killed:
                self.listener.on_data(self, data)
            else:
                if execute_finished:
                    if len(data) > 0:
                        self.listener.write('\n')

                    self.listener.on_finished(self)

                break
