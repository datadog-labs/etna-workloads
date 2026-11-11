#!/bin/bash
"$RUSTC" --crate-type=rlib --target=amdgcn-amd-amdhsa -Ctarget-cpu=gfx900 -O --emit=llvm-ir -o out.ll main.rs 2>&1
echo "status $?"
grep -E 'alloca|addrspacecast|llvm.lifetime' out.ll | grep -v '^declare'
