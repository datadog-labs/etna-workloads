import os, venv
from unittest.mock import patch

with patch('os.listxattr') as m:
    venv.create('env', symlinks=True)
    print(m.called)
