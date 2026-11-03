package main

type T[P any] struct{}

type A0 = T[int]

func (A0) m() {}

type A1[P any] = T[P]

func (A1[P]) n() {}

func main() {}
