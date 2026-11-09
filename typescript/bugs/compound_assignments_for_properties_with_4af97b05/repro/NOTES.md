Class C has accessor `x` with getter type `number` and setter type `number | string`; the input does `c.x += "a"`.
The result is a string, which is assignable to the setter type but not the getter type.
Clean: no diagnostics. Injected: it checks against the getter type and reports error TS2322 (string not assignable to number).
