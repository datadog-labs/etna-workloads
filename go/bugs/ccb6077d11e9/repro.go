package main

type A = int

type T[P any] *A

var _ T[int]

func main() { println("ok") }
