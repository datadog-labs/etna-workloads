#!/bin/bash
node run.cjs 2>&1 | grep -v '^    at' | head -40
