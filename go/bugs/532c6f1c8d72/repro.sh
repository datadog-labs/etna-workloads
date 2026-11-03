set -e
mkdir -p mult.pkg
cat > devirt.go <<'EOF_A'
// Copyright 2023 The Go Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// WARNING: Please avoid updating this file. If this file needs to be updated,
// then a new devirt.pprof file should be generated:
//
//	$ cd $GOROOT/src/cmd/compile/internal/test/testdata/pgo/devirtualize/
//	$ go mod init example.com/pgo/devirtualize
//	$ go test -bench=. -cpuprofile ./devirt.pprof

package devirt

// Devirtualization of callees from transitive dependencies should work even if
// they aren't directly referenced in the package. See #61577.
//
// Dots in the last package path component are escaped in symbol names. Use one
// to ensure the escaping doesn't break lookup.
import (
	"fmt"

	"example.com/pgo/devirtualize/mult.pkg"
)

var sink int

type Adder interface {
	Add(a, b int) int
}

type Add struct{}

func (Add) Add(a, b int) int {
	for i := 0; i < 1000; i++ {
		sink++
	}
	return a + b
}

type Sub struct{}

func (Sub) Add(a, b int) int {
	for i := 0; i < 1000; i++ {
		sink++
	}
	return a - b
}

// ExerciseIface calls mostly a1 and m1.
//
//go:noinline
func ExerciseIface(iter int, a1, a2 Adder, m1, m2 mult.Multiplier) int {
	// The call below must evaluate selectA() to determine the receiver to
	// use. This should happen exactly once per iteration. Assert that is
	// the case to ensure the IR manipulation does not result in over- or
	// under-evaluation.
	selectI := 0
	selectA := func(gotI int) Adder {
		if gotI != selectI {
			panic(fmt.Sprintf("selectA not called once per iteration; got i %d want %d", gotI, selectI))
		}
		selectI++

		if gotI%10 == 0 {
			return a2
		}
		return a1
	}
	oneI := 0
	one := func(gotI int) int {
		if gotI != oneI {
			panic(fmt.Sprintf("one not called once per iteration; got i %d want %d", gotI, oneI))
		}
		oneI++

		// The function value must be evaluated before arguments, so
		// selectI must have been incremented already.
		if selectI != oneI {
			panic(fmt.Sprintf("selectA not called before not called before one; got i %d want %d", selectI, oneI))
		}

		return 1
	}

	val := 0
	for i := 0; i < iter; i++ {
		m := m1
		if i%10 == 0 {
			m = m2
		}

		// N.B. Profiles only distinguish calls on a per-line level,
		// making the two calls ambiguous. However because the
		// interfaces and implementations are mutually exclusive,
		// devirtualization can still select the correct callee for
		// each.
		//
		// If they were not mutually exclusive (for example, two Add
		// calls), then we could not definitively select the correct
		// callee.
		val += m.Multiply(42, selectA(i).Add(one(i), 2))
	}
	return val
}

type AddFunc func(int, int) int

func AddFn(a, b int) int {
	for i := 0; i < 1000; i++ {
		sink++
	}
	return a + b
}

func SubFn(a, b int) int {
	for i := 0; i < 1000; i++ {
		sink++
	}
	return a - b
}

// ExerciseFuncConcrete calls mostly a1 and m1.
//
//go:noinline
func ExerciseFuncConcrete(iter int, a1, a2 AddFunc, m1, m2 mult.MultFunc) int {
	// The call below must evaluate selectA() to determine the function to
	// call. This should happen exactly once per iteration. Assert that is
	// the case to ensure the IR manipulation does not result in over- or
	// under-evaluation.
	selectI := 0
	selectA := func(gotI int) AddFunc {
		if gotI != selectI {
			panic(fmt.Sprintf("selectA not called once per iteration; got i %d want %d", gotI, selectI))
		}
		selectI++

		if gotI%10 == 0 {
			return a2
		}
		return a1
	}
	oneI := 0
	one := func(gotI int) int {
		if gotI != oneI {
			panic(fmt.Sprintf("one not called once per iteration; got i %d want %d", gotI, oneI))
		}
		oneI++

		// The function value must be evaluated before arguments, so
		// selectI must have been incremented already.
		if selectI != oneI {
			panic(fmt.Sprintf("selectA not called before not called before one; got i %d want %d", selectI, oneI))
		}

		return 1
	}

	val := 0
	for i := 0; i < iter; i++ {
		m := m1
		if i%10 == 0 {
			m = m2
		}

		// N.B. Profiles only distinguish calls on a per-line level,
		// making the two calls ambiguous. However because the
		// function types are mutually exclusive, devirtualization can
		// still select the correct callee for each.
		//
		// If they were not mutually exclusive (for example, two
		// AddFunc calls), then we could not definitively select the
		// correct callee.
		val += int(m(42, int64(selectA(i)(one(i), 2))))
	}
	return val
}

