repro.py prints which of open/TokenError are in tokenize.__all__ and whether 'from tokenize import *' exports them. Clean: both present; buggy: neither (injection dropped them from __all__).
