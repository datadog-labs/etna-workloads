Input: an object literal property `a: fn` (undefined `fn`) whose contextual type is `((e: any) => void) | null` under strict.
A language-service script requests code fixes for error 2304 at `fn`.
Clean: offers "Add missing function declaration 'fn'" (non-nullable type is used to find the call signature).
Injected: the nullable union isn't stripped, so no fix is offered (fixes: 0).
