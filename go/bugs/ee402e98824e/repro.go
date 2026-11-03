package main

func ffboth[T any](func(chan T))   {}
func ffrecv[T any](func(<-chan T)) {}

func main() {
	var both func(chan int)
	var recv func(<-chan int)
	ffboth(recv)
	ffrecv(both)
}
