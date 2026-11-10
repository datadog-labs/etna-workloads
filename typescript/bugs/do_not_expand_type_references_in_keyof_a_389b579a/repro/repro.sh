#!/bin/bash
node "$TSC" --declaration --emitDeclarationOnly --strict --target es2015 --module commonjs a.ts b.ts
cat b.d.ts
