#!/bin/bash
for t in armv5te-none-eabi thumbv5te-none-eabi; do
  echo "== $t"
  "$RUSTC" -Awarnings --target $t --emit=llvm-ir -o out.ll main.rs 2>&1 | head -20
  grep -E '^ *"\.(arm|thumb|thumb_func)"|^ *"test_(arm|thumb):"' out.ll
done
