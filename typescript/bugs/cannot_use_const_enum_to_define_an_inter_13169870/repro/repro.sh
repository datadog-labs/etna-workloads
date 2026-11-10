#!/bin/bash
node "$TSC" --isolatedModules --target es2015 --noEmit foo.d.ts bar.ts
echo "exit $?"
