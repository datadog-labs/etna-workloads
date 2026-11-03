

package main

//go:noinline
func f(p *[4]int) {
	for i := range (*p) {
		println(i)
	}
}
func main() {
	f(nil)
}
