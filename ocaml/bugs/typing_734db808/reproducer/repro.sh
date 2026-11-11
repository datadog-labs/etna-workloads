cd "$(dirname "$0")"
if timeout 20 "$1/bin/ocamlc" -c repro.ml >/dev/null 2>&1; then
  echo "accepted"; rm -f repro.cm* repro.o; exit 0
fi
echo "rejected"; exit 1
