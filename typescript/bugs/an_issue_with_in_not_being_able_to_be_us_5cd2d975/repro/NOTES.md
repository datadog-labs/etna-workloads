input.ts narrows `table: T extends object | null` via `!!table` and then uses `'html' in table`.
Clean build: no errors. Injected build: TS2638 "Type 'NonNullable<T>' may represent a primitive value" on the `in` operand, exit 2.
