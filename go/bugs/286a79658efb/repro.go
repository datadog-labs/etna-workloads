package main

var a, _ any = <-(chan int)(nil)

func main() {
	println("ok")
}
