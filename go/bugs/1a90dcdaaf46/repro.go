package main

type A = [4]int
type B = map[string]interface{}

func f[T ~A](x T) int { return len(x) + cap(x) }

func g[V ~A]() V { return V{} }

func h[W ~B](a interface{}) interface{} { return a.(W)["key"] }

func main() {
	println(f([4]int{}), len(g[[4]int]()))
	println(h[B](B{"key": 1}).(int))
}
