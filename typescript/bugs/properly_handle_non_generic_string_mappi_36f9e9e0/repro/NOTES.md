Input declares string-mapping/union/intersection reductions plus the #57117 case (VirtualEvent<T> with Lowercase<T> passed to a param of VirtualEvent<Keys>).
Clean: compiles with no errors. Injected: error TS2345 on `_virtualOn(eventQrl)` because string-mapping types are not reduced against string literals in unions/intersections.
