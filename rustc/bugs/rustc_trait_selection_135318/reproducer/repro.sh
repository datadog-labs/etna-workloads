#!/bin/bash
"$RUSTC" --edition 2021 -O main.rs -o m.bin 2>&1 | grep -E "^(error|assertion)|panicked" | sed 's/thread.*panicked.*/panicked/'
echo "status ${PIPESTATUS[0]}"
[ -x m.bin ] && ./m.bin && echo ran
