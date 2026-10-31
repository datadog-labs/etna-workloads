import sys
from unittest import mock
import importlib

for value in ('', None):
    with mock.patch('sysconfig.get_config_var', return_value=value):
        sys.modules.pop('ensurepip', None)
        m = importlib.import_module('ensurepip')
        print(repr(value), repr(m._WHEEL_PKG_DIR))
