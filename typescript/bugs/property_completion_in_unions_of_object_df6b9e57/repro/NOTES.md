Input: `type U = {key1:string} | {key2:number} | \`s ${string}\``, then `const o: U = {  }` with completions requested inside the braces (language service, real lib).
Clean: completions are only the object properties `key1,key2`.
Injected: template literal types are not treated as primitive, so String methods (`anchor`, `at`, `charAt`, ...) also appear in the list.
