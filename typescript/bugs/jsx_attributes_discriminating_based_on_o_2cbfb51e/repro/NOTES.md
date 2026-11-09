A discriminated props union (one member has required `children` function, other has optional `children?: undefined`) is used in JSX with children given as a function body.
Clean: children correctly don't discriminate on optional `children`, so `({ onClose })` is contextually typed; no errors.
Injected: optional children is used as discriminant (undefined), the callback loses its contextual type, giving TS7031 implicit any on `onClose`.
