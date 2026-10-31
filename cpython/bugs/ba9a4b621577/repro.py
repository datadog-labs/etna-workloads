import os
from _pyrepl.unix_console import UnixConsole

import pty
m, s = pty.openpty()
console = UnixConsole(s, s, term="xterm")
os.environ["LINES"] = ""
print(type(console.getheightwidth()).__name__)
os.environ["COLUMNS"] = ""
print(type(console.getheightwidth()).__name__)
os.environ = []
print(type(console.getheightwidth()).__name__)
