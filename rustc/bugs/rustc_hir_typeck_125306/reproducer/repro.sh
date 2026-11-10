#!/bin/bash
"$RUSTC" --edition=2021 main.rs -o main_bin 2>&1
echo "compile status: $?"
[ -x main_bin ] && ./main_bin
