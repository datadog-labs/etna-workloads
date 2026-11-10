#!/bin/bash
node "$TSC" --strict --target es2015 --declaration --emitDeclarationOnly input.ts
cat input.d.ts
