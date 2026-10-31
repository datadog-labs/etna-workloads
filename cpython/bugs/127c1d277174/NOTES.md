Runs datetime.strptime in three successive fresh subinterpreters (stand-in for the
embedded re-init loop of test_datetime_reset_strptime). Clean: prints 20000101 each time.
Buggy: the first works; later ones fail with "TypeError: 'NoneType' object is not callable"
because the C code caches the `_strptime` module in a static variable that belongs to a
destroyed interpreter.
