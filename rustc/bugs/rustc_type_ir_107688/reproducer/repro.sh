#!/bin/bash
"$RUSTC" --edition 2021 -Copt-level=0 -A unused -Zwrite-long-types-to-disk=no -o out_bin main.rs 2>&1 | sed 's/main\.rs/F.rs/g'
echo "status ${PIPESTATUS[0]}"
