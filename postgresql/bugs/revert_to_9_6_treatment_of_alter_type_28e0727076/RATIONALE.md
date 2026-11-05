# Rationale
Reintroduces the pre-fix behaviour: ALTER TYPE ... ADD VALUE is rejected inside a transaction block (unless the enum type was created in the same transaction).

Only the AlterEnum-related hunks of fix_impl.patch were re-expressed. The blacklist and check_safe_enum_use hunks were not, because they are what made the restriction unnecessary.

- src/backend/commands/typecmds.c, AlterEnum(): fix hunk "AlterEnum(AlterEnumStmt *stmt, bool isTopLevel)" plus the added xmin/HEAP_UPDATED check and PreventInTransactionBlock call (the current name of PreventTransactionChain). The syscache release moves to the end so tup stays valid. This brings the bug back: ADD VALUE inside BEGIN...COMMIT errors.
- src/backend/tcop/utility.c, ProcessUtilitySlow(): passes isTopLevel to AlterEnum (matches the utility.c hunk).
- src/include/commands/typecmds.h: AlterEnum prototype gains isTopLevel (matches the typecmds.h hunk).

Failing oracle case: src/test/regress||enum