// ExerciseFuncField calls mostly a1 and m1.
//
// This is a simplified version of ExerciseFuncConcrete, but accessing the
// function values via a struct field.
//
//go:noinline
func ExerciseFuncField(iter int, a1, a2 AddFunc, m1, m2 mult.MultFunc) int {
	ops := struct {
		a AddFunc
		m mult.MultFunc
	}{}

	val := 0
	for i := 0; i < iter; i++ {
		ops.a = a1
		ops.m = m1
		if i%10 == 0 {
			ops.a = a2
			ops.m = m2
		}

		// N.B. Profiles only distinguish calls on a per-line level,
		// making the two calls ambiguous. However because the
		// function types are mutually exclusive, devirtualization can
		// still select the correct callee for each.
		//
		// If they were not mutually exclusive (for example, two
		// AddFunc calls), then we could not definitively select the
		// correct callee.
		val += int(ops.m(42, int64(ops.a(1, 2))))
	}
	return val
}

//go:noinline
func AddClosure() AddFunc {
	// Implicit closure by capturing the receiver.
	var a Add
	return a.Add
}

//go:noinline
func SubClosure() AddFunc {
	var s Sub
	return s.Add
}

// ExerciseFuncClosure calls mostly a1 and m1.
//
// This is a simplified version of ExerciseFuncConcrete, but we need two
// distinct call sites to test two different types of function values.
//
//go:noinline
func ExerciseFuncClosure(iter int, a1, a2 AddFunc, m1, m2 mult.MultFunc) int {
	val := 0
	for i := 0; i < iter; i++ {
		a := a1
		m := m1
		if i%10 == 0 {
			a = a2
			m = m2
		}

		// N.B. Profiles only distinguish calls on a per-line level,
		// making the two calls ambiguous. However because the
		// function types are mutually exclusive, devirtualization can
		// still select the correct callee for each.
		//
		// If they were not mutually exclusive (for example, two
		// AddFunc calls), then we could not definitively select the
		// correct callee.
		val += int(m(42, int64(a(1, 2))))
	}
	return val
}

//go:noinline
func IfaceZeroWeight(a *Add, b Adder) bool {
	return a.Add(1, 2) == b.Add(3, 4) // unwanted devirtualization
}

// ExerciseIfaceZeroWeight never calls IfaceZeroWeight, so the callee
// is not expected to appear in the profile.
//
//go:noinline
func ExerciseIfaceZeroWeight() {
	if false {
		a := &Add{}
		b := &Sub{}
		// Unreachable call
		IfaceZeroWeight(a, b)
	}
}

func DirectCall() bool {
	return true
}

func IndirectCall() bool {
	return false
}

//go:noinline
func IndirCallZeroWeight(indirectCall func() bool) bool {
	return DirectCall() && indirectCall() // unwanted devirtualization
}

// ExerciseIndirCallZeroWeight never calls IndirCallZeroWeight, so the
// callee is not expected to appear in the profile.
//
//go:noinline
func ExerciseIndirCallZeroWeight() {
	if false {
		// Unreachable call
		IndirCallZeroWeight(IndirectCall)
	}
}
EOF_A
cat > mult.pkg/mult.go <<'EOF_B'
// Copyright 2023 The Go Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// WARNING: Please avoid updating this file.
// See the warning in ../devirt.go for more details.

package mult

var sink int

type Multiplier interface {
	Multiply(a, b int) int
}

type Mult struct{}

func (Mult) Multiply(a, b int) int {
	for i := 0; i < 1000; i++ {
		sink++
	}
	return a * b
}

type NegMult struct{}

func (NegMult) Multiply(a, b int) int {
	for i := 0; i < 1000; i++ {
		sink++
	}
	return -1 * a * b
}

// N.B. Different types than AddFunc to test intra-line disambiguation.
type MultFunc func(int64, int64) int64

func MultFn(a, b int64) int64 {
	for i := 0; i < 1000; i++ {
		sink++
	}
	return a * b
}

func NegMultFn(a, b int64) int64 {
	for i := 0; i < 1000; i++ {
		sink++
	}
	return -1 * a * b
}

//go:noinline
func MultClosure() MultFunc {
	// Explicit closure to differentiate from AddClosure.
	c := 1
	return func(a, b int64) int64 {
		for i := 0; i < 1000; i++ {
			sink++
		}
		return a * b * int64(c)
	}
}

