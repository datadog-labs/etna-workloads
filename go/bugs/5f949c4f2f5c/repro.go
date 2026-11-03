package main

const maxUint = 1<<64 - 1

func main() {
	for range maxUint {
		break
	}
}
