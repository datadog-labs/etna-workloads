# Adapted injection for Fix handling slices of empty types

Fix: https://github.com/rust-lang/rust/commit/c1b29b338dc37f96f0695e393743ce35508d3704

# Rationale
File: compiler/rustc_pattern_analysis/src/constructor.rs, `ConstructorSet::split`.
The old `ConstructorSet::SliceOfEmpty` variant is now `ConstructorSet::Slice { array_len, subtype_is_empty }`.
I added an arm `Slice { array_len: None, subtype_is_empty: true }` that restores the pre-fix behaviour
("Behaves essentially like `Single`"): a single `[]` constructor, put in `missing` if nothing was seen, else `present`.
This re-expresses the hunk `@@ -1121,12 +1124,22 @@ ... ConstructorSet::SliceOfEmpty =>`, which removed
`let slice = Slice(Slice::new(None, FixedLen(0))); if seen.next().is_none() { missing.push(slice) } else { present.push(slice) }`
and replaced it with splitting by slice length where only `[]` can be missing.
