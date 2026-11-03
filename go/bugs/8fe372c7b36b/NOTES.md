Reproducer repro.sh uses -gcflags=-m on a function returning a method value (issue 18493). Clean reports 'can inline getMeth' and 'inlining call to getMeth'; buggy does not, since OMETHVALUE blocks inlining.
Both toolchains report themselves as plain go1.27.3, so they share a build cache entry; repro.sh uses a private GOCACHE to avoid that.
