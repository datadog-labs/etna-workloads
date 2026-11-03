repro.sh builds a two-package module where non-generic a.F calls generic a.g[int], with -gcflags=-m.
Clean: main reports "inlining call to a.g[go.shape.int]" (transitive inlining through a.F).
Buggy: that line is missing; g's instantiation isn't passed to CanInline, so it isn't inlined into main.
