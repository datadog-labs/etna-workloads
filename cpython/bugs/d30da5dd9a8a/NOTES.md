Reproducer checks that ForwardRef, ChainMap and OrderedDict are in typing.__all__ and are imported by 'from typing import *'. The buggy build omits all three.
