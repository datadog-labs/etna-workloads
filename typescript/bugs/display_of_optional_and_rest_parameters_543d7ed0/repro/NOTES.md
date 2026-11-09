Input: a union of two function types, one with a rest parameter `...rest: string[]`, declared in input.ts.
q.mjs uses the public API to print the type and the call signature of the union (the resolved combined signature).
Clean prints `...rest: string[]` in the combined signature; injected loses the rest flag and prints it as a plain parameter (`rest: string[]`).
