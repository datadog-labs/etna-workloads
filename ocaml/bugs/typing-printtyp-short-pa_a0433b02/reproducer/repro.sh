cd "$(dirname "$0")"
out=$(printf 'module A = struct module B = struct type t = T end end;;\nmodule M2 = struct type u = A.B.t type foo = int type v = A.B.t end;;\n' | "$1/bin/ocaml" -short-paths -noprompt -noinit 2>&1)
echo "$out" | grep M2
case "$out" in *"type v = u end"*) exit 0;; *) exit 1;; esac
