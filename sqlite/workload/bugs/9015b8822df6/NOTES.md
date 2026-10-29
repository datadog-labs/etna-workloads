repro.sql calls fts5_locale() with a NULL locale and an empty locale (fts5locale-6.2).
Clean shell: `text|text` (no locale means the plain text is returned).
Buggy shell: `blob|blob` (a locale blob is built even when the locale is empty).
