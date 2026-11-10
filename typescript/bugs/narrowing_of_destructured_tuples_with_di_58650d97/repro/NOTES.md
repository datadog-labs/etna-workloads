input.ts destructures a parameter `[x, y]: [1, 2] | [3, 4] | [5]` and narrows `x`/`y` by comparing with literals (`y === 2`, `x === 1`, `x === 5`).
Clean: no diagnostics. Injected: bogus TS2493 "Tuple type '[5]' of length '1' has no element at index '1'" at the `y` binding, because the narrowed parent type is now bounds-checked.
