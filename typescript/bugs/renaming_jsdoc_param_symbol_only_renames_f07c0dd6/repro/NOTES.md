Input: a JS file with a JSDoc `@param {Object} options` plus `@param {string} options.foo` / `options.bar` tags.
The script asks the language service for rename locations of `options` at the function parameter and prints the result with each location replaced by NEW.
Clean: the `options` in `options.foo` and `options.bar` are renamed too (5 locations).
Injected: only the first `@param options` and the parameter are renamed; the dotted ones are left alone.
