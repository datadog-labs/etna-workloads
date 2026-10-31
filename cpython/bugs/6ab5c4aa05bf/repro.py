from functools import partial
from unittest.mock import MagicMock
from _pyrepl.console import Event
from _pyrepl.readline import ReadlineAlikeReader, ReadlineConfig

code = "# non ‌ printing character"
events = [Event(evt="key", data=c, raw=bytearray(c.encode())) for c in code]
console = MagicMock()
console.get_event.side_effect = events
console.height = 100
console.width = 80
console.getheightwidth = MagicMock(side_effect=lambda: (100, 80))
reader = ReadlineAlikeReader(console=console, config=ReadlineConfig())
reader.more_lines = lambda text: False
reader.paste_mode = True
reader.get_prompt = lambda lineno, cursor_on_line: ""
try:
    while True:
        reader.handle1()
except StopIteration:
    pass
reader.setpos_from_xy(8, 0)
print(reader.pos)
