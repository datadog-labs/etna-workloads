package main

func f() { clear([]byte{string([]byte{'x'}[:])[0]}) }

func main() { f(); println("ok") }
