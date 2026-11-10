Input: a language-service script (run.mjs) with in-memory project using `paths` mappings; `myFunctionB` is exported from both `withIndex/b.ts` and re-exported from `withIndex/index.ts`.
It requests "Add import" code fixes for the undefined names under importModuleSpecifierPreference non-relative / relative / project-relative.
Clean: the preference is respected in fix ordering (e.g. non-relative lists "~/withIndex" before "../withIndex/b").
Injected: the preference is ignored when sorting fixes for the same symbol from different files, so the order differs.
