# Rationale

Today's code centralizes the redact key list in `CreateHTTPSecretFunctions::GetRedactedKeys()` (src/src/main/secret/default_secrets.cpp), used by both `CreateHTTPSecretFromEnv` and `CreateHTTPSecretFromConfig` (the two hunks of the fix). Removing `"extra_http_headers"` from that one list undoes both hunks: `{"http_proxy_password", "bearer_token"}`, as before the fix.

Oracle result:
```
FAIL     test/sql/secrets/http_secret_redaction.test
         Mismatch on row 2, column field(index 2)
         extra_http_headers={Authorization=Bearer dummy-header-token, X-API-Key=dummy-api-key} <> extra_http_headers=redacted
1 of 1 oracle units fail
```
