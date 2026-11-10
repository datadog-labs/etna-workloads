#!/bin/bash
node "$TSC" --noEmit --module esnext --moduleResolution bundler input.ts
echo "exit $?"
