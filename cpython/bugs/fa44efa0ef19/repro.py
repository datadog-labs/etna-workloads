import os
try:
    os.stat(0, follow_symlinks=False)
    print("no error")
except ValueError as e:
    print("ValueError:", e)
