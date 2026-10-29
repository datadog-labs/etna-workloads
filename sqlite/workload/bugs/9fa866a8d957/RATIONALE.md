# Rationale

The fix added a leading-zero rejection to the number parser in JSON (`if( z[j]=='0' && z[j+1] is digit ) return -1;`). Its refactor of `pParse->zJson` to `z` is cosmetic. In 3.54.1 the logic lives in `jsonTranslateTextToBlob()` in `src/json.c` (the `parse_number` case), which has two copies of the check. I removed both.

1. `c=='0'` branch: removed `else if( sqlite3Isdigit(z[i+1]) ){ iErr=i+1; return -1; }`. This is the unsigned case, `01` and `00`.
2. `c=='-'` branch: removed `if( z[i+1]=='0' ){ if( sqlite3Isdigit(z[i+2]) ) return -1; ...`. This is the signed case, `-01` and `-00`. The hex check that follows is unrelated and kept.

The two copies are the same defect (leading zeros accepted), so I reverted both.

## Oracle failures
json102-1401, 1402, 1409, 1410, 1411 and 1412 fail. `json_valid()` now returns 1 for `{"x":01}`, `-01`, `01.5`, `-01.5`, `00` and `-00`, where 0 is expected.
