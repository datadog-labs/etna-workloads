Compiles `return (_ = 42);` under deny(unused_parens). The clean compiler accepts it; the injected one reports an unused-parens error around the return value.
