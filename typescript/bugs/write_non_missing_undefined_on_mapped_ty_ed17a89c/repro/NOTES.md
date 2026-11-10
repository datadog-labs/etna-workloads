input.ts defines a mapped type with an `as` clause and optional `?:` property whose template includes `| undefined`, intersected and used in an inferred exported const.
With --exactOptionalPropertyTypes --declaration, the emitted .d.ts is printed.
Clean: `foo?: string | undefined;`. Injected: `foo?: string;` (the explicit undefined is dropped).
