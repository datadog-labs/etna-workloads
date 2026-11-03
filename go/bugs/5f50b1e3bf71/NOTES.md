repro.go is the upstream test issue67190.go. It switches on a `chan struct{}` against a case of type `<-chan struct{}` (and vice versa).
Clean: exits 0. Buggy: panics "bad narrow case" because the switch comparison of mixed channel directions is wrongly evaluated as unequal.
