Input: an in-memory case-insensitive tsserver host (run.js) with two composite projects, a node_modules symlink to a lowercase path, and the file opened via its lowercase path; then a `rename` request on `myFunc`.
Clean: rename locations are deduplicated case-insensitively, so index.ts of project1 appears once.
Injected: documentSpansEqual compares file names case-sensitively, so project1/index.ts is listed twice (`/t/...` and `/T/...`).
