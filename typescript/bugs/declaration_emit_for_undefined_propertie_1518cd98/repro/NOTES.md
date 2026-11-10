Input: `export let b = [{ foo: 0, m() {} }, { bar: 1 }];` emitted with --declaration.
Clean: the .d.ts normalizes the second element type to include `m?: undefined`.
Injected: the `m?: undefined` member is missing from the second union member.
