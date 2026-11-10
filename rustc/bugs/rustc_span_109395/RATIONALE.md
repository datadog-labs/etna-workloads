# Adapted injection for Fix issue when there are multiple candidates for edit_distance_with_substrings

Fix: https://github.com/rust-lang/rust/commit/a860a720baa508aa28d44f4d277814a086d6bd9d

# Rationale
File: compiler/rustc_span/src/edit_distance.rs, fn `find_best_match_for_name_impl`.
Re-expresses fix hunk `@@ -198,12 +199,27 @@`: removes the `if use_substring_score { dist = d; next_candidates.push(*c); ... } else {...}` branch, restoring the unconditional `dist = d - 1; best = Some(*c);`, and removes the `if next_candidates.len() > 1 { best = find_best_match_for_name_impl(false, &next_candidates, ...) }` tie-break and the `next_candidates` vec (hunk `@@ -190,6 +190,7 @@`). The `lookup_symbol` rename is harmless and kept.
Effect: with substring scoring, the last candidate wins instead of re-ranking ties, so `forced_capture` suggests the wrong name.
