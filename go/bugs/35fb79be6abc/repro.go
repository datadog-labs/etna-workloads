package main

type T1 interface{ int }
type T2 interface{ ~int }

type C interface{ T1 | T1 }
type D interface{ T1 | T2 }

func f[X T1 | T2 | bool]() {}

func main() {
	f[int]()
	println("ok")
}
