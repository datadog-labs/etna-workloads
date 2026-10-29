# Rationale

Fix hunk reversed: `if( c<0x02af && (c>=0x80 || midClass[c&0x7f]<CCLASS_DIGIT) )` -> Latin only for letters.
In 3.54.1 this check lives inside `if( c<0x02af ){ ... }` in `scriptCodeSqlFunc` (ext/misc/spellfix.c), next to a
later-added `seenDigit` branch. I made every character below 0x02af (whitespace, punctuation, digits) set
SCRIPT_LATIN again, dropping the midClass test; the `seenDigit` bookkeeping is kept but is now redundant.
The Hebrew/Arabic hunks are left intact.

Oracle failures (spellfix3): -110, -120, -130, -140, -230, -240. Text mixing non-Latin script with spaces or
punctuation now gets Latin|other and returns 998 instead of 220/200/125/160.
