package main

import "io"

var _ io.Writer = W{}

type W struct {
	*bufio.Writer
}

var _ interface{ m() } = &M{}

type M undefined

func main() {}
