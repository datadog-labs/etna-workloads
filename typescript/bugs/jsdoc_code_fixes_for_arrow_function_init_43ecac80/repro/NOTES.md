Input: an exported arrow-function const with a JSDoc `@param {string} y` that doesn't match parameter `x`.
The language-service code fix "Rename '@param' tag name 'y' to 'x'" is requested and its text changes printed.
Clean: replaces the existing comment (removes span 0-41, inserts the new one).
Injected: leaves the old comment and inserts a duplicate comment before the arrow function (span 48).
