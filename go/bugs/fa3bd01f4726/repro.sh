cat > x.go <<'EOT'
package main

type I interface{ F() }

type T struct{ n int }

func (t *T) F() { t.n++ }

//go:noinline
func (t *T) G() { t.n++ }

type W struct{ I }

type S struct{ *T }

var _ I = &W{}
var _ = (&S{}).G

func main() {}
EOT
"$GO" tool compile -race -p=main -S -o x.o x.go > out.txt 2>&1 || { cat out.txt; exit 1; }
for fn in 'main.(*W).F' 'main.(*S).G'; do
  body=$(awk -v f="$fn STEXT" 'index($0,f)==1{p=1;print;next} p&&/^\t/{print;next} {p=0}' out.txt)
  echo "$fn: racefuncenter=$(grep -c runtime.racefuncenter <<<"$body") racefuncexit=$(grep -c runtime.racefuncexit <<<"$body")"
done
