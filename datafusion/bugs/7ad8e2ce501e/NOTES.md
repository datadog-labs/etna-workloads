`repro.sql` runs `select array_repeat(1, 9223372036854775807);`.
Clean build: returns the error "array_repeat: requested length exceeds maximum array size" (exit 0).
Buggy build: panics with "capacity overflow" (exit 101), from an unchecked Vec preallocation.
