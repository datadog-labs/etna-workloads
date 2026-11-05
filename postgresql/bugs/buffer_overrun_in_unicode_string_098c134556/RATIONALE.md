# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 098c134556664d37b78ae87853a82f4a9d23a2c8 ("Fix buffer overrun in unicode string normalization with empty input"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/common/unicode_norm.c

Failing oracle cases:
- `src/test/regress||unicode`
