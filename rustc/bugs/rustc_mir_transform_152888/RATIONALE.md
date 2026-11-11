# Adapted injection for Fix Async Drop MIR bug with async_drop_in_place (Squashed)

Fix: https://github.com/rust-lang/rust/commit/ce93a5335de4315a09f93a9cb0569baa47cbc3c2

# Rationale
File: compiler/rustc_mir_transform/src/elaborate_drop.rs, fn `build_async_drop`.

Re-expresses both hunks of fix.diff:
- `@@ -326,12 +326,23 @@` (added `succ_with_dead` intermediate block with `StorageDead(fut)` -> goto `succ`, used as Drop target). In 1.99.1 the block already existed earlier in the function; I replaced it with `let succ_with_dead = succ;` so no per-edge StorageDead block exists (loop-back edges miss StorageDead).
- `@@ -381,12 +392,6 @@` (removed `// StorageDead(fut) in self.succ block (at the begin)` patch add_statement at `Location { block: self.succ, statement_index: 0 }`). I restored that patch, i.e. the old buggy behaviour: StorageDead is put at start of `self.succ` rather than on the path to `succ`.
