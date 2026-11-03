package main

type Message struct {
	Header map[string][]string
}

func main() {
	m := Message{Header: map[string][]string{}}
	m.Header[""] = append([]string(m.Header[""]), "")
	println(len(m.Header[""]))
}
