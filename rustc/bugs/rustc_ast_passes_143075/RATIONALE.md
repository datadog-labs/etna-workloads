# Adapted injection for compiler: allow interrupts to return () or !

Fix: https://github.com/rust-lang/rust/commit/d6b3314fb29cc688a968811b6a78dc8a5309cb7d

File: compiler/rustc_ast_passes/src/ast_validation.rs (1.99.1 code moved/rewritten)
1. `reject_return` (x86-interrupt path), re-expresses fix hunk `@@ -396,7 +396,13 @@` (`if let FnRetTy::Ty(ref ret_ty) = sig.decl.output && match &ret_ty.kind { Never => false, Tup empty => false, _ => true }`): restored the old unconditional `if let FnRetTy::Ty(ref ret_ty) = sig.decl.output`, so `-> !` / `-> ()` are rejected.
2. `reject_params_or_return` (non-x86 interrupts), re-expresses hunk `@@ -455,7 +461,13 @@`: removed the `allowed_return` never/unit filter so any explicit return type is pushed to `spans`.
