#!/bin/bash
node "$TSC" --allowJs --noEmit --checkJs --target es2020 --module commonjs a.js
echo "exit: $?"
