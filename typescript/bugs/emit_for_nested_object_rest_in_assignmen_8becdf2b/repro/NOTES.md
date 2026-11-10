Input has nested object rest inside an array destructuring assignment (`[{ ...x }] = ...`, also in a for-of), compiled with target es2017.
Clean build lowers the object rest (uses __rest); injected build leaves `{ ...x }` untransformed, because it only checks the transform flag of the left side directly.
