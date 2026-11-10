#!/bin/bash
$RUSTC --edition=2021 --crate-type=lib eager.rs --crate-name eager 2>&1; echo "aux status $?"
$RUSTC --edition=2021 --emit=metadata --extern eager=libeager.rlib main.rs 2>&1; echo "status $?"
