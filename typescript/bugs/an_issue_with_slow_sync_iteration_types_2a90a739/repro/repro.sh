#!/bin/bash
node "$TSC" --strict --target es2018 --lib esnext --noEmit input.ts
echo "exit $?"
