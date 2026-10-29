repro.sql casts strings with leading whitespace to INTEGER/REAL.
The injection removes leading-whitespace skipping in the integer and real parsers.
Clean: 9223372036854775807, then 12|1.5. Buggy: 0, then 0|0.0.
