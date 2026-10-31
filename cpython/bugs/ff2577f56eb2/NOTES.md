Reproducer: builds an ExceptionGroup from a list (and a deque), clears the sequence, then prints repr(eg).
Clean: repr keeps the original contents, e.g. `MyEG('test', [ValueError(1), TypeError(2)])`.
Buggy: the BaseExceptionGroup repr slot is missing, so repr follows the mutated args and prints `MyEG('test', [])` and `deque([])`.
