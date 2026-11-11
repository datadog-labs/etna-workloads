cd "$(dirname "$0")"
r=$(timeout 60 "$1/bin/ocaml" -i-variance < repro.ml 2>&1 | tail -n +4 | head -40)
case "$r" in *"Constraints are not satisfied"*) echo "wrong error: constraints not satisfied"; exit 1;; esac
echo "ok: cycle errors reported"; exit 0
