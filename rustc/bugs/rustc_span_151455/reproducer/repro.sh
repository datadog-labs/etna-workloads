#!/bin/bash
"$RUSTC" --edition 2021 --crate-type bin --emit=obj -o out.o main.rs 2>&1 | grep -E "^(error|thread|assertion)" 
echo "status: ${PIPESTATUS[0]}"
