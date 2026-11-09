#!/bin/bash
node "$TSC" --noEmit --moduleResolution node10 --ignoreDeprecations 6.0 --module commonjs --target es2020 input.ts
echo "exit: $?"
