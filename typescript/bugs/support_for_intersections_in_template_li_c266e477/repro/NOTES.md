Input declares a parameter of type `"downcast" | "dataDowncast" | "editingDowncast" | `${string & {}}Downcast``; show.cjs prints the parameter's type via the public API.
Clean: string literals matched by the template are removed: `"downcast" | `${string & {}}Downcast``.
Injected: `string & {}` placeholder isn't recognized as a pattern, so all literals are kept.
