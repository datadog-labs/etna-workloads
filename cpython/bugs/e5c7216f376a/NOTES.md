Runs `python -q -m asyncio` with piped (non-tty) stdin and input `print('hi')`, then prints the
return code, stdout and stderr.

Clean: exit status 0. Buggy: exit status 25 (errno.ENOTTY). The injected code in
Lib/asyncio/__main__.py sets `return_code = ENOTTY` when stdin isn't a tty, before it falls
back to the basic console. The output text is identical, so only the exit status differs.
