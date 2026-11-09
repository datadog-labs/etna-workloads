Input: a generic function that attaches a property to an inner function and returns it; quick info is requested on the property at a call site `createProps({}).createVariants()`.
Clean: prints `(property) getProps<{}>.createVariants: () => void`.
Injected: outer type parameters of the function symbol are computed wrongly, so quick info output differs (or crashes, caught and printed as `crash`).
