a.js has a class property initialised with an arrow function whose JSDoc has `@this`.
Clean tsc reports error TS2730 "An arrow function cannot have a 'this' parameter" on the `@this` tag.
The injected build reports no diagnostic (exit 0).
