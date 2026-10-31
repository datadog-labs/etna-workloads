import curses, curses.ascii, curses.textpad
from unittest.mock import MagicMock

win = MagicMock(spec=curses.window)
win.getyx.return_value = (1, 1)
win.getmaxyx.return_value = (10, 20)
win.encoding = 'utf-8'
win.instr.return_value = b'x'
win.inch.return_value = ord('x')
tb = curses.textpad.Textbox(win)
win.reset_mock()
tb.do_command(curses.ascii.DEL)
print(win.delch.call_count)
