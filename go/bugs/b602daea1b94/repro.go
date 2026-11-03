package main

type BImpl struct{}

func (b *BImpl) Work() { println("work") }

type A struct{ BImpl }

func main() {
	s := &A{}
	f := s.Work
	f()
	s.Work()
}
