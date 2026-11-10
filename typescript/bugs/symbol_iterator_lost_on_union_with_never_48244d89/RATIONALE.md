# Rationale

Verbatim tier: `injection.patch` is the reverse of the implementation hunks of upstream commit 48244d89f8ccc803fef4a2f0930100de1c77668d ("fix: `[Symbol.iterator]()` lost on union with `never` (#62661)"), applied to v6.0.3 (with fuzz (GNU patch -F3); changed lines are identical to the fix).
