package main

import (
	"fmt"
	"testing"
)

func receiver(f func()) { f() }

func argument() {}

func main() {
	r := testing.Benchmark(func(b *testing.B) {
		for b.Loop() {
			receiver(argument)
		}
	})
	fmt.Println(r.N > 0)
}
