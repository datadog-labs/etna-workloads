import sys
from io import StringIO
class X:
    def __str__(self):
        sys.stdout = StringIO()
        return 'foo'
saved = sys.stdout
sys.stdout = StringIO()
print(X())
sys.stdout = saved
print("done")
