#!/bin/bash
node "$TSC" --noEmit --strict --target es2020 input.ts
echo "exit $?"
