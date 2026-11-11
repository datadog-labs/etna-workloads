cd "$(dirname "$0")"
out=$("$1/bin/ocaml" -noprompt -noinit < repro.ml 2>&1 | grep -v -e '^OCaml' -e '^Enter' -e '^$' | sed 's/^# *//;s/^#//')
exp="type (_, _) seq =
    Snil : ('a, int) seq
  | Scons : 'a * ('a, 'n) seq -> ('a, 'n option) seq
type (_, _, _) plus =
    PlusZ : 'a list -> (int, 'a, 'a) plus
  | PlusS : ('a, 'b, 'c) plus -> ('a option, 'b, 'c option) plus"
if [ "$out" = "$exp" ]; then echo ok; else echo BUG; echo "$out"; exit 1; fi
