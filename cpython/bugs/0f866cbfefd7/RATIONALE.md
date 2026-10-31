# Rationale

Fix hunk reversed: `Lib/locale.py` — the fix deleted the `'c.utf8': 'en_US.UTF-8'` entry from `locale_alias`. In v3.15.2 the entry is still absent, so I re-added it after `'c.iso88591'` (its original position). `locale.normalize('c.utf8')` and `normalize('C.UTF-8')` again return `en_US.UTF-8`.

The other fix hunks (the comment in locale.py, `Tools/i18n/makelocalealias.py`, NEWS, tests) are not implementation code in scope, so I left them alone.

Failing oracle case: `test.test_locale.NormalizeTest.test_c_utf8`. It expects `C.UTF-8` and gets `en_US.UTF-8`.
