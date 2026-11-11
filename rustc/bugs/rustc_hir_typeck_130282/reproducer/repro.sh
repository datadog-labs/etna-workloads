#!/bin/bash
"$RUSTC" --edition 2021 --emit=metadata -o out.rmeta main.rs 2>&1 | grep -c '^error\[E0055\]'
echo "status ${PIPESTATUS[0]}"
