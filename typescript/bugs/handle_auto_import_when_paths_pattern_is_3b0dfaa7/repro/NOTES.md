Language-service code-fix (missing import for `one`) in an in-memory project whose `paths` pattern is absolute (`@root/*` -> `/proj/src/*`, no baseUrl).
Clean: the fix offers the import from "@root/one" (absolute pattern made relative to the base directory).
Injected: the absolute pattern is not relativized, so the `paths` specifier is not produced and a different specifier (e.g. relative) is offered.
