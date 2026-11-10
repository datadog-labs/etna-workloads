# Re-introduced bug: internalModuleStat binding API (fix 5ed1bcbd9b9e)

Before the fix, `internalModuleStat` took a legacy leading receiver argument (`internalModuleStat(binding, path)`) and read the path from `args[1]`, a leftover of the old V8 fast-API signature. The fix made it a plain `internalModuleStat(path)` (`args[0]`, exactly one arg). In this release the fast path itself no longer exists, so I restored the old calling convention instead.

## Hunks
- `src/node_file.cc` `InternalModuleStat`: corresponds to the fix's hunk changing `CHECK_GE(args.Length(), 2)/args[1]` to `CHECK_EQ(1)/args[0]`; reverted to `CHECK_GE(args.Length(), 2)`, `args[1]`. The fast-path hunks (FastInternalModuleStat, node_external_reference.h) have no counterpart in the release.
- `lib/internal/modules/helpers.js`, `lib/internal/fs/utils.js` (2 sites), `lib/internal/fs/cp/cp.js`, `lib/internal/fs/cp/cp-sync.js`: correspond to the fix's lib hunks removing the `binding` first argument (fs.js, promises.js, loader.js, resolve.js, package_json_reader.js there; those callers now live in these files); the leading binding argument is re-added so existing callers work with the old C++ signature.

## Failing test
`parallel/test-permission-fs-internal-module-stat` fails (stable over 2 runs): `Assertion failed: (args.Length()) >= (2)` at src/node_file.cc:1122, abort (exit -6), because the test calls `internalModuleStat(blockedFile)` with one argument.
