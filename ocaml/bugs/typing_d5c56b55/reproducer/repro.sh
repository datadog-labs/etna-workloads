#!/bin/sh
cd "$(dirname "$0")"
out=$(printf 'module M = struct\n type t = int\n let f (x : [< `Foo of t & int & string]) = ()\nend;;\n' | "$1/bin/ocaml" -noprompt -no-version 2>&1)
echo "$out"
case "$out" in *"t & int & string"*) exit 0;; esac
exit 1
