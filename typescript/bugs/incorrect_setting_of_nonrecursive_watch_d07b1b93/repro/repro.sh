#!/bin/bash
node run.js 2>&1 | grep -v '^diag' | head -5
