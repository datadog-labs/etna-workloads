package main

type Bool bool

func main() {
	for range func(func() Bool) {} {
	}
}
