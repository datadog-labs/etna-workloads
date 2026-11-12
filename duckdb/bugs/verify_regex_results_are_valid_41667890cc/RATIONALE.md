# Rationale
Removed the `VerifyUTF8Result(...)` calls (the fix's added checks) so regex results are no longer validated:
- src/function/scalar/string/regexp.cpp: ExtractCaptureGroup, RegexReplaceFunction (both const and per-row paths), RegexExtractStructFunction (constant and flat paths) – hunks 2,3,4,5,6 of the fix.
- src/function/scalar/string/regexp/regexp_extract_all.cpp: Execute and ExtractStructAllSingleTuple – extract_all hunks.
- src/function/scalar/string/string_split.cpp: StringSplitExecutor – the `if (OP::VERIFY_UTF8)` check body removed.
Without them, `\C` splitting a multi-byte char yields invalid VARCHAR with no error, so the `statement error ... \C matched part of a character` tests in regex_single_byte.test no longer error.
Oracle results: see below (appended after etna-check run).

## Oracle result
```
FAIL     test/sql/function/string/regex_single_byte.test
         SELECT regexp_replace('ä', '\C', 'x');
         INTERNAL Error: Assertion triggered ... string_heap.hpp on line 27: Value::StringIsValid(data, len)
1 of 1 oracle units fail
```
The invalid result now trips a downstream assertion instead of the clean "\C matched part of a character" error.
