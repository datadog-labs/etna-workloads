#!/bin/bash
rm -rf out; mkdir out
"$RUSTC" --edition 2024 -Zmir-opt-level=0 -Zdump-mir=MentionedItems -Zdump-mir-dir=out --crate-type bin -o out/bin main.rs 2>&1
echo "status $?"
for f in out/*async_drop_in_place*SyncInt*MentionedItems.after.mir; do
  echo "== shim"; grep -v '^//' "$f"
done
