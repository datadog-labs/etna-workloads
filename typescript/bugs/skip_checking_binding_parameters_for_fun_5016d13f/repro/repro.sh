#!/bin/bash
node "$TSC" --allowJs --checkJs --noEmit --target es2015 input.js
echo "exit: $?"
