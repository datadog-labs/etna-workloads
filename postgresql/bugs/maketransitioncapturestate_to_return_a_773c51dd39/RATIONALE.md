# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 773c51dd39ada5f107a3656377a9611ff89132f1 ("Fix MakeTransitionCaptureState() to return a consistent result"), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/commands/trigger.c

Failing oracle cases:
- `src/test/regress||triggers`
