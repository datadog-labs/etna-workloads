#!/bin/bash
$RUSTC --edition 2021 --crate-type lib --crate-name aa a.rs -A warnings -o libaa.rlib 2>&1
$RUSTC --edition 2021 --crate-type lib --crate-name bb b.rs -A warnings --extern aa=libaa.rlib -L . -o libbb.rlib 2>&1
$RUSTC --edition 2021 main.rs --emit metadata -o out.rmeta --extern bb=libbb.rlib --extern aa=libaa.rlib -L . 2>&1
echo "exit=$?"
