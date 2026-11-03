repro.go declares generic functions whose type parameter is constrained by a union of a
directional and a bidirectional channel (`chan<- int | chan int`, `<-chan int | chan int`), then
sends/receives on it (issue 72936).
Clean toolchain accepts the valid ones and reports only the two genuinely conflicting cases.
Buggy commonUnder additionally rejects the valid ones with "channels ... have conflicting directions".
