cat > x.go <<'EOT'
package main

const (
	bigInt        = 0xffffffffffffffff
	stringVal     = "test"
	longStringVal = "this_is_a_string_constant_longer_than_seventy_characters_which_used_to_fail_see_issue_50253"
)

func main() {}
EOT
"$GO" tool compile -p main -asmhdr go_asm.h x.go
grep const_ go_asm.h
