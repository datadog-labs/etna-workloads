#!/bin/bash
rm -rf mir_dump
"$RUSTC" --edition 2021 --crate-type lib -C panic=abort -C overflow-checks=on -Zmir-opt-level=1 -Zmir-enable-passes=+DataflowConstProp -Zdump-mir=DataflowConstProp -Zdump-mir-dir=mir_dump main.rs 2>&1 | grep -E '^error' 
echo "status ${PIPESTATUS[0]}"
for f in mir_dump/main.f.*DataflowConstProp.after.mir; do
  grep -E 'AddWithOverflow|assert|const \(' "$f" | sed 's/ *\/\/.*//'
done
