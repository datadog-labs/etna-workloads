#!/bin/bash
"$RUSTC" --edition 2021 -Ainternal_features --target i686-unknown-linux-gnu --emit=llvm-ir -Cno-prepopulate-passes -Copt-level=1 -Cpanic=abort -o out.ll main.rs 2>&1
echo "status $?"
sed -n '/define.*@f(/,/^}/p' out.ll | grep -c alloca
