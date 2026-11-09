input.ts returns an `any[]` as the generic variadic tuple `[...T, ...P]`, which is an assignability error.
Clean reports "Source provides no match for variadic element at position 0 in target."
Injected reports "Target requires 2 element(s) but source may have fewer." because it mishandles variadic targets without a rest element.