//go:noinline
func NegMultClosure() MultFunc {
	c := 1
	return func(a, b int64) int64 {
		for i := 0; i < 1000; i++ {
			sink++
		}
		return -1 * a * b * int64(c)
	}
}
EOF_B
base64 -d > devirt.pprof <<'EOF_C'
H4sIAAAAAAAE/7xUTWwUZRh2Znem3862M29nt+3bdoFh+HGsskNHmkKiB4o2epCYcFI0up0dlk1n
Zza7MwRNTMaDGg8ao/GiYOSgEpEYtIqgpmA4oJiSYAwGMQETgYSrP1FEzPfNVKdolsaDh85O93ue
932e532/vefswcPv/n7+8y8GpCzhgJeyJAPZ+98/+8OTpQfZ+6PR/u+zukI4vDo7y+sUpQM3IhEO
BBQ00ViuK4TH43vYIQ8OO+ShC7s00VinKySDTx1khxkoscMMECRazijqQLJ4emY/rwskC0c54Eby
JAsSSlreeI/TgQj4wpfsWIBPeHYsQDd2a3njJV5VYByifXue5iWB4zNZQVeIiNFrs1SlmPQSoQd7
NNkY1hXShRdSKlUZeIjOHMtJgtgVswnu3s2UdkGBKe0CBRVNNlRVgZsh+vbKIU4SSILO4XdHGJrA
rQxNABA00RhRZRAhen6uJAm5RJiEV+PSTFiqt5RUy+O5VDVVBg5o8pKQTyp04+txBSYuBehOKvTg
ib1MTw4aTE8OerFXEw1XByLj12/P0pwl2E9zlogEKqqaaDyhK0TBlw8xah7KjJqHAha0nLFGVWAK
osNvfpWRhB5ZYSEDXn6FobthDUN3QxGLmmzcpgPpxYvpRqoMBKJLL66WBOiN6SqeiOk9sJrRe6AP
+zTZWKUq8ABEbxzYm5EENUEX8HLsSoaAoWXox35NNNqqDAJE5y8PSEKBKQNSxL37Epd7OODUnvkU
s0XaG0gfXlig7m9AHwUopB/nUuJSc+pP9AzgXKyHpazKkIVo5tmCJAwwDQpBPDYP8IAC5geJDABk
EM8cYCIVOElHkScKDOCAJhofcbpChvCDj1m6AOuZYQBE1HLGeDrLwaGsoAMZxuPpWqoCFYieOzZH
pzU8lBVUBbZCdO2nAzRRykkLZgAZuiHatWuDJBSS/zMQPfOWLAn9FK8rpIS/HGWCOHrzdSBL8NIM
M9ALv8YGemEQBzXRuEgNLMU/PmV4FSaYARWGcEjLGRtV+a/ipSVL2S4tw5OvMnAhcVuAYRzWZGNc
B6Lhb+lGqgIPQfTONx9mJGGZFvOX40wsjl1CVQYZop/PTUjC8qSBjj/GAKY+vWF6gliBJ3cxCUXY
xPQWoYQlTTYmVBkkiD47bUrCiqTfSjyV0pu6hSspYAgIB1EU8Ridm+WNJeu5oSLhIYqunDp7bRlG
R9insdS6yepqVxpN12lbgu2HXmBl7GZo5b2K57cd2/eqbWuls7NCIWXbb5jNmm9WnR31VhBW3Prj
TnljtUr/rG1m2G6Zrm9XXLPm+zXXMbf7DcdsNFuVIDDbLdus+Sb9sBtV0/YbzbrrmHUvcFpexTUD
px2wR7USVP7RJWlZrvnWiNNJzd07nZZdbzv3bqvYjjXaETvhePb2RqU1fRfzE1Om/wcbj1Cz1Esv
fal7tbIxMnFLuRV6m607F90/4ZpT8zZoxULybVzRrYSevd1a3ykGsxG6wSrLaU7Xypud2n2hG5Tp
o950H7Mai1bzX4ZKO5eb07X4peZbY4sVSgWyB1PZeUG3hFNsQfVOxSli0rvBwswv12To2Zt8z245
gdM53Ot3bAGz43ayTBaOZdKzyp08pCk0oEnvBp63hFM3qrnA82Tdcaudh/RvhmPa2k7SF7TZ5Prt
sOVY4x0Z191elmxC3NCJeH1KCam8LfTsUeuOxVKTq7KQXTaDRtOs+WumwrpbHd0wOj52+9i6Mcuc
Wrt2NPkNS342A6cdWOLWHdW2//CfAQAA//9nco4T/QoAAA==
EOF_C
printf 'module example.com/pgo/devirtualize\ngo 1.21\n' > go.mod
sed -i 's/func MultFn(a, b int64) int64/func MultFn[T int32|int64](a, b T) T/' mult.pkg/mult.go
"$GO" build -trimpath -o /dev/null -gcflags=-pgoprofile=devirt.pprof . 2>&1 | head -20
echo "exit: ${PIPESTATUS[0]}"
