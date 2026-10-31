import itertools
from functools import partial
from code import InteractiveConsole
from _pyrepl.console import Console, Event
from _pyrepl.render import RenderedScreen
from _pyrepl.readline import ReadlineAlikeReader, ReadlineConfig
from _pyrepl.simple_interact import _strip_final_indent


class FakeConsole(Console):
    def __init__(self, events):
        self.events = iter(events)
        self.encoding = "utf-8"
        self._rendered_screen = RenderedScreen.empty()
        self.height = 100
        self.width = 80
        self.posxy = (0, 0)
        self._redraw_visual_cycle = 0

    def get_event(self, block=True):
        return next(self.events)

    def getpending(self):
        return self.get_event(block=False)

    def getheightwidth(self):
        return self.height, self.width

    def refresh(self, rendered_screen):
        pass

    def prepare(self):
        pass

    def restore(self):
        pass

    def move_cursor(self, x, y):
        pass

    def set_cursor_vis(self, visible):
        pass

    def push_char(self, char):
        pass

    def beep(self):
        pass

    def clear(self):
        pass

    def finish(self):
        pass

    def flushoutput(self):
        pass

    def forgetinput(self):
        pass

    def repaint(self):
        pass

    def wait(self, timeout=None):
        pass


def more_lines(text):
    src = _strip_final_indent(text)
    try:
        code = InteractiveConsole({}, filename="<stdin>").compile(src, "<stdin>", "single")
    except (OverflowError, SyntaxError, ValueError):
        return False
    return code is None


def events_for(s):
    for c in s:
        yield Event(evt="key", data=c, raw=bytearray(c.encode()))


events = itertools.chain(
    events_for("import os\n"),
    events_for("imp"),
    [Event(evt="key", data="page up", raw=bytearray(b"\x1b[5~")),
     Event(evt="key", data="\n", raw=bytearray(b"\n"))],
)
reader = ReadlineAlikeReader(console=FakeConsole(events),
                             config=ReadlineConfig(readline_completer=None))
reader.can_colorize = False
reader.more_lines = more_lines
reader.ps1 = reader.ps2 = ">>> "
reader.ps3 = reader.ps4 = "... "
print(repr(reader.readline()))
print(repr(reader.readline()))
print(reader.screen)
