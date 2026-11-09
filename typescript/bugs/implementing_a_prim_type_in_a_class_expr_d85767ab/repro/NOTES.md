Input has class expressions that `implements number` / `extends string`.
Clean reports the primitive-specific errors (TS2864 / TS2863 "A class cannot implement/extend a primitive type like ...").
Injected only handles class declarations, so class expressions get the generic "cannot find name"-style errors instead.
