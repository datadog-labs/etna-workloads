package main

func main() {
	s := "hello"
	msg := append(nil, s...)
	print(msg)
}
