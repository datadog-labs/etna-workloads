#!/bin/bash
"$RUSTC" --edition 2021 -Ctarget-feature=-crt-static -Ccodegen-units=1 -Clto -Cprefer-dynamic=off -Copt-level=0 -Zsanitizer=cfi -Cunsafe-allow-abi-mismatch=sanitizer main.rs -o main 2>&1
echo "compile: $?"
bash -c 'ulimit -c 0; ./main; echo "run: $?"' 2>/dev/null | cat
