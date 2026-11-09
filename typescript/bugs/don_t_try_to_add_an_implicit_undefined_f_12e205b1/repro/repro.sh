#!/bin/bash
node "$TSC" --target es2015 --strictNullChecks false --declaration --emitDeclarationOnly --outDir out createApi.ts index.ts
cat out/index.d.ts
