repro.go is upstream test issue80517_2.go. trigger(-2) computes n>>1, then runs make([]byte, n), which only proves n >= 0 after it executes.
Clean: exits 0. Buggy: prove uses that fact for the earlier shift, turns it into an unsigned shift, and returns 9223372036854775807 instead of -1, so the program panics.
