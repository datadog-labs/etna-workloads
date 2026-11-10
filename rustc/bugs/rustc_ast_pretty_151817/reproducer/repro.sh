#!/bin/bash
"$RUSTC" -Zunpretty=expanded,hygiene main.rs 2>&1 | grep 'fn f'
