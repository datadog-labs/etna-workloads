#!/bin/bash
"$RUSTC" --edition=2021 main.rs -o main 2>&1 | grep -E 'internal compiler error|is not an fn' | sed 's/DefId.*//' 
echo "rustc status: ${PIPESTATUS[0]}"
[ -x main ] && ./main
