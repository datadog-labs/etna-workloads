# Rationale
Reverted the X509_get_signature_info() preference in both places where the cert signature algorithm is determined (the RSA-PSS fix).

1. src/backend/libpq/be-secure-openssl.c, be_tls_get_certificate_hash(): removed the `#if HAVE_X509_GET_SIGNATURE_INFO` branch, so only OBJ_find_sigid_algs(X509_get_signature_nid()) is used. Traces to the be-secure-openssl.c hunk in fix_impl.patch. For RSA-PSS certs this yields no usable digest NID, so the server fails with "could not determine server certificate signature algorithm".
2. src/interfaces/libpq/fe-secure-openssl.c, pgtls_get_peer_certificate_hash(): same removal, traced to the fe-secure-openssl.c hunk. The client can't compute the channel-binding hash for RSA-PSS certs.

The header/`#if defined(...)` guard hunks were left alone, since the macro guards are harmless without the C branch.

Failing oracle cases (src/test/ssl|t/002_scram.pl):
- SCRAM with SSL and channel_binding=require, server certificate uses 'rsassaPss'
- ...: log matches
- ...: no stderr
