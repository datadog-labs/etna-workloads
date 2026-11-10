# Adapted injection for Check AttrId for expectations.

Fix: https://github.com/rust-lang/rust/commit/94f8347bae7404d894f4e6dc57fb64e63e8efb73

# Rationale
File: compiler/rustc_lint/src/expect.rs, fn `check_expectations`.

The fix replaced the "unstable AttrId -> stable id via first HirId" mapping with comparison by (AttrId, lint_index).
The relevant hunk is `@@ -61,24 +30,43 @@ fn check_expectations`, which adds `canonicalize_id` and `fulfilled_expectations.iter().map(canonicalize_id)`.
The parent commit tied each AttrId to only the first HirId (`unstable_to_stable_ids.entry(attr_id).or_insert(expect_id)` in the `lint_expectations` hunk).
On 1.99.1 the rustc_errors buffering is already gone, so I re-expressed the old behaviour in the check itself.
I keep a map from AttrId to the first HirId seen, and an expectation counts as fulfilled only if its HirId is that first one.
Expectations seen at any later HirId are reported as unfulfilled.
