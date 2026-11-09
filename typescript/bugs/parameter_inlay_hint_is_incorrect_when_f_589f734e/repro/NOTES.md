Input: calls `fn(function (this, a, b) {})` and `fn(function (this: I, a, b) {})` where the callback is contextually typed `(a: number, b: string)`.
The script requests parameter-type inlay hints from the language service.
Clean: hints skip the `this` parameter, so `a` gets `: number` and `b` gets `: string`.
Injected: parameters are matched by index, so hints are misaligned or missing (`a` gets the wrong type, `b` none).
