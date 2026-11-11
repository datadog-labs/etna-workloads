Compiles a function with 'x == 42' branch and dumps MIR after SimplifyComparisonIntegral; clean emits switchInt(copy _1), injected emits switchInt(move _1).
