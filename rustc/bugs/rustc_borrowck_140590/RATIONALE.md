# Adapted injection for borrowck nested items in dead code

Fix: https://github.com/rust-lang/rust/commit/ffa7d1ee5dba9d0a9979d784a5c38e3a05a5ff9e

# Re-injected bug: nested bodies in dead code not borrowchecked

File/function: compiler/rustc_borrowck/src/root_cx.rs, `BorrowCheckRootCtxt::do_mir_borrowck`.

Re-expresses fix hunk `@@ -127,6 +127,14 @@ fn mir_borrowck(` in rustc_borrowck/src/lib.rs, which added
`let nested_bodies = tcx.nested_bodies_within(def); for def_id in nested_bodies { root_cx.get_or_insert_nested(def_id); }`
("We need to manually borrowck all nested bodies from the HIR as we do not generate MIR for dead code").
In 1.99.1 the code was restructured: `do_mir_borrowck` iterates all of `nested_bodies_within(root)`.
I restored the old behaviour by only borrowchecking bodies discovered from MIR (closure/coroutine
Aggregate rvalues, starting from the root), so closures in dead code are skipped again.
The other fix hunks (renames stalled_generators -> nested_bodies, etc.) are refactors already applied in 1.99.1 and not needed.
