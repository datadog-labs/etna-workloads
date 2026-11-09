# Rationale

Verbatim tier: `injection.patch` is the reverse of the implementation hunks of upstream commit e24cc01b08adabf8fcbe010719c348cd525b44dd ("Cache instantiation expression types early enough to prevent reentrancy during printback (#59931)"), applied to v6.0.3 (with fuzz (GNU patch -F3); changed lines are identical to the fix).
