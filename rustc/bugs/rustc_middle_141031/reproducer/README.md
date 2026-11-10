Compiles a dependency with an AsyncDrop impl, then a downstream crate using it; the injected compiler ICEs (DefId::expect_local on a non-local impl) while decoding AsyncDestructor metadata.
