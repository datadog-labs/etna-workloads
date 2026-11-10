Input: a package `repo` with `exports: {"./*": "./src/*"}` and `src/card.tsx`; `main.ts` has `import { } from "repo/"`. Options are moduleResolution bundler, allowImportingTsExtensions and jsx. The script asks the language service for completions after `repo/`.
Clean: the completion is the full file name `card.tsx`, because extensions can't be dropped for exports wildcards.
Injected: the extension is dropped or changed (for example `card`), because the wildcard filtering of allowed endings is missing.
