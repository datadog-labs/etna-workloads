#!/bin/bash
"$RUSTC" --crate-type lib --edition 2021 aux.rs -o libaux.rlib 2>&1
"$RUSTC" --edition 2021 --extern aux=libaux.rlib --emit metadata -o out.rmeta main.rs 2>&1 | sed 's/^\(\s*-->\|\s*:::\).*\(:[0-9]*:[0-9]*\)$/\1 \2/'
echo "status ${PIPESTATUS[0]}"
