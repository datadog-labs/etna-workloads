cd "$(dirname "$0")"
out=$("$1/bin/ocaml" -dshape -noprompt -stdin < repro.ml 2>&1 | grep -A1 App_direct_indir | head -3)
echo "$out"
case "$out" in *"<.0>"*) echo BUG; exit 1;; esac
exit 0
