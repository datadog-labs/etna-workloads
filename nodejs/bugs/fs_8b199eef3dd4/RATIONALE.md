# Re-introduced bug: fs.chown/lchown/fchown reject -1

**Bug:** `-1` ("don't change") for uid/gid passed to chown, lchown, fchown hit a strict `CHECK(value->IsUint32())` in `FromV8Value<uv_uid_t>`, aborting the process instead of being treated as (uid_t)-1.

**Hunks (all in src/node_file.cc, matching the three node_file.cc hunks of the fix):**
- `Chown`, `FChown`, `LChown`: `FromV8Value<uv_uid_t, true>` / `<uv_gid_t, true>` (loose) changed back to the strict `FromV8Value<uv_uid_t>` / `<uv_gid_t>`. Strict mode CHECKs `IsUint32()`, which fails for -1. The util-inl.h `loose` template parameter is left in place (the file has been refactored since; without callers using it, the old behaviour is restored).
  
**Failing tests (stable over 2 runs):** parallel/test-fs-chown-negative-one, test-fs-fchown-negative-one, test-fs-lchown-negative-one — "not ok" (process aborts on the CHECK failure).
