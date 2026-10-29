Reproducer: NOCASE-indexed column, query `y LIKE 'abc@%'`.
The LIKE optimizer builds the range y>='ABC@' AND y<'abcA' (NOCASE). The injected bug removes
`isComplete = 0` for a trailing '@', so the full LIKE is not rechecked and rows like 'abc[xyz'
(0x5b, between '@' and 'a') fall in the range.
Clean shell: `64`. Buggy shell: `64` and `91`.
