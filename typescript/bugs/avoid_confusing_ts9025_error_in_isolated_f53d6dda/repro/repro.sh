#!/bin/bash
node "$TSC" --strict --isolatedDeclarations --declaration --emitDeclarationOnly --outDir out --target es2015 input.ts
echo "exit $?"
