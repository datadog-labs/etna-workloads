Input: `interface I { constructor: number; }` and `class C implements I {}`; the script asks the language service for the "Implement interface 'I'" code fix.
Clean: the inserted member is `["constructor"]: number;` (computed name).
Injected: the member is inserted as plain `constructor: number;`, which is invalid.
