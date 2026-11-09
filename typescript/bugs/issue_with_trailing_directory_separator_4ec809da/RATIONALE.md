# Rationale

Verbatim tier: `injection.patch` is the reverse of the implementation hunks of upstream commit 4ec809da37abea2a718797dbfca7cc5c1fcd3607 ("Fix issue with trailing directory separator not present if symlink wasnt detected by program (#55865)"), applied to v6.0.3 (with fuzz (GNU patch -F3); changed lines are identical to the fix).
