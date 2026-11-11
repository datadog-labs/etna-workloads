#!/bin/sh
echo '1;;' | "$1/bin/ocaml" -noinit -no-version -prompt >/dev/null 2>&1
if [ $? -eq 0 ]; then echo "prompt option ok"; exit 0; fi
echo "prompt option rejected"; exit 1
