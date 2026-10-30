Reproducer: pushes a b to a list, then runs LSET with indexes 4294967295, 4294967296, -4294967296 and -4294967297, printing each reply and the list afterwards.
Clean build: every LSET returns "ERR index out of range" and the list stays "a b".
Buggy build: the index is truncated to int, so LSET returns OK and overwrites elements (for example, 4294967296 becomes index 0).
