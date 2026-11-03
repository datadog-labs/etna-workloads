cat > repro.go <<'EOT'
package main

import "iter"

func pairs() iter.Seq2[int, struct{}] {
	return func(yield func(int, struct{}) bool) {
		yield(1, struct{}{})
	}
}

func keys() iter.Seq[int] {
	return func(yield func(int) bool) {
		for k := range pairs() {
			if !yield(k) {
				return
			}
		}
	}
}

func main() {
	for range keys() {
	}
}
EOT
GOCACHE="$PWD/gocache" "$GO" build -trimpath -o /dev/null repro.go
echo "exit: $?"
