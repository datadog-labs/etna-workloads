# util.inspect: prototypes not inspected

Bug: when an object's prototype chain has no usable `constructor` (e.g. prototype is a null-prototype function/array/object), `util.inspect` printed nothing about the prototype, making such objects indistinguishable. The fix prints `<inspected prototype>`.

Change (lib/internal/util/inspect.js, `getConstructorName`): the fix's hunk replaced `return ''` with `return \`<${inspect(firstProto, {...ctx, customInspect:false})}>\``. In today's code that logic is the `protoConstr === null` branch (which returns `${res} <${inspect(firstProto,...)}>`). I replaced that branch body with `return ''`, restoring the old "unknown prototype -> empty name" behaviour. (The fix's other hunks only threaded `ctx` through callers; today's code already passes ctx, so no counterpart is needed.)

Failing test: parallel/test-util-inspect, e.g. actual `' { a: true }'`, expected `'Object <[Function (null prototype) (anonymous)]> { a: true }'`.
