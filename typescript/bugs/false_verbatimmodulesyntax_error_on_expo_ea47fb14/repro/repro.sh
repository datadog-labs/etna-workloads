#!/bin/bash
node "$TSC" --module esnext --target es2020 --verbatimModuleSyntax --noEmit input.ts
echo "exit $?"
