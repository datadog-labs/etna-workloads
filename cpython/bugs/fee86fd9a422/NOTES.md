computeRollover at exactly the atTime moment: clean rolls over 86400s later; buggy (`r < 0` instead of `r <= 0`) returns 0, i.e. rolls over immediately.
