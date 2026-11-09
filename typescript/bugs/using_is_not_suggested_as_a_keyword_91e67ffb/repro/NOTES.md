Input: `function foo() { usin }`; the script asks the language service for completions at the end of `usin`.
Clean: `using` keyword completion is offered inside the function body. Injected: it is missing (removed from isFunctionLikeBodyKeyword).
The script prints "using offered: using keyword" on clean and "using offered: no" on injected.
