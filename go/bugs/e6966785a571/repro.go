
package main

type TypeMap struct{}

//go:noinline
func (tm *TypeMap) Set[T any](v T) {}

type HashSet[T any] struct{}

type res struct{ s HashSet[int] }

func main() { (&TypeMap{}).Set(res{}) }
