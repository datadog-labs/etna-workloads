#!/bin/bash
node "$TSC" --declaration --emitDeclarationOnly --target es2015 --module commonjs projD/index.ts --outDir out
echo "exit: $?"
cat out/index.d.ts
