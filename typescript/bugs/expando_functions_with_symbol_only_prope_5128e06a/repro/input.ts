const symb = Symbol();

interface TestSymb {
  (): void;
  readonly [symb]: boolean;
}

export function test(): TestSymb {
  function inner() {}
  inner[symb] = true;
  return inner;
}
