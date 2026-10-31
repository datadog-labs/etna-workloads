Reproducer: creates a C `_queue.SimpleQueue`, records `__sizeof__()`, puts 1000 items, prints the size growth.
Clean: 8128 (the buffer grows from 8 to 1024 slots). Buggy: 0, because the `__sizeof__` override is removed and the default object size is used.
