#!/bin/bash
node "$TSC" --noEmit --lib es2016.intl,es5 input.ts
echo "exit: $?"
