#!/bin/bash
printf 'MZ\x90\x00\n' > bad.bin
INVALID_UTF8_BIN="$PWD/bad.bin" "$RUSTC" --emit metadata --out-dir out main.rs 2>&1 | sed "s#$PWD#DIR#g" | grep -E "^(error|thread)|panicked|wasn't" | head -5
echo "status: ${PIPESTATUS[0]}"
