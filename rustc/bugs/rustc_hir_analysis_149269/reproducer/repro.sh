#!/bin/bash
T="--target thumbv8m.main-none-eabi -Cpanic=abort --edition 2021 -Awarnings"
"$RUSTC" $T --crate-type lib --crate-name minicore minicore.rs --emit metadata -o libminicore.rmeta 2>&1 | head -5
"$RUSTC" $T --crate-type lib --emit metadata --extern minicore=libminicore.rmeta main.rs -o out.rmeta 2>&1 | grep -E "^(error|thread|assertion)"
echo "status ${PIPESTATUS[0]}"
