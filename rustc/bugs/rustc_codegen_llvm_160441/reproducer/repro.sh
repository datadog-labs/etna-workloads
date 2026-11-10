#!/bin/bash
export RUSTC_BOOTSTRAP=1
"$RUSTC" --target powerpc64le-unknown-linux-gnu -C target-feature=+vsx,+power8-vector -O -Awarnings -Zmerge-functions=disabled --emit asm -o out.s main.rs 2>&1
echo "status $?"
grep -v '^\s*\.' out.s | grep -v '^$'
