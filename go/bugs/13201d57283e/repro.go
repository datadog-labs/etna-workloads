package main

func f[P any](P) {}
func g[Q int](Q) {}

func main() { f(g) }
