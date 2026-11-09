#!/bin/bash
node "$TSC" --noEmit --target es2022 --pretty false input.ts
echo "exit: $?"
