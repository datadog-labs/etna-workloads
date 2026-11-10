Input declares functions whose rest parameter has a tuple type built by spreading labeled tuples with duplicate labels (`[...A, ...A]`), with --declaration.
Clean emits the .d.ts with unique parameter names (`s`, `s_1`, ...); injected emits duplicate names (`s: string, s: string`), an illegal declaration.
