# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit d747dc85aec536c471fd7c739695e155627b08fd ("In plpgsql, don't preassign portal names to bound cursor variables."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/pl/plpgsql/src/pl_gram.y

Failing oracle cases:
- `src/test/regress||plpgsql`
