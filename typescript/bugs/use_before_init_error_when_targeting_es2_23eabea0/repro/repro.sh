#!/bin/bash
node "$TSC" --target es2022 --useDefineForClassFields --noEmit input.ts
echo "exit $?"
