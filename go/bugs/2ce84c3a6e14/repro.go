package main

type T struct{}
type I interface{ M() }

var _ I = T{}

func (T) m() {}

func main() {}
