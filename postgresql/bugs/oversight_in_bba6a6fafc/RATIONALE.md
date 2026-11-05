# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit bba6a6fafc8ae5d2e364b713568068941a929d5f ("Fix oversight in FindTriggerIncompatibleWithInheritance."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/commands/trigger.c

Failing oracle cases:
- `src/test/regress||triggers`
