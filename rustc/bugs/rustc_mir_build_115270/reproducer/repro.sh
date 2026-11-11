#!/bin/bash
$RUSTC --crate-type lib --crate-name aux aux.rs --emit metadata,link 2>&1
$RUSTC --edition 2021 main.rs --extern aux=libaux.rlib --emit metadata 2>&1; echo "exit=$?"
