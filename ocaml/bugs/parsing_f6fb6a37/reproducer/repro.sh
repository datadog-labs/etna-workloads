cd "$(dirname "$0")"
d=$(mktemp -d)
printf '#9342101923012312312 ""\n' > "$d/a.ml"
out=$("$1/bin/ocamlc" -c "$d/a.ml" 2>&1 | grep Error)
rm -rf "$d"
echo "$out"
case "$out" in *"out of range"*) exit 0;; *) exit 1;; esac
