Input assigns identical generic function types whose conditional type checks against a branded template literal (`${'a' & {a:1}}`) or Uppercase<'a' & {a:1}>.
Clean: no errors (exit 0). Injected: TS2719 "Two different types with this name exist" on `a = b` and `c = d` (exit 2), because identical template/string-mapping types are no longer related structurally.
