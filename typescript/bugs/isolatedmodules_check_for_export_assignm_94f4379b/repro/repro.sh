#!/bin/bash
node "$TSC" --isolatedModules --noEmit --module commonjs --target es2015 events.d.ts input.ts
echo "exit $?"
