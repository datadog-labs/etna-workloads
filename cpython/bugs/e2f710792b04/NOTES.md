Writes a latin1-coded script (`# coding: latin1`) containing a top-level `return "ä"`, runs it in a subprocess and prints the last 3 lines of the SyntaxError traceback.
Clean: source line shows `return "ä"`. Buggy: errors.c ignores the file's declared encoding and assumes utf-8, so the line shows `return "�"`.
