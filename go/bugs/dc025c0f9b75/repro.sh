cat > x.go <<'EOG'
package p

func f() [2]int {
	return [...]int{2: 0}
}
EOG
"$GO" build -trimpath -o /dev/null x.go 2>&1
echo "exit=$?"
