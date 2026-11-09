Input: object literal with null properties p, s spread with a union-normalized object literal result, under noImplicitAny without strictNullChecks.
Clean: reports TS7018 at input.ts(16,3) and (17,3) (property locations).
Injected: reports TS7018 without file/location.
