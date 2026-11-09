Input: packages/app/tsconfig.json has `paths: {"@/*": ["./*"]}`; app/lib/index.ts uses `Tooltip`, exported from sibling package ../common/lib.ts. ls.mjs asks the language service for the add-import code fix with a non-relative preference.
Clean: the specifier is `../../common/lib` (a paths match whose star part is relative is rejected).
Injected: `@/../common/lib`, a specifier with `..` in the middle.
