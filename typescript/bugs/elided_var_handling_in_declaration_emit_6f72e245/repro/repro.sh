#!/bin/bash
node "$TSC" --target es2015 --declaration --emitDeclarationOnly --outDir out input.ts
echo "exit $?"
cat out/input.d.ts
