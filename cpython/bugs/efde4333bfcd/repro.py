import sys
from unittest import mock
from profiling.sampling.cli import main

with open("output.prof", "wb") as f:
    f.write(b"not a binary sampling profile")

with mock.patch("sys.argv", ["profiling.sampling.cli", "replay", "output.prof"]):
    try:
        main()
    except SystemExit as e:
        print("SystemExit:", repr(e.code))
    except BaseException as e:
        print(type(e).__name__, e)
