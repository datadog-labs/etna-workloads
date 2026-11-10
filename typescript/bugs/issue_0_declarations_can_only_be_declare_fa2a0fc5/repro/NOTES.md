Input has `const/let/using/await using` declarations as the body of an `if` plus a stray `}` (parse error).
The script prints semantic diagnostics via the API. Clean build reports TS1156 "'X' declarations can only be declared inside a block".
Injected build uses grammarErrorOnNode, which suppresses it when parse errors exist, so TS1156 is missing.
