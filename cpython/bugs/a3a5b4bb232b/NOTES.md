Reproducer: sends curses.ascii.DEL to a Textbox on a mock window (as TextboxTest.test_delete does) and prints how many times delch() was called.
Clean: 1 (DEL deletes the previous char). Buggy: 0 (DEL no longer handled as backspace).
