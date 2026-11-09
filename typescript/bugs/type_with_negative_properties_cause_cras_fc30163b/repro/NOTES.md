input.ts exports an object literal with a negative numeric property (`[-1]`), and repro.sh runs tsc to emit the .d.ts.
Clean emits the property name as `[-1]` (a prefix-minus expression); injected emits `[1]` (a positive numeric literal), which is wrong and loses the sign, or crashes.
