repro.go: unsafe.SliceData(nil slice) != nil; buggy compiler assumes slice pointer non-nil and prints true, clean prints false.
