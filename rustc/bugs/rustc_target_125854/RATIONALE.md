# Adapted injection for Move ZST ABI handling to `rustc_target`

Fix: https://github.com/rust-lang/rust/commit/b1493ba5194fcc5cfe4f6315db288e4e18509110

Fix moved ZST handling into rustc_target (powerpc/s390x/sparc64 `make_indirect_force` for ZSTs on linux gnu-like targets).
On 1.99.1 the code lives in compiler/rustc_target/src/callconv/{powerpc,s390x,sparc64}.rs (`make_indirect_from_ignore`).
I added `&& false` to the ZST conditions in powerpc.rs `classify_arg`, s390x.rs `classify_arg`, and sparc64.rs `compute_abi_info`,
so ZSTs are ignored again there. This re-expresses the fix hunks "@@ -8,7 +9,17 @@ fn classify_ret" (powerpc), "@@ -15,12 +16,22 @@" (s390x), "@@ -219,7 +220,14 @@" (sparc64: `arg.make_indirect_force()` for ZST), whose absence = the old bug (pre-fix: ZSTs ignored on those targets).
