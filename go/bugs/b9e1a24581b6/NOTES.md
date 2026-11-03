repro.go is upstream test issue48289.go. Each loop iteration receives into `x := <-ch` in a select and stores &x.
Without the fix, the OAS-to-OSELRECV2 conversion drops the DCL in Init, so x is shared across iterations.
Clean: exits 0. Buggy: panics "got *ptr 1, want 0" (exit 2).
