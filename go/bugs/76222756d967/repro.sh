cat > main.go <<EOT
package main

import "fmt"

func main() {
	fmt.Println("OK")
}
EOT
"$GO" run -trimpath -race '-gcflags=all=-N -l' main.go 2>&1
echo "exit: $?"
