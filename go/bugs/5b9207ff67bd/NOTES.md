repro.sh writes a small module (generic Builder[T] with a method, used from another package via a package-level Builder[int]{}), the shape of test/typeparam/issue50121.go, and runs it.
Clean: prints "ok", exit 0.
Buggy: the injected bug (reader.go skips the existing-definition lookup for shaped dictionaries) causes "internal compiler error: already have a definition for ...[go.shape.X]" while compiling std packages (sync/atomic, internal/strconv, ...), so the build fails with exit 1.
Note: the ICE hits the standard library, so on a cold build cache even trivial generic-using programs trigger it.
