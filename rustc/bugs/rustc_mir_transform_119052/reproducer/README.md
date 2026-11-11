Compiles a generic fn indexing a slice with usize::MAX under GVN; injected compiler hits an ICE (constant index overflow broken MIR).
