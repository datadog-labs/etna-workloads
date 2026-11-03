cat > main.go <<'EOT'
package main

import "fmt"

type Sym struct {
	Name string
	Code rune
}

func main() {
	s := Sym{"main", 'T'}
	fmt.Printf("%c %s\n", s.Code, s.Name)
}
EOT
"$GO" run -trimpath main.go 2>&1 | grep -v '^go: warning' | head -3
