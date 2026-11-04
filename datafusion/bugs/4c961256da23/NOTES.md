repro.sql calls `log(base, decimal)` with integer bases on non-power decimal values.
The buggy build floors the result with an integer `ilog` (e.g. log(10, 12600) = 4.0,
log(2, 10^35) = 116.0, log(10, 12600.5) = 4.0). The clean build returns the
fractional value (4.100..., 116.267..., 4.100...).
