async function* inner() { yield 1; return 2; }
export async function* outer() { yield* inner(); }
