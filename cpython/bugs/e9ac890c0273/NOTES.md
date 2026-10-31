Compiles `()(?(1)\xNN?)` for NN in 0..255 and prints the failures.
Clean: `[]`. Buggy: `[(15, 'RuntimeError', 'invalid SRE code')]`.
Code 15 equals the JUMP opcode, so the validator mistakes the literal argument for the final JUMP.
