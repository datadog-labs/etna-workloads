repro.sql selects a 308-nines real literal and 1234.5 followed by 400 zeros and 12345.
The bug removes the overflow guard in sqlite3AtoF's digit loop, so the significand wraps around.
Clean: 1.0e+308 and 1234.5. Buggy: 7.7662796314522423e+306 and 0.0.
