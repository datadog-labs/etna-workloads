input.ts has an empty block followed by `{ a } = ...`, triggering parser error TS2809.
Clean prints "...wrap the whole assignment in parentheses."; injected prints "wrap the the whole assignment" (duplicated "the").
