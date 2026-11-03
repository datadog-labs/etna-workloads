cat > p.go <<'EOT'
package p

type t struct{ _ u }
type u [10]struct{ f int }

func f(x int) t   { return t{u{{1 / x}, {1 % x}}} }
func g(p *int) t  { return t{u{{*p}}} }
func h(s []int) t { return t{u{{s[0]}}} }
EOT
"$GO" build -trimpath ./p.go
echo "exit $?"
