Input: a module with a top-level `for await` loop, compiled with `--module preserve --target esnext`.
Clean: no diagnostics. Injected: reports an error that top-level `for await` is not allowed,
because `ModuleKind.Preserve` was removed from the allowed-module list in the checker.
