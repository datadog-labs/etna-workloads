# Rationale

Hunk reversed: `Lib/random.py`, `Random.binomialvariate`, BG (geometric) branch.
The fix wrapped `y += _floor(_log2(random()) / c) + 1` in `try/except ValueError: continue`
so a `random()` result of 0.0 (which makes `log2` raise) is rejected and redrawn.
v3.15.2 already had this, with a different comment. I removed the try/except, which
restores the pre-fix bare statement.

Failing oracle case: `test.test_random.TestDistributions.test_binomialvariate_log_zero`.
With `random()` patched to return 0.0 first, `binomialvariate(10, 0.5)` raises
`ValueError: expected a positive input, got 0.0`.
