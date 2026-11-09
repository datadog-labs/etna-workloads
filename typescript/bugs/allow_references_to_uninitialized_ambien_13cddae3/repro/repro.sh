#!/bin/bash
node "$TSC" --noEmit --strict --target es2022 input.ts
echo "exit $?"
