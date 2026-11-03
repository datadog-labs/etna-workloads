cat > x.go <<'EOT'
package main

func main() { println("hi") }
EOT
"$GO" build -trimpath -gcflags=-json=0,file:///c:foo -o x.out x.go 2>&1
echo "exit=$?"
ls -d c:foo 2>&1 | head -1
