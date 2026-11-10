usage.ts imports `Something`, which prelude.ts defines as both a type alias and an `export * as Something` namespace re-export (merged alias).
usage.ts then refers to the type `Something.SubType<string>` and calls `Something.of`.
Clean: compiles without errors. Injected: the qualified name `Something.SubType` fails to resolve through the merged alias, so tsc reports a diagnostic.
