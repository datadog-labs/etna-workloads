#!/bin/bash
node "$TSC" --noEmit --strict --target es2015 --moduleResolution bundler --module esnext main.ts
echo "exit: $?"
