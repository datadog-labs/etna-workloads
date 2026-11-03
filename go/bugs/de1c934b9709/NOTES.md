repro.sh builds with -d=checkptr a program doing `(*[10]int64)(p)[:n:n]` with n=1000 (out of range).
Clean: checkptr runs after the slice bounds check, so a normal "slice bounds out of range" panic is recovered.
Buggy: checkptr runs before the bounds check and throws a checkptr failure instead (fatal, not recoverable / different message).
