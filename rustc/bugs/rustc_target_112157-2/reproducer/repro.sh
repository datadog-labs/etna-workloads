#!/bin/bash
$RUSTC --target i686-apple-darwin --emit=llvm-ir -o out.ll main.rs 2>&1 | head -30
echo "status ${PIPESTATUS[0]}"
grep -o 'declare void @g.*byval([^)]*) align [0-9]*' out.ll | sed 's/.*byval/byval/'
