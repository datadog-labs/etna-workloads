package main

func f(s []byte) {
	switch "" {
	case string(append(s, 'a')):
	}
}

func main() {
	f(nil)
}
