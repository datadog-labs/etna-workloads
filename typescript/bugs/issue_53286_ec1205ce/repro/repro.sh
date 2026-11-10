#!/bin/bash
node "$TSC" --noEmit --target es2022 --useDefineForClassFields input.ts
echo "exit $?"
