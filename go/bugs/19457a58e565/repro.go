package main

func g[T any](x T) interface{} { return x }

func main() {
	println(g[interface{}](nil) == nil)
}
