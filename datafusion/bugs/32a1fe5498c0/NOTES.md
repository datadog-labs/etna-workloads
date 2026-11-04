Reproducer: columnar `repeat('abc', i64::MAX)` via VALUES.
Buggy build overflows `string.len() * count` in the array path (panic / wrong error);
clean build returns "string size overflow on repeat" error.
