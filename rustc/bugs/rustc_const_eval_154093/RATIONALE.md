# Verbatim injection for const validity checking: do not recurse to references inside MaybeDangling

Fix: https://github.com/rust-lang/rust/commit/b3e4ebd9d27b1367016b1ff83e320d953383d3a5

The injection is the reverse of the fix's implementation hunks, applied to 1.99.1 (fuzzy-patch).
