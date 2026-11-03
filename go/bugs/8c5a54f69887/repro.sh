cat > x.go <<'EOT'
package main

func main() {
	for {
	}

	defer func() {}()
	defer func() {}()
}
EOT
"$GO" tool compile -p main -o /dev/null x.go
echo "exit: $?"
