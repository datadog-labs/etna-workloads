#!/bin/bash
"$RUSTC" --edition 2021 -Copt-level=1 -Zmir-opt-level=1 -Zmir-enable-passes=+GVN main.rs -o main 2>&1
echo "compile status $?"
./main
echo "run status $?"
