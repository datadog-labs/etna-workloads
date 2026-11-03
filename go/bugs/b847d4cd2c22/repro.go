package main

const run = false

func f() {
	if !run {
		return
	}

	messages := make(chan struct{}, 1)
main:
	for range messages {
		break main
	}
}

func main() {
	f()
	println("ok")
}
