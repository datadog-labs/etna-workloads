cd "$(dirname "$0")"
out=$("$1/bin/ocaml" repro.ml 2>&1)
exp='@[foo@]
@[<%s>@]'
echo "$out"
[ "$out" = "$exp" ] || exit 1
