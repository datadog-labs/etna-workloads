cd "$(dirname "$0")"
printf "type t = [\`A | \`B];;\ntype 'a u = t;;\nlet a : [< int u] = \`A;;\n" > "${TMPDIR:-/tmp}/r$$.ml"
out=$("$1/bin/ocaml" -short-paths -noprompt < "${TMPDIR:-/tmp}/r$$.ml" 2>&1)
rm -f "${TMPDIR:-/tmp}/r$$.ml"
case "$out" in *"int u"*) echo BUG; exit 1;; *) echo ok;; esac
