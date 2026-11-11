#!/bin/bash
rm -rf inc
for v in bpass1 bpass2; do
  $RUSTC --crate-type=lib --cfg $v -C incremental=inc -Copt-level=3 main.rs >out.txt 2>&1
  echo "$v status=$?"
  grep -o 'forcing failed to set a color' out.txt | head -1
done
rm -rf inc out.txt
