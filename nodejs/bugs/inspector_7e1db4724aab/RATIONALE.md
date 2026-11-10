# Re-introduced bug

`DOMStorage.getDOMStorageItems` falls back to reading the live Storage object when its cached map is empty. If `getWebStorage()` returns nothing (no `--localstorage-file`, so `globalThis.localStorage` is missing), the fallback is skipped and the command answers Success with an empty entries array. A frontend cannot tell an empty store from an unreadable one. `Storage.getStorageKey` also calls `std::filesystem::absolute("")`, which throws under libstdc++ and aborts the process because Node builds without exceptions.

## Hunks
- `src/inspector/dom_storage_agent.cc`: matches the fix's `dom_storage_agent.cc` hunk. The current code has a `ServerError("...storage is unavailable")` early return, and I replaced it with `if (web_storage_obj) { ... }` around the rest of the fallback. When no storage is available the map stays empty and the command returns Success with no entries, as before the fix.
- `src/inspector/storage_agent.cc` and `storage_agent.h`: match the fix's `storage_agent.*` hunks. `to_absolute_path` returns a plain `std::string` again and uses the throwing `absolute()` and `weakly_canonical()` overloads. `getStorageKey` no longer reports an error.

## Failing test
`parallel/test-inspector-dom-storage` fails at the second `spawnSyncAndExitWithoutError` call, which runs `test-inspector-dom-storage-unavailable.mjs`. The child exits with status 1 because `session.post('DOMStorage.getDOMStorageItems')` resolves instead of rejecting with `ERR_INSPECTOR_COMMAND` / "Could not read DOM storage items". The parent reports "process terminated with status 1, expected 0".
