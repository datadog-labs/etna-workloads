Language-service inlay hints with parameter-name hints set to 'literals' on f(x, "hi", true), where the first arg is a non-literal.
Clean: hints 'b:' and 'c:' for the literal args. Injected: the skipped non-literal arg doesn't advance the parameter index, so hints are wrong ('a:' and 'b:').
