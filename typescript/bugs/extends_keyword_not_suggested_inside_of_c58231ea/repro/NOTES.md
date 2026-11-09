Input: `function f1<T >() {}` and `function f2<T ext>() {}`; the script asks the language service for completions inside the type parameter list, just after `T ` and after `T ext`.
Clean: `extends` is offered at both positions (prints true, true).
Injected: type parameter declarations are no longer exempted from the "declaration name" completion block, so `extends` is not offered (prints false, false).
