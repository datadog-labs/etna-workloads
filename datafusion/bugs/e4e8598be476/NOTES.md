Runs bitwise `&` on two Float32 values and on two Date32 values.
Clean build: planning error "Cannot infer common type for bitwise operation ... & ...".
Buggy build: bitwise_coercion accepts any identical types, so the error comes later (or differs) from the arrow kernel.
