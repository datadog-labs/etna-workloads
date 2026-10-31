Builds DictReader/DictWriter with an iterator as `fieldnames`. Clean: it is coerced to a list, so the reader's
fieldnames/rows and writer's header/rows work. Buggy: the iterator is stored as-is, so `fieldnames` prints
an iterator object (and is consumed on first use, giving wrong/empty results).
