#!/bin/bash
node "$TSC" --target es2024 --noEmit --listFiles input.ts | sed 's#.*/lib\.#lib.#'
echo "exit: ${PIPESTATUS[0]}"
