cd "$(dirname "$0")"
out=$("$1/bin/ocamlc" -w +8 -c -o /tmp/rp$$ repro.ml 2>&1); rm -f /tmp/rp$$.*
echo "$out" | grep -o 'Any[A-Za-z]*Tag' | sort -u
case "$out" in *AnyOtherTag*) exit 0;; *) exit 1;; esac
