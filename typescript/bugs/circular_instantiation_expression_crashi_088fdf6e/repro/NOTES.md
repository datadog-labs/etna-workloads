Input declares `foo<T>(t: T): typeof foo<T>` (a circular instantiation expression) and uses `foo("")`, compiled with `--declaration`.
Clean: declaration emit terminates with an elided placeholder for the circular type.
Injected: the visitedTypes check is missing, so the declaration emit differs (exit status and output differ; the type printer recurses/errors).
