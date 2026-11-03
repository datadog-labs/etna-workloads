package main

type A[_ any] = any

func f[_ A[int, string]]() {}

func main() {}
