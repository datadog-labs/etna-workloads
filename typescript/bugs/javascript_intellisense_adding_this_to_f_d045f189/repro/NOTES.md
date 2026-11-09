Input: a JS file `class C1 { async #fo }`; the language service is asked for completions right after `#fo`.
Clean: returns class-member completions (`constructor,get,set,static,...`).
Injected: the PrivateIdentifier case is gone, so it returns global/statement completions (`C1,#fo,as,asserts,break,...`).
