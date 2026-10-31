import traceback
for exc in [SyntaxError('error', 'abcd'), SyntaxError('error', (1, 'a', 'b', 2))]:
    try:
        print(repr(traceback.format_exception_only(exc, show_group=True)))
    except Exception as e:
        print(type(e).__name__, e)
