# Rationale

Bug: `util.inspect` of a class instance's prototype (an object whose own `constructor` property is a class it is not an instance of) used that constructor's name, so `Object.getPrototypeOf(new Foo())` printed as `Foo {...}`, and function `[prototype]` objects printed as `func { [constructor]: ... }`.

Change (lib/internal/util/inspect.js, `getConstructorName`): dropped the `isInstanceof(tmp, descriptor.value)` condition. This corresponds to the fix's hunk adding `tmp instanceof descriptor.value` (today's code uses the `isInstanceof` helper). Other fix hunks (url, encoding, vm module custom inspect) are not reverted: they only adapt internal inspectors, and the release's versions are not reversible verbatim; the core regression lives in inspect.js.

Failing tests: parallel/test-util-format, parallel/test-util-inspect, parallel/test-whatwg-encoding-custom-textdecoder (the latter's inspect output of the TextDecoder prototype/constructor changes as a result). Failures are assertion mismatches, e.g. `[prototype]: func { [constructor]: [Circular *1] }` instead of `[prototype]: { [constructor]: [Circular *1] }`.
