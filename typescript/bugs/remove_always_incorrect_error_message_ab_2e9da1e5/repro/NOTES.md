Input imports a nonexistent "./missing.ts" under --moduleResolution bundler (no allowImportingTsExtensions).
Clean build reports the generic "Cannot find module" error (TS2307).
Injected build instead reports the removed TS2691 "An import path cannot end with a '.ts' extension" error.
