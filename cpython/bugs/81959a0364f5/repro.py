from unittest.mock import MagicMock
from _pyrepl.console import Event
from _pyrepl.readline import ReadlineAlikeReader, ReadlineConfig

evs = [Event("key", ch, bytearray(ch.encode())) for ch in "def f():\n    pass\n\x04"]
console = MagicMock()
console.get_event.side_effect = evs
console.height, console.width = 100, 80
console.getheightwidth = lambda: (100, 80)
reader = ReadlineAlikeReader(console=console, config=ReadlineConfig(readline_completer=None))
reader.more_lines = lambda text: True
reader.paste_mode = True
reader.get_prompt = lambda lineno, cursor_on_line: ""
try:
    while True:
        reader.handle1()
except StopIteration:
    pass
print(reader.finished, repr("".join(reader.buffer)))
