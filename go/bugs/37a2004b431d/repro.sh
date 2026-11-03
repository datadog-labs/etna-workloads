mkdir -p test
cat > a.go <<'X'
package a

func Start() interface{ Stop() } {
	return new(Stopper)
}

type Stopper struct{}

func (s *Stopper) Stop() {}
X
cat > main.go <<'X'
package main

import "test/a"

func main() {
	stop := start()
	defer stop()
}

func start() func() {
	return a.Start().Stop
}
X
GOFLAGS= "$GO" list -export -f '{{if .Export}}packagefile {{.ImportPath}}={{.Export}}{{end}}' std > std.cfg 2>/dev/null
cp std.cfg i.cfg
echo "packagefile test/a=test/a.a" >> i.cfg
"$GO" tool compile -e -importcfg=std.cfg -o test/a.a -p test/a a.go 2>&1
"$GO" tool compile -e -importcfg=i.cfg -p=main main.go 2>&1
echo "exit=$?"
