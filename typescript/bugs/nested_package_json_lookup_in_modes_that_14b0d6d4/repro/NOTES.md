Input: `main.ts` imports "@restart/hooks/useMergedRefs", a subpath with a nested package.json (types -> ../esm/useMergedRefs.d.ts), under bundler resolution (exports-respecting).
Clean: resolves via the nested package.json, no errors, exit 0.
Injected: nested package.json is skipped in exports-respecting modes, so TS2307 "Cannot find module" is reported, exit 2.
