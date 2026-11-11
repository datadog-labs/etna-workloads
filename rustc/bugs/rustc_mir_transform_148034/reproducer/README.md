Optimized MIR of Option::unwrap_unchecked: on the fixed compiler an assume(discriminant == Some) remains; on the injected one it is dropped when the switch collapses to a goto.
