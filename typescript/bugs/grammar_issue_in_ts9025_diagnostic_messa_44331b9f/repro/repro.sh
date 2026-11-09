#!/bin/bash
node "$TSC" --isolatedDeclarations --declaration --noEmit --strict input.ts
echo "exit=$?"
