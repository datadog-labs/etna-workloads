#!/bin/bash
"$RUSTC" --crate-type proc-macro --crate-name ice_wrong_span_114865 --edition 2021 pm.rs -o libpm.so 2>&1
"$RUSTC" --edition 2021 main.rs --emit metadata --extern ice_wrong_span_114865=libpm.so -o main.rmeta 2>&1 | grep -E "^error|not a char boundary" | sed "s/^.*end byte index.*/char boundary panic/" | sort | uniq -c
echo "status ${PIPESTATUS[0]}"
