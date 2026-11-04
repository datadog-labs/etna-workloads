repro.sql runs corr() over a single row and over zero-variance input. Clean build returns NULL (as fixed upstream); buggy returns 0.0.
