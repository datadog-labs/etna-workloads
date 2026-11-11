Compiles a call foo(*hello) with a mismatched deref; clean rustc suggests 'consider removing deref here', the injected one suggests 'consider borrowing here' (&*hello).
