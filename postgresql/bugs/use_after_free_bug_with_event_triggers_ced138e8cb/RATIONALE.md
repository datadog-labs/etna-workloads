# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit ced138e8cbac7f5a840de8679e9882665478c680 ("Fix use-after-free bug with event triggers in an extension script"), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/commands/event_trigger.c

Failing oracle cases:
- `src/test/modules/test_extensions||test_extensions`
