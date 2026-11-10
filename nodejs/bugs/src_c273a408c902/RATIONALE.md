# Rationale

**Bug:** In the fs permission radix tree, `NextNode` matched a child's prefix by iterating over the *path* length and returning the child as soon as `i >= prefix_len || prefix[i]=='*'`. The loop index was compared against the prefix from position 0 of the path rather than being bounded by the prefix, so a wildcard node directly under the root could be matched (and a grant produced) for paths that are shorter than/removed the `*` and its preceding char, e.g. grant `/tmp/test*` wrongly allowed `/tmp/tes`.

**Hunk:** `src/permission/fs_permission.h`, `RadixTree::Node::NextNode`: changed the loop from `for (i < prefix_len) { if (prefix[i]=='*') ...}` back to the pre-fix `for (i < path.length()) { if (i >= prefix_len || prefix[i]=='*') return child; ...}`. This corresponds to the single hunk of the fix, re-expressed (today's code also has the `idx` / optional-trailing-separator logic, left untouched).

**Failing test:** `parallel/test-permission-fs-wildcard` reports `not ok` (the new block's `process.permission.has` assertions fail, e.g. `!has('fs.read','/tmp/tes')`). Verified twice.
