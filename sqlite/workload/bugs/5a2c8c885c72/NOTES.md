## Reproducer

`repro.sql` runs:

```sql
SELECT printf('|%110.100c|','*');
SELECT printf('|%-9.8c|','*');
```

This exercises the `%c` conversion with a precision, which covers
printf2-3.1..3.5 and the same code path used by printf2-4.1..4.10
(the `,` separator tests also pass through the same reworked precision
handling in `printf.c`).

## What differs

- **Clean shell**: produces the correct padded/repeated output, e.g.
  `|          ****...*|` (10 spaces then 100 stars) and `|******** |`,
  exit status 0.
- **Buggy shell**: the injected patch replaced the correct
  width/precision-aware repetition loop with a naive
  `for(idx=1; idx<precision; idx++) buf[idx] = buf[0];` that writes
  `precision` bytes into the fixed-size local `buf` stack buffer
  without checking its size, and drops the width padding logic
  entirely. For `precision=100` this overflows `buf` and corrupts the
  stack, so the buggy shell aborts with `*** stack smashing detected
  ***` (exit status -6/SIGABRT) instead of printing the expected
  result.
