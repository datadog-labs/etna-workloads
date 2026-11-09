# Rationale

Verbatim tier: `injection.patch` is the reverse of the implementation hunks of upstream commit 1d81c1dfefda8e7a2ac1a1dd9907851c337ca464 ("fix(51521): Using a of property declared after an initializing constructor triggers an assertion failure in JS (#51524)"), applied to v6.0.3 (with fuzz (GNU patch -F3); changed lines are identical to the fix).
