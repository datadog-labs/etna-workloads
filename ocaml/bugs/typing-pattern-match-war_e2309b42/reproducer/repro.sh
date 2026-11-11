cd "$(dirname "$0")"
d=$(mktemp -d)
out=$("$1/bin/ocamlc" -w +A -c -o "$d/r.cmo" repro.ml 2>&1)
rm -rf "$d"
case "$out" in *"ambiguous-var-in-pattern-guard"*) echo warned; exit 0;; *) echo "no warning"; exit 1;; esac
