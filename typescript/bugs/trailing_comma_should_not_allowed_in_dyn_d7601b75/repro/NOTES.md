input.ts has a dynamic import with a trailing comma, `import("./foo",)`, compiled with --module commonjs.
Clean: reports error TS1009 (trailing comma not allowed).
Injected: the trailing-comma grammar check is skipped, so no TS1009 is reported.
(Both builds report the missing module ./foo.)
