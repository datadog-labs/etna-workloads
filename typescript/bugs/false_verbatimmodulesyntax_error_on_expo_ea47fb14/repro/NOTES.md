Input: an `export namespace` with a value member in an ES module, compiled with `--module esnext --verbatimModuleSyntax`.
Clean: no diagnostics. Injected: a false verbatimModuleSyntax error, because the check no longer requires the file to emit as CommonJS.
