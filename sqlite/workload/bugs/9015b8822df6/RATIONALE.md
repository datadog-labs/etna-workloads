# Rationale

Fix hunks in fts5Int.h (eEnc), fts5_main.c (fts5IsUtf16/ExtractText) and the
fts5_storage.c blob/subtype handling cannot be restored: 3.54.1 no longer
uses FTS5_LOCALE_SUBTYPE or the "locale in a \0-delimited blob" format. It uses a
random per-connection 16-byte header (aLocaleHdr), so plain blobs cannot be
confused with locale values. Those hunks are left alone.

## Changed: ext/fts5/fts5_main.c, fts5LocaleFunc()
Reverses the fix hunk that made `fts5_locale(NULL|'', text)` return plain text
(`if( zLocale==0 || zLocale[0]=='\0' ) sqlite3_result_text(...)`). The shortcut is
removed, so an empty/NULL locale again yields a locale blob (header + empty
locale + text), with the original `if( zLocale ) memcpy` guard.

## Oracle failure
fts5locale-6.2: `SELECT typeof(fts5_locale(NULL,'xyz')), typeof(fts5_locale('','abc'))`
returns `blob blob` instead of `text text`.
