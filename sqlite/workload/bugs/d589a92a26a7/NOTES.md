round() with the bug returns TEXT (via "%.*f") instead of REAL.
`typeof(round(5.1,1))` gives `text` on the buggy shell and `real` on the clean one; round(2.5,0) prints `3` vs `3.0`.
