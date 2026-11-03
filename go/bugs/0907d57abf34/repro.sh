cat > repro.go <<'EOG'
package main

type T[P any] int

const C T[int] = 3

func main() {}
EOG
"$GO" build -trimpath -gcflags=-N -o repro.out repro.go 2>&1
echo "exit: $?"
