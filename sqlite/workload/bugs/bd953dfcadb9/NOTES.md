repro.sql sums a single +/-9e999 (infinity) value with sum(), avg(), total().
The extended-precision error term becomes NaN (Inf-Inf), and the injected bug drops the
NaN check in sumFinalize. Clean prints `Inf|Inf|Inf` / `-Inf|-Inf|-Inf`;
buggy returns NULL (NaN) for sum(): `|Inf|Inf` / `|-Inf|-Inf`.
