Project `web` uses `paths` (`@common/*` -> `../common/dist/src/*`) and references the composite project `common`; Helper.ts uses `square` without importing it.
The script asks the language service for code fixes for "Cannot find name" (2304) with non-relative import preference, using source of project reference redirects.
Clean: offers `Add import from "@common/MyModule"`. Injected: skips the redirect path and offers `Add import from "../../common/src/MyModule"`.
