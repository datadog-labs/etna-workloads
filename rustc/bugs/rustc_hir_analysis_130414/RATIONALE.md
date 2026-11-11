# Adapted injection for Introduce distinct error codes for precise capturing

Fix: https://github.com/rust-lang/rust/commit/ae8b4607c6c92164dce2e92f9496de189a43bc44

# Hunks
1. compiler/rustc_resolve/src/late.rs, `PathSource::error_code`: precise-capturing args now map back to E0573 (found wrong item) / E0412 (not found) instead of E0799/E0800. Re-expresses fix hunk `@@ -557,9 +557,8 @@` (`(PathSource::Type | PathSource::PreciseCapturingArg(..), true) => E0573`, removed in fix and replaced with dedicated E0799/E0800 arms).
2. compiler/rustc_hir_analysis/src/diagnostics/precise_captures.rs (file moved from errors/), `PreciseCapturesSelfAlias` diag: removed `code = E0799` and the `use rustc_errors::E0799;` import. Re-expresses `@@ -43,7 +44,7 @@`: `-#[diag(hir_analysis_precise_capture_self_alias)]` / `+...code = E0799`.
