package main

type B[P any] = func()

var _ = B(nil)

func main() {}
