Input: a JS file with JSDoc `@param {Object} options` plus `@param {number} options.a` / `options.b`, queried via language-service quick info on `f`.
Clean: the quick info tags include the nested property tags (options.a, options.b) as separate entries.
Injected: those property tags are missing; only the top-level `param` and `returns` tags are listed.
