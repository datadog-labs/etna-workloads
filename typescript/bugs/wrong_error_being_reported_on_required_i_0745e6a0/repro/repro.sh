#!/bin/bash
node "$TSC" --strict --isolatedDeclarations --declaration --noEmit --target esnext --pretty false input.ts
echo "exit $?"
