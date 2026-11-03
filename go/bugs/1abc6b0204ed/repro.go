package main

type Builder[T ~struct{ Builder[T] }] struct{}

type A[T interface{ A[T] }] interface{}

type A2[U interface{ A2[U] }] interface{ M() A2[U] }

type (
	T1[P T1[P]]       interface{}
	T2[P, Q T2[P, Q]] interface{}
	T5[P T6[P]]       interface{ int }
	T6[P T5[P]]       interface{ int }
)

type Eq[a Eq[a]] interface {
	Equal(a) bool
}

func main() {}
