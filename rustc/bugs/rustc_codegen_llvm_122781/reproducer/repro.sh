#!/bin/bash
$RUSTC --target powerpc64le-unknown-linux-gnu --emit=llvm-ir -o out.ll a.rs -A warnings 2>&1 | grep -E "^error"
grep -o 'declare void @test_16([^)]*)' out.ll
