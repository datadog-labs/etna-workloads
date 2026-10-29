`repro.sql` is fts5misc-10.0 to 10.2: an fts5 table with `prefix=1` and the ascii tokenizer holds a lone byte x'e4' (a truncated UTF-8 sequence) and the character '䔬' (E4 94 AC). It then runs `integrity-check`.

- clean: the integrity-check succeeds and the script prints `done`, exit 0.
- buggy: the check reports `Error near line 3: database disk image is malformed`, exit 1. The debug-only term check wrongly flags the malformed UTF-8 term as corruption.
