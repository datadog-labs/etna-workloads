#!/bin/bash
"$RUSTC" --crate-type bin --emit=metadata -o out.rmeta main.rs 2>&1 | grep -v '^ *[0-9]*:\|^ *at \|thread\|^stack\|^note: rustc\|^note: .*ICE\|^$' | head -20
echo "status: ${PIPESTATUS[0]}"
