cd "$(dirname "$0")"
out=$(timeout 20 "$1/bin/ocamlc" -i repro.ml 2>&1 | tail -n 3)
echo "$out"
case "$out" in *"(< next : int * 'a > as 'a) t"*) exit 0;; *) exit 1;; esac
