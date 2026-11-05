# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit b45a8d7d8b306b43f31a002f1b3f1dddc8defeaf ("Fix GUC check_hook validation for synchronized_standby_slots."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/replication/slot.c

Failing oracle cases:
- `src/test/modules/unsafe_tests||guc_privs`
