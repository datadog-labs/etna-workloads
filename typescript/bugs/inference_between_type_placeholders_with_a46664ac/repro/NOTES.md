Assigns a generic function with parameter `${T}` (T extends 1|2|3) to generic function types with `${T}` params (issue 57807).
Clean: only G2 assignment errors (expected). Injected: also spurious TS2322 errors on G1 and G3 assignments (inference between template placeholders loses the constraint).
