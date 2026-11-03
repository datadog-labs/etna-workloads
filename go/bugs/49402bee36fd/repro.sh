set -e
mkdir -p bad
cat > go.mod <<'X'
module m

go 1.20
X
cat > bad/bad.go <<'X'
// Copyright 2021 The Go Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package bad

// Note that the use of CGO here is solely to trigger external
// linking, since that is required to trigger that bad behavior
// in this bug.

// #include <stdlib.h>
import "C"

func Bad() {
	m := make(map[int64]A)
	a := m[0]
	if len(a.B.C1.D2.E2.F1) != 0 ||
		len(a.B.C1.D2.E2.F2) != 0 ||
		len(a.B.C1.D2.E2.F3) != 0 ||
		len(a.B.C1.D2.E2.F4) != 0 ||
		len(a.B.C1.D2.E2.F5) != 0 ||
		len(a.B.C1.D2.E2.F6) != 0 ||
		len(a.B.C1.D2.E2.F7) != 0 ||
		len(a.B.C1.D2.E2.F8) != 0 ||
		len(a.B.C1.D2.E2.F9) != 0 ||
		len(a.B.C1.D2.E2.F10) != 0 ||
		len(a.B.C1.D2.E2.F11) != 0 ||
		len(a.B.C1.D2.E2.F16) != 0 {
		panic("bad")
	}
	C.malloc(100)
}

type A struct {
	B
}

type B struct {
	C1 C
	C2 C
}

type C struct {
	D1 D
	D2 D
}

type D struct {
	E1 E
	E2 E
	E3 E
	E4 E
}

type E struct {
	F1  string
	F2  string
	F3  string
	F4  string
	F5  string
	F6  string
	F7  string
	F8  string
	F9  string
	F10 string
	F11 string
	F12 string
	F13 string
	F14 string
	F15 string
	F16 string
}
X
cat > main.go <<'X'
// Copyright 2021 The Go Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package main

import (
	bad "m/bad"
)

func main() {
	another()
	bad.Bad()
}

func another() L {
	m := make(map[string]L)
	return m[""]
}

type L struct {
	A Data
	B Data
}

type Data struct {
	F1 [22][]string
}
X
"$GO" build -trimpath -ldflags=-linkmode=external -o prog . 2>&1 || echo "build failed: $?"
if [ -x prog ]; then ./prog && echo "ok"; fi
