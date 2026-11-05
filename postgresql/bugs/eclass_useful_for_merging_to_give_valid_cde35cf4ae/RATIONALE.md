# Rationale
- File/function: src/backend/optimizer/path/equivclass.c, eclass_useful_for_merging.
- Traces to the fix.patch hunk that added the "If specified rel is a child, we must consider the topmost parent rel" block. The block (now using rel->top_parent_relids) is removed, so `relids = rel->relids` is always used.
- Why this brings the bug back: for appendrel child rels, the subset and overlap tests use the child's own relids instead of the topmost parent's. The function then gives wrong answers for children, so pathkeys_useful_for_merging misjudges them.
- The signature keeps the `root` parameter, which is harmless.

Failing oracle case: src/test/regress||inherit (expected)
