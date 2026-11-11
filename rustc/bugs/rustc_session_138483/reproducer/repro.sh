#!/bin/bash
C="-Zunstable-options --target i686-unknown-linux-gnu -Cpanic=abort --emit metadata"
$RUSTC aux.rs --crate-name aux $C -Zreg-struct-return=true --out-dir . 2>&1; echo "aux: $?"
$RUSTC main.rs $C -Zreg-struct-return --extern aux=libaux.rmeta --out-dir . 2>&1; echo "main: $?"
