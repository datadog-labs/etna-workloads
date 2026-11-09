#!/bin/bash
node "$TSC" --noEmit --allowJs --checkJs --target es5 --ignoreDeprecations 6.0 foo.js
echo "exit: $?"
