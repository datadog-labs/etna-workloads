#!/bin/bash
node "$TSC" --noEmit --module commonjs --target es2020 input.ts
echo "exit $?"
