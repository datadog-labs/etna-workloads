cd "$(dirname "$0")"
t=$(mktemp -d)
"$1/bin/ocamlc" -i repro.ml >$t/o 2>&1
r=$(cat $t/o); rm -rf $t
echo "$r"
case "$r" in *"method f : int c end
and"*"method f : 'a c end") echo ok; exit 0;; esac
echo fail; exit 1
