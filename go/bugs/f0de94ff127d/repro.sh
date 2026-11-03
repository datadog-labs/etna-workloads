cat > repro.go <<'EOF'
package main

import (
	"regexp"
	"unique"
)

var dataFileRegexp = regexp.MustCompile(`^data\.\d+\.bin$`)

func main() {
	_ = dataFileRegexp
	unique.Make("")
	println("ok")
}
EOF
export GOCACHE="$PWD/gocache"
"$GO" build -a -trimpath -gcflags=all=-d=checkptr -o repro.bin repro.go 2>&1 | grep -v 'go.mod'
./repro.bin 2>&1 | head -1
echo "exit=${PIPESTATUS[0]}"
