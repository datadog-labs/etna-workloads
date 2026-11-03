repro.sh compiles a function whose named result `r` is heap-allocated (its address is stored in a global) and returns parameter `p`, with `-gcflags=-m`.
Clean: "leaking param: p" (flows to heap). Buggy: "leaking param: p to result r level=0", which is wrong because r lives on the heap (issue 44614).
