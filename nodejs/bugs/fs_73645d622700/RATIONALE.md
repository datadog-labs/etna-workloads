# Rationale

**Bug:** A Blob created from an empty file (`openAsBlob`) had `size === 0`, and `Blob.arrayBuffer()/text()/stream()` short-circuited on size 0 without ever consulting the file-backed handle. If the file was later written to, the blob was not invalidated; reads returned empty data instead of rejecting with `NotReadableError`.

**Changes (lib/internal/blob.js only):**
- Fix hunk 1 (removed the `ArrayBuffer`/`PromiseResolve` imports) -> re-added both primordials imports, needed by the shortcut.
- Fix hunk 2 (removed `if (this.size === 0) return PromiseResolve(new ArrayBuffer(0))` from `arrayBuffer()`) -> re-added this shortcut at the top of the shared `arrayBuffer(blob)` helper (today `arrayBuffer()`, `text()` and `bytes()` all go through it).
- Fix hunk 3 (removed the size-0 early return of an immediately closed stream in `stream()`) -> re-added in `stream()`.

**Failing test:** `parallel/test-blob-file-backed` fails (stable across 2 runs): `AssertionError [ERR_ASSERTION]: Missing expected rejection (NotReadableError).`
