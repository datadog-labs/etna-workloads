Input: `for (await using of x);` inside an async function (a `using` declaration list with no declarations, i.e. `of` is parsed as the keyword).
Clean: tsc reports TS1123 "Variable declaration list cannot be empty" (checker) and the emit succeeds.
Injected: the TS1123 error is missing because the grammar check falls through (`return false` added), and with an es2022 target the esnext transform asserts on the empty declaration list and crashes.
