# Re-introduced bug (upstream 08ae8401f187)

**Bug:** With `--experimental-detect-module`, the default resolve step runs without `source`. For an extensionless file in a package with no `type` field, `getFileProtocolModuleFormat` returned `'commonjs'` instead of `null`. That was a wrong format hint: resolve hooks saw `format: 'commonjs'` for ESM-syntax files, and the loader then took the wrong path.

**Change (lib/internal/modules/esm/get_format.js, `ext === ''` branch):** `if (!source) return null;` became `return 'commonjs';`. This corresponds to the fix's get_format.js hunk, where the extensionless branch returns `null` when detect-module is on and there is no source. The release has since moved that logic into `detectModuleFormat`, so I changed only the extensionless branch. Without source it again reports a definite `'commonjs'`.

The upstream load.js hunk is not re-expressed. The release's loader has been rewritten, and the get_format change alone brings the failure back.

**Failing test:** `es-module/test-esm-detect-ambiguous` fails ("not ok") on both runs. It fails on the `noext-esm` case: stdout is `''` where `'executed\n'` is expected. The stderr shows `ERR_REQUIRE_CYCLE_MODULE: Cannot require() ES Module .../package-without-type/noext-esm in a cycle`. I did not see the upstream-added "should not hint wrong format in resolve hook" case reported separately, because I only inspected the first failures in the output.
