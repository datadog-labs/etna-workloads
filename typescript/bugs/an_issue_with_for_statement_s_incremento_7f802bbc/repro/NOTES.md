Input: a `for` loop whose incrementor `i = iNext` is reached via `continue` after `iNext = "bad"` (string | number variable).
Clean: the continue flows into the incrementor, so iNext is `string | number` there and tsc reports error TS2322 on `i = iNext`.
Injected: continue targets the loop head, skipping the incrementor's flow, so iNext is narrowed to number and no error is reported.
