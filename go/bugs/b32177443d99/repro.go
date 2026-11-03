package main

func main() {
	var raw []byte
	println(copy(nil, raw))
	println(copy(nil, "abc"))
}
