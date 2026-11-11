# Adapted injection for make matching on NaN a hard error

Fix: https://github.com/rust-lang/rust/commit/cda358857214bb5a2b3df4f011102ffee3843a72

# Hunk: compiler/rustc_mir_build/src/thir/pattern/const_to_pat.rs, `ConstToPat::valtree_to_pat`
Fix hunk `@@ -486,6 +477,28 @@` added `ty::Float(flt)` arm that checks `is_nan` and emits `NaNPattern` error
("NaNs are not ever equal to anything..."). Re-injected: the arm now is `ty::Float(_) => PatKind::Constant { value }`,
so NaN constants are silently accepted in patterns (the pre-fix behaviour: no hard error). Also dropped the now-unused `NaNPattern` import (fix hunk #1/#2 import changes).
