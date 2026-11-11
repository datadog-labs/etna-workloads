#!/bin/bash
"$RUSTC" --edition 2018 --target thumbv8m.main-none-eabi --crate-type rlib --crate-name minicore minicore.rs --emit=metadata,link -o libminicore.rlib 2>&1 | grep -c '^error'
"$RUSTC" --edition 2018 --target thumbv8m.main-none-eabi --crate-type lib --extern minicore=libminicore.rlib main.rs --emit=metadata -o out.rmeta 2>&1
echo "status=${PIPESTATUS[0]}"
