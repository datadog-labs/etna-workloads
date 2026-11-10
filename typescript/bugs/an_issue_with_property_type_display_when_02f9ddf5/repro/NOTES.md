Input: a `satisfies` on an object literal whose contextual type is a union (an index-signature member plus a discriminated member), and the literal has a property `someProp` that no matching member declares directly.
`repro.sh` runs quick info on `someProp` through the language service.
Clean prints `(property) someProp: string`. The injected build picks the wrong union member's property symbol when the discriminant filtering leaves no candidates, so the displayed type differs.
