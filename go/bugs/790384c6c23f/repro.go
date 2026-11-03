package main

type A[P any] = P

func main() {
	var _ A[int]
}
