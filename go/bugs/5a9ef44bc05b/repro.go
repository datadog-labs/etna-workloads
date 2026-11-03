package main

type M interface{ M() }

type Impl struct{}

func (*Impl) M() { println("Impl.M") }

type anyWrapper any

func main() {
	var foo any = &Impl{}
	var bar anyWrapper = foo
	bar.(M).M()
}
