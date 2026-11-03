package main

import (
	"fmt"
	"os"
	"os/exec"
	"strings"
)

type A[T any] interface {
	m()
}

type Z struct {
	a, b int
}

func (z *Z) m() {
}

func test[T any]() {
	var a A[T] = &Z{}
	f := a.m
	f()
}

func main() {
	if os.Getenv("CHILD") != "" {
		test[string]()
		return
	}
	cmd := exec.Command(os.Args[0])
	cmd.Env = append(os.Environ(), "CHILD=1")
	out, err := cmd.CombinedOutput()
	first, _, _ := strings.Cut(string(out), "\n")
	fmt.Println("output:", first)
	fmt.Println("err:", err)
}
