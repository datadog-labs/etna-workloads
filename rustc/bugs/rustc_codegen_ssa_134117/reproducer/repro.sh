#!/bin/bash
$RUSTC --edition 2021 -C opt-level=0 --emit=llvm-ir -C no-prepopulate-passes -o out.ll main.rs 2>&1
grep -A8 'define.*@index_on_i32' out.ll | grep getelementptr | sed 's/%[0-9_a-z.]*\b/%v/g'
