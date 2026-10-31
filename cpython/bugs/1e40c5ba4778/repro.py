from unittest.mock import patch
class A: x = 1
p = patch.object(A, 'x', 2)
p.start()
try:
    p.start()
except RuntimeError as e:
    print("RuntimeError", e)
p.stop()
print(A.x)
try:
    p.stop()
except Exception as e:
    print(type(e).__name__)
print(A.x)
