repro.go is the issue73716 test program (closure wrapped in a type conversion, called directly, inside a loop), with h initialised so it runs cleanly.
Clean: prints ep2, ep1, exits 0. Buggy: compile fails with "internal compiler error: panic: hashed refs unsupported for now" (closure LSym missing when the call goes through an OCONVNOP).
