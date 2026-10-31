from _pyrepl.unix_eventqueue import EventQueue
from _pyrepl.terminfo import TermInfo

class EmptyTermInfo(TermInfo):
    def get(self, cap):
        return None

eq = EventQueue(0, "utf-8", EmptyTermInfo("ansi"))
eq.keymap = {}
try:
    eq.push("ñ")
    print("no error")
except AssertionError:
    print("AssertionError")
