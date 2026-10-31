repro.py calls hashlib.shake_128/shake_256 digest() and hexdigest() with negative lengths and prints the exception type for each call.

Clean: every call raises ValueError.
Buggy: digest() still raises ValueError, but hexdigest() raises MemoryError.
