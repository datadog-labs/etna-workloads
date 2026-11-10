#!/bin/bash
node "$TSC" --noEmit --module commonjs --target es2015 usage.ts
echo "exit $?"
