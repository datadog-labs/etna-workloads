Two files: type.ts exports an enum and a type using a computed property name `[Enum.A]`; index.ts spreads a value of that type into an exported const, so declaration emit must serialize the computed name.
Clean: emits index.d.ts normally (exit 0). Injected: declaration emit crashes on a Debug.assertNode failure (non-literal-type computed name), with a different exit status and no output.
