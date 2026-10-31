import traceback
err = SyntaxError("invalid syntax")
err.filename = "<string>"
err.lineno = 1
err.end_lineno = 1
err.text = "a\x1a$\n"
err.offset = 3
err.end_offset = 4
exc = traceback.TracebackException.from_exception(err)
print(repr("".join(exc.format(colorize=True))))
