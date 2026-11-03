repro.go: a struct whose array field length uses unsafe.Sizeof(a{}) of the struct itself (the issue 49276 case).
Clean: reports "invalid recursive type: a refers to itself".
Buggy: the removed isComplete check lets the composite literal of the incomplete struct through, giving an internal compiler error (assertion failed in types2/named.go).
