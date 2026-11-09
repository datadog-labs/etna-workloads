Input calls an overloaded `foo(1, 1)` whose first overload is `@deprecated`; no overload matches, so an overload-failure error is reported.
Clean: only the TS2769 error. Injected: the synthesized union signature loses its overload-failure flag, so an extra "'foo' is deprecated" suggestion diagnostic (6385) is also reported.
