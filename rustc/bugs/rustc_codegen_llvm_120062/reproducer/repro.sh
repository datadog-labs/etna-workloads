#!/bin/bash
"$RUSTC" main.rs --target=target.json -Z unstable-options --emit=obj -o out.o 2>&1 | sed -E 's/`[A-Za-z0-9:-]{20,}`/`DL`/g; s/mismatched-data-layout-[0-9]+/X/g'
echo "status: ${PIPESTATUS[0]}"
