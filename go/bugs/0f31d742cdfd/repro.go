package main

func main() {
	var i int
	v := new(i > 0) // untyped expression
	if *v != false {
		panic("wrong value")
	}
	println("ok")
}
