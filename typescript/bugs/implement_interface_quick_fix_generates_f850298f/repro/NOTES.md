Input: `class Foo implements Disposable {}` where `Disposable` is declared (with `[Symbol.dispose](): void`) in both the esnext lib and an extra ambient .d.ts, queried via the language service "Implement interface" code fix.
Clean: skips ambient signatures, so the generated class has the method once.
Injected: the ambient-signature skip is gone, so the method is generated more than once (duplicate declarations).
