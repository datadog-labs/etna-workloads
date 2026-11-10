#!/bin/bash
node "$TSC" --allowJs --checkJs --noEmit --target esnext input.js
echo "exit $?"
