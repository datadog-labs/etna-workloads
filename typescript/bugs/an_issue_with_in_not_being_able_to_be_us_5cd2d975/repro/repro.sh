#!/bin/bash
node "$TSC" --strict --noEmit --target es2022 input.ts
echo "exit $?"
