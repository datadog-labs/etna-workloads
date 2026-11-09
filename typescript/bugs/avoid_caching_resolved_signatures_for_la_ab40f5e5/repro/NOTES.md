Input: `declare function f(x: string, y: number): any; f();` checked through a language service: signature help is requested on the call, then semantic diagnostics are fetched.
Clean: the arity error ("Expected 2 arguments, but got 0") is still reported after signature help.
Injected: signature help caches the resolved signature, so the arity diagnostic is missing.
