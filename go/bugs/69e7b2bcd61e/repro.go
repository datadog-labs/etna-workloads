package main

import "fmt"

func main() {
	x := 1
	for e := range x.m() {
		switch e.(type) {
		case int:
			fmt.Println()
		}
	}
}
