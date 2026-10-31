import os
try:
    print(os.pathconf(-1, 'PC_NAME_MAX'))
except OSError as e:
    print(type(e).__name__, e.errno)
