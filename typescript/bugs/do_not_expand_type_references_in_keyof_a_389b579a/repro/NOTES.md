Two files: a.ts exports an arrow function using `O["prop"]` and `keyof O` on a local type O; b.ts imports and re-exports it.
With --declaration, the clean build keeps the original type syntax in input.d.ts, with `O["prop"]` and `keyof O` on the local alias.
The injected build expands type references in indexed access and keyof, so the output differs.
