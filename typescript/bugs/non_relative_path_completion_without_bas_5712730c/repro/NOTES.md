Language-service completions inside `import ... from "module1/w` with only `paths` (no baseUrl) in tsconfig.
Clean: suggests "whatever" from the paths mapping. Injected: non-relative path completion skips `paths` without baseUrl, so no entries (undefined/empty).
