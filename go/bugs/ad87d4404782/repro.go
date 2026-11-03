package main

func f[T ~bool](ch <-chan T) {
	var x, ok T = <-ch
	println(x, ok)
}

func main() {
	ch := make(chan bool, 1)
	ch <- true
	f[bool](ch)
}
