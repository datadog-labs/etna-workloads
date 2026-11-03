cat > x.go <<'EOT'
package p

import . "/foo"
EOT
"$GO" tool compile -p p -o x.o x.go
echo "exit=$?"
