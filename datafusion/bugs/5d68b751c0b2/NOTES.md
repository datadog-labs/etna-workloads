repro.sql calls `trunc(x, 1)` on Float64 and Float32 values whose next digit is >= 5 (3.76, -2.99, 1.96).
Clean build truncates (3.7, 3.7, -2.9, 1.9). Buggy build rounds instead (3.8, 3.8, -3.0, 2.0).
