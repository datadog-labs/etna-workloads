repro.go is the upstream issue66575 test: two package vars initialized by functions, where initv0 depends on a constant.
With the bug, the constant is not prioritized in types2's init-order queue, so v1 is initialized before v0 (prints initv1 then initv0). The clean toolchain prints initv0 then initv1, matching source order.
