# Rationale

The fix added NULL checks after `sqlite3_value_text()`, because a malloc failure
during a text conversion makes it return 0 even though `sqlite3_value_type()`
said TEXT. This change removes those checks again in 3.54.1.

Hunks changed (each reverses the matching fix hunk):
- `src/func.c` `lengthFunc`: removed `if( z==0 ) return;` (fix hunk `lengthFunc`).
- `src/func.c` `likeFunc`: removed `if( zEsc==0 ) return;` (fix hunk `likeFunc`).
- `src/func.c` `replaceFunc`: removed `if( zStr==0 ) return;` and `if( zRep==0 ) return;`
  (fix hunk `replaceFunc`). The zPattern check is kept because the later
  `zPattern[0]` use is handled differently in current code.
- `src/func.c` `trimFunc`: removed `if( zIn==0 ) return;` (fix hunk `trimFunc`).
- `src/date.c` `isDate`: removed the `!z ||` check on argv[0] (fix hunk `isDate`).

Not changed: upper/lower, quote and loadExt. Their current code was rewritten
(`contextMalloc`, `%Q`), so the old pattern no longer maps onto it.

Oracle result: `malloc8.test` now crashes in malloc8-3 (`SELECT length(a)...`) at
the first malloc failure that hits the UTF-16 to UTF-8 conversion. `length()`
dereferences NULL, the run is incomplete, and 259 of 651 oracle cases fail,
including `malloc-99.X`.
