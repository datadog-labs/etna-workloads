repro.sql runs median() over Int8 values -128/127 and over int 1..6, also printing arrow_typeof.
Clean: Float64 results (-0.5, 3.5). Buggy: median returns the input integer type, truncating to 0 and 3 (Int8/Int32).
