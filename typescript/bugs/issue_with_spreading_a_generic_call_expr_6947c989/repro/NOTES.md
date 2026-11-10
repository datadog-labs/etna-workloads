Spreads a generic call result (`omit(['bar'], otherProps)`, overloaded generic function) into a generic JSX component `<GenericComponent {...} />`.
Clean: no errors. Injected: error TS2698 "Spread types may only be created from object types" on the spread expression.
