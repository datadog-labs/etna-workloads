main.ts uses object rest with --importHelpers under moduleResolution bundler; a fake tslib has conditional exports whose "types" is only in modules/index.d.ts.
Clean: tslib resolved from the import-helpers specifier's mode, no errors, exit 0.
Injected: resolved using the file itself, so TS2354 "requires an imported helper but module 'tslib' cannot be found" is reported, exit 2.
