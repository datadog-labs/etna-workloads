# Rationale

Verbatim tier: `injection.patch` is the reverse of the implementation hunks of upstream commit 3c0a3e536c90b16538a7442bf8411d51359dfe2c ("fix(52440): typeof ... === "undefined" check on mapped object member doesn't narrow correctly, for only some purposes (#52456)"), applied to v6.0.3 (with fuzz (GNU patch -F3); changed lines are identical to the fix).
