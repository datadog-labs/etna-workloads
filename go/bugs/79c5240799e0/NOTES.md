repro.sh builds a module where packages b and c each return `a.T[int]{}` (an instantiated generic type from package a) as interface{}, then main compares `b.F() == c.F()`.
Clean toolchain prints `true`. Buggy toolchain prints `false`: the instantiated type's descriptor is not marked DUPOK, so b and c get distinct type descriptors and interface equality fails.
