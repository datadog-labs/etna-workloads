#!/bin/bash
"$RUSTC" --edition 2021 --target nvptx64-nvidia-cuda -Zmir-opt-level=4 --emit=mir -o out.mir lib.rs 2>&1 | grep -v "^warning" | head -0
echo "status=${PIPESTATUS[0]}"
echo "syncthreads calls in function: $(awk '/^fn function/{f=1} f&&/= syncthreads\(\)/{n++} END{print n+0}' out.mir)"
