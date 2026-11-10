Input: projD/index.ts re-exports `{e}` from projC, whose .d.ts has a type `import("../projA").Foo`; tsc emits declarations for projD.
Clean: emitted index.d.ts contains `import("../projA").Foo`.
Injected: the copied import type node isn't reused/visited correctly, so the emitted .d.ts contains garbage like `import({e};).Foo`.
