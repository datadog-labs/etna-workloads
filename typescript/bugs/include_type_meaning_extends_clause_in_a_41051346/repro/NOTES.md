Language-service script: `/g.d.ts` declares a global `interface Foo`, `/d.ts` exports `declare class Foo`, and `/b.ts` has `class C extends Foo {}`, which gives error 2689.
It asks for code fixes at `Foo` for error 2689.
Clean build: the fix list includes `Add import from "./d"` plus "Change 'extends' to 'implements'".
Injected build: 2689 is missing from the import fixer's error codes, so the import fix is absent and only the implements fix is offered.
