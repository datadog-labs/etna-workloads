repro.sh compiles a file with `//go:build go1.21` (which upgrades its effective version) under `-lang=go1.19`, instantiating `comparable` with `any` (needs go1.20).
Clean: accepted, exit=0. Buggy: allowVersion(nopos, ...) ignores the file version and falls back to the -lang version, so it reports "any to satisfy comparable requires go1.20 or later (file declares //go:build go1.21)", exit=1.
