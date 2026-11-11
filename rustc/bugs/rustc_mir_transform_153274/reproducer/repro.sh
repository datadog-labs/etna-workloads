#!/bin/bash
ulimit -c 0
$RUSTC --edition 2024 --crate-type rlib --crate-name async_drop_crate_dep dep.rs -o libdep.rlib 2>&1
$RUSTC --edition 2024 -Z mir-opt-level=0 --extern async_drop_crate_dep=libdep.rlib main.rs -o main 2>&1 | grep -v '^ *$' | head -20
echo "compile status: ${PIPESTATUS[0]}"
st=$(bash -c "./main >/dev/null 2>&1; echo \$?" 2>/dev/null); if [ "$st" = 0 ]; then echo "run: exited normally"; else echo "run: crashed"; fi
