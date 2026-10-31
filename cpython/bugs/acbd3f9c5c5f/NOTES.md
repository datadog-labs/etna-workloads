Extracts a tar holding symlink `sub/link -> ../target` with `filter='data'`.
Clean: the link target is resolved relative to `sub/`, so it stays inside the destination and extraction succeeds (prints `ok ../target`).
Buggy: the target is resolved relative to the destination root, so it looks outside and `LinkOutsideDestinationError` is raised.
