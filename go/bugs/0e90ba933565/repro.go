package main

type T1 struct{}
type T2 struct{}

func main() {
	switch (T1{}) {
	case T1(T2{}):
		println("equal")
	}
}
