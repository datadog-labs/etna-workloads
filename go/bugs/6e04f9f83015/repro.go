package main

import "fmt"

var sink []int64

//go:noinline
func f() int64 {
	var s []int64
	for i := int64(1); i <= 4; i++ {
		s = append(s, i)
	}
	if cap(s) != 4 {
		return -1
	}
	sum := int64(0)
	for idx, v := range s {
		sum = sum*10 + v
		if idx == 0 {
			s = s[3:3]
			s = append(s, 9, 9)
		}
	}
	sink = s
	return sum
}

func main() {
	fmt.Println(f())
}
