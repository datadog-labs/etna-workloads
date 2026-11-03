repro.sh compiles a small package (big-endian byte loads/stores) with GOAMD64=v1 and `-gcflags=-S`, then counts the BSWAP/MOVBE instructions emitted.
Clean: BSWAPL/BSWAPQ (MOVBE is only used for GOAMD64>=v3). Buggy: the injection drops the `GOAMD64 >= 3` guard, so MOVBEL/MOVBEQ are emitted for the v1 baseline, which can SIGILL on CPUs without MOVBE (and is what TestGoAMD64v1 catches).
It sets a private GOCACHE so the two toolchains don't share cached -S output.
