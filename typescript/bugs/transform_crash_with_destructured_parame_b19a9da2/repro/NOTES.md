Input: a class whose constructor has parameter properties declared with binding patterns (`public [x, y]`, `private {a, b}`), targeting ES2022 (class fields emitted).
Both builds report TS1187 and emit JS.
Clean skips the destructured parameter properties, so the class has no fields. Injected emits bogus field declarations `[x, y];` and `{ a, b };` in the class body.
