#!/bin/bash
node "$TSC" --noEmit --lib es2023.intl,es2015 input.ts
echo "exit=$?"
