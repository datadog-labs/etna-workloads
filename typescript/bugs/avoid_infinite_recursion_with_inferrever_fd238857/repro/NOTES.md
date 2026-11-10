Input: recursive homomorphic mapped types Foo<V> and Bar<any>, passed to `test<V>(value: Foo<V>): V` (reverse-mapped type inference), then the result is assigned to `number` to expose the inferred type.
Clean: inference terminates and reports a diagnostic on the assignment.
Injected: the recursion guard (#57837) is missing, so the diagnostics/output differ (different inferred type or stack overflow).
