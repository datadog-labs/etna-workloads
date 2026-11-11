#!/bin/bash
"$RUSTC" --crate-type=lib --emit=mir -Copt-level=3 -Zmir-opt-level=3 -Zmir-enable-passes=+UnreachableEnumBranching main.rs -o out.mir 2>&1
echo "status $?"
grep -E 'switchInt|unreachable' out.mir | sed 's/_[0-9]*/_N/g;s/bb[0-9]*/bbN/g'
echo "unreachable-count: $(grep -c unreachable out.mir)"
grep -E 'switchInt' out.mir | grep -c 'otherwise: bb' 
