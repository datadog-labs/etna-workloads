import argparse, contextlib
from unittest import mock

parser = argparse.ArgumentParser()
with contextlib.redirect_stderr(None), mock.patch('argparse._sys.exit'):
    parser.exit(status=0, message='foo')
print("ok")
