Deletes and re-inserts a key while iterating a one-item dict. Clean raises
RuntimeError (dictionary keys changed during iteration); the buggy build lacks
the di->len == 0 check, so the loop ends silently, printing "no error".
