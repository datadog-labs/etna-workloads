# Rationale

**Bug:** `InternalModuleReadJSON` (now the C++ package.json reader in `src/node_modules.cc`) treated a package.json with none of `main`/`exports`/`type` (e.g. `{}` or empty) as nonexistent, so lookup continued to the parent package.json. A nested `{}` package.json therefore inherited the parent's `"type": "module"`, and a CJS file was loaded as ESM.

**Change:** one hunk in `BindingData::GetPackageJSON`. It corresponds to the fix's `node_file.cc` hunk (`return;` vs. returning `"{}"`; the `env.h` string has no equivalent now). The original function is gone, so after parsing, a config with no main, exports or type (type == "none") is cached as absent and `nullptr` is returned. This restores the pre-fix behaviour.

**Failing test:** `es-module/test-esm-default-type` fails (stable across 2 runs): `SyntaxError: The requested module '.../nested-default-type/module.js' does not provide an export named 'default'`.
