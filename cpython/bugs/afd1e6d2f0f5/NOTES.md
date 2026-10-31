repro.py builds a minimal in-memory .mo whose header has a `#-#-#-#-#  messages.po  #-#-#-#-#` comment line after Project-Id-Version, and prints `GNUTranslations.info()`.

- Clean: the comment line is skipped.
- Buggy: the comment is appended to the `project-id-version` value.
