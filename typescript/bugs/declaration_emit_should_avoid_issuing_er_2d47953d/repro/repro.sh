#!/bin/bash
node "$TSC" --declaration --emitDeclarationOnly --target es2015 --module commonjs --noEmitOnError false input.ts
echo "exit $?"
cat input.d.ts
