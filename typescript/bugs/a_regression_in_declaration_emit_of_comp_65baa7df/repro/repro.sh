#!/bin/bash
node "$TSC" --target es2015 --strict --declaration --emitDeclarationOnly input.ts
cat input.d.ts
