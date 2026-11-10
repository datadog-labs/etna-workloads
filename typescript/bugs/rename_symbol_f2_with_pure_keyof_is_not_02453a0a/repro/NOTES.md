Input: an interface with a string-literal property `"Prop 1"` and a call `fn("Prop 1")` where the parameter type is `K extends keyof I`.
The script asks the language service for rename locations at the string literal in the call.
Clean: also returns the property signature `"Prop 1"` in the interface (two locations).
Injected: omits the declaration and returns only the call-site literal.
