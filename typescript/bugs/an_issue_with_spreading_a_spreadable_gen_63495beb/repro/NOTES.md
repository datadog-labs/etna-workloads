Input spreads the result of an overloaded generic function call (`omit([...], obj)`) into a generic JSX component (`<GenericComponent {...omit(...)} />`).
Clean build: no diagnostics, exit 0.
Injected build: reports error TS2698 "Spread types may only be created from object types" on the spread expression.
