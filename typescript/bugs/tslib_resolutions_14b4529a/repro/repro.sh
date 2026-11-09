#!/bin/bash
node "$TSC" --noEmit --importHelpers --target es2017 --module esnext --moduleResolution bundler main.ts
echo "exit: $?"
