Runs the "Move to a new file" refactor via the language service on a file with `a` and `b`, using a `paths` alias `@foo/*` and importModuleSpecifierPreference "non-relative".
Clean: the rewritten a.ts imports from "@foo/b". Injected: the preference is ignored, so the import is the relative "./b".
