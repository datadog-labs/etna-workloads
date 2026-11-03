package main

import (
	"fmt"
	"os"
)

func g[T any](...T) {}

func main() {
	var file *os.File
	var b any
	g(file, b)
	fmt.Println("ok")
}
