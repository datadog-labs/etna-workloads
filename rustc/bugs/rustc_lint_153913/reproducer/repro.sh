#!/bin/bash
"$RUSTC" --crate-type lib --crate-name dep dep.rs --emit link -o libdep.rlib 2>&1
"$RUSTC" main.rs --emit metadata -L . --out-dir out 2>&1 | grep -v '^ *[0-9]*:\|^ *at ' | head -8
echo "status: ${PIPESTATUS[0]}"
