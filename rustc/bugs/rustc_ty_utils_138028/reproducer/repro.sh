#!/bin/bash
"$RUSTC" --edition 2021 -Clink-dead-code=true --emit=obj -o out.o main.rs 2>&1 | grep -v '^ *[0-9]*:' | head -5
echo "status: ${PIPESTATUS[0]}"
