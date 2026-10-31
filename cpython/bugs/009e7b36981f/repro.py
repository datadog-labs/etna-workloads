import sys
for arg in (None, 123):
    try:
        sys.remote_exec(0, arg)
    except BaseException as e:
        print(type(e).__name__)
