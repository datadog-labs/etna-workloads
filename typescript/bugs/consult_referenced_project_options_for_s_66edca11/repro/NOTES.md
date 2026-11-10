lib is a composite project (module esnext) emitting out/a.d.ts with no default export; app (module esnext, bundler) references it and does `import d from "../lib/out/a"`.
Clean: reports error TS1192 (no default export; synthetic default disallowed because referenced project is ESM).
Injected: ignores the referenced project's module format, allows synthetic default, so no error.
