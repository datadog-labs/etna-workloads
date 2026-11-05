# Rationale

Changed: src/src/backend/utils/misc/guc.c, `set_config_option_ext()`.
Traces to the fix.patch guc.c hunk that added the "Disallow resetting and saving GUC_NO_RESET values" block (error "cannot be reset" / "cannot be set locally in functions"). I removed that block, so RESET and function-local SAVE of GUC_NO_RESET parameters (transaction_isolation, transaction_read_only, transaction_deferrable, seed) are no longer rejected. The flag is still defined and set, but nothing enforces it.

Failing oracle cases: src/test/regress||guc, src/test/regress||transactions.
