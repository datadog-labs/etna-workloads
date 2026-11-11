#!/bin/bash
"$RUSTC" --crate-type lib --crate-name aux aux.rs --emit metadata,link -o libaux.rlib 2>&1
"$RUSTC" --crate-type lib main.rs --extern aux=libaux.rlib --emit metadata -o out.rmeta 2>&1 | grep -v '^ *[0-9]*:\|^ *at \|thread\|^stack\|^note: rustc\|^note: compiler' | head -20
echo "status ${PIPESTATUS[0]}"
