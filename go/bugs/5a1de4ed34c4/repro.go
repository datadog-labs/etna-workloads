package main

type A[P int] = struct{}

var _ A[string]

func main() {}
