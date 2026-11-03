package main

var x struct {
	f *NotAType
}
var _ = x.f == nil

var y *NotAType
var _ = y == nil

func main() {}
