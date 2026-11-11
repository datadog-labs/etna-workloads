#!/bin/bash
"$RUSTC" --target i686-unknown-linux-gnu -Zregparm=2 -Awarnings --emit=llvm-ir -o out.ll main.rs 2>&1
echo "status $?"
grep -c NumRegisterParameters out.ll; true
