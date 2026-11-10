Input narrows `InstanceOne | InstanceTwo` with `instanceof` against a constructor typed as an intersection `{ new(): InstanceOne } & { foo: true }`, then calls `instance.one()`.
Clean: no errors (exit 0). Injected: isTypeDerivedFrom ignores intersections, so narrowing fails and TS2339 "Property 'one' does not exist on type 'InstanceOne | InstanceTwo'" is reported (exit 2).
