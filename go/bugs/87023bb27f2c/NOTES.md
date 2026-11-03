repro.go declares `B = A`, `A = Y0+...+Y99`, and `Yi = B`, which makes 100 equivalent initialization cycles through B.
`go build` reports the cycle path for B. The clean toolchain sorts deps by declaration order in findPath, so it always reports `A refers to Y0`.
The buggy toolchain iterates the deps map in random order, so it reports a random Yi. That gives about a 99% chance of different output on each run.
