# Rationale

**Bug:** `import.meta.resolve("foo", "http://example.com/bar.js")` makes `GetPackageScopeConfig` (src/node_modules.cc) build a package.json URL for a non-file base. `url::FileURLToPath` fails on it, and the result is not checked, so the process aborts on a `CHECK` instead of throwing `ERR_INVALID_URL`.

**Hunk (src/node_modules.cc, loop in `BindingData::GetPackageScopeConfig`):** it corresponds to the fix's single hunk. The `if (!file_url) { url::ThrowInvalidURL(...); return; }` block is replaced with `CHECK(file_url);`, which is the pre-fix code. The line numbers differ from the original diff, but the code is the same.

**Failing test:** `es-module/test-esm-import-meta-resolve` fails (`not ok`). The new subtest spawns a child process that hits the CHECK abort. The child therefore doesn't print ERR_INVALID_URL on stderr and doesn't exit with code 1.
