# Adapted injection for Apply `Recovery::Forbidden` when reparsing pasted macro fragments.

Fix: https://github.com/rust-lang/rust/commit/b9e13cb539c23a320e3856eba82711cd6360407e

# Rationale
File: compiler/rustc_parse/src/parser/mod.rs, fn `maybe_whole_with`-style reparse helper (the fn containing `OpenInvisible(MetaVar)` handling, ~line 650).
Re-expresses fix hunk `@@ -770,7 +778,14 @@`: the fix replaced `let res = f(self).expect(...)` with `self.with_recovery(Recovery::Forbidden, |this| f(this)...)`. I removed the `with_recovery(Recovery::Forbidden, ..)` wrapper so `let res = f(self);` runs with recovery allowed, as before the fix. (`with_recovery` helper hunk #1 left in place; it is now unused by this path but still exists.)
