#!/bin/bash
"$RUSTC" --crate-type proc-macro --edition 2021 macro_def.rs --crate-name macro_def 2>&1; echo "pm: $?"
"$RUSTC" --edition 2021 -Cdebuginfo=2 -Copt-level=0 -Zmir-enable-passes=+Inline --emit=llvm-ir -o out.ll main.rs --extern macro_def=libmacro_def.so 2>&1; echo "main: $?"
echo "discriminators: $(grep -c 'DILexicalBlockFile.*discriminator: [1-9]' out.ll)"
