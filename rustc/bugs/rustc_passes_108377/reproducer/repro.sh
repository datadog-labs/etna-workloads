#!/bin/bash
$RUSTC --crate-type lib --emit metadata p1.rs 2>&1
$RUSTC --crate-type lib --emit metadata p2.rs --extern p1=libp1.rmeta 2>&1
$RUSTC --emit metadata main.rs --extern p1=libp1.rmeta --extern p2=libp2.rmeta -L . 2>&1
echo "exit: $?"
