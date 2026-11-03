mkdir -p m/a
cat > m/go.mod <<'X'
module m
go 1.20
X
cat > m/a/a.go <<'X'
package a

type Table struct {
	ColumnSeparator bool
	RowSeparator    bool
	ColumnResizer   func()
}

func NewTable() *Table {
	return &Table{
		ColumnSeparator: true,
		RowSeparator:    true,
		ColumnResizer:   func() {},
	}
}
X
cat > m/b.go <<'X'
package main

import "m/a"

type Term struct {
	top *a.Table
}

//go:noinline
func NewFred() *Term {
	table := a.NewTable()
	return &Term{top: table}
}

func main() {
	t := NewFred()
	println(t.top.ColumnResizer != nil)
	t.top.ColumnResizer()
}
X
cd m && "$GO" run -trimpath . 2>&1; echo "exit=$?"
