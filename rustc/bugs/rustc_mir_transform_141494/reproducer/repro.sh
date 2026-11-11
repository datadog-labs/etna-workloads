#!/bin/bash
RUST_BACKTRACE=0 $RUSTC --edition 2021 -O main.rs -o main >out.txt 2>&1; echo "status $?"
grep -c "internal error" out.txt
[ -x main ] && ./main
