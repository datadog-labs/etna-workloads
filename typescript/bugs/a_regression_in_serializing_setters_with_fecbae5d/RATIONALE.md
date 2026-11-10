# Rationale

Verbatim tier: `injection.patch` is the reverse of the implementation hunks of upstream commit fecbae5d2e041fe08c7ed723e74b696e4fe75989 ("Fixed a regression in serializing setters with non-function declarations in JS files (#55492)"), applied to v6.0.3 (with fuzz (GNU patch -F3); changed lines are identical to the fix).
