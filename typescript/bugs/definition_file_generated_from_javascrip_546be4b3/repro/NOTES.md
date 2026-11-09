Input `a.js` exports an object literal containing a getter (`get getter()`); tsc emits declarations with allowJs.
Clean: the .d.ts includes the `readonly getter: string` property.
Injected: the accessor property is missing from the generated .d.ts (accessor flag dropped in the symbol-export check).
