# Rationale

Verbatim tier: `injection.patch` is the reverse of the implementation hunks of upstream commit 85d405a1d74c0730a9d8d6307b26e8d6f3f75421 ("Fixed a false positive "await has no effect on the type" diagnostic with mixed generic union (#50833)"), applied to v6.0.3 (with fuzz (GNU patch -F3); changed lines are identical to the fix).
