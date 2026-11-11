# Verbatim injection for early_otherwise: Don't hoist dereferences when the otherwise branch is reachable

Fix: https://github.com/rust-lang/rust/commit/a22fed77686db50c1185e4267743924ac50f584a

The injection is the reverse of the fix's implementation hunks, applied to 1.99.1 (clean).
