# Rationale

**Bug:** `LoadBIO` in `src/crypto/crypto_context.cc` built its BIO with `NodeBIO::NewFixed`. NodeBIO's custom BIO method does not implement `BIO_C_FILE_SEEK`/`BIO_C_FILE_TELL`, so OpenSSL's `PEM_read_bio_PrivateKey` cannot rewind and fails to read some private keys (nodejs/node#47008).

**Hunk (single, `LoadBIO`):** corresponds to the fix's only implementation hunk. The fix replaced the `NodeBIO::NewFixed` calls for strings and ArrayBufferViews with an OpenSSL secure-memory BIO (`BIO_s_secmem`, via `BIOPointer::NewSecMem` in today's code). I restored the old body: `Utf8Value` for strings and `ArrayBufferViewContents<char>` for views, each passed to `NodeBIO::NewFixed`, and `return {}` otherwise. The release now uses ncrypto's `BIOPointer`, so I wrote `return {}` where the original code had `return nullptr`.

**Failing test:** `NodeCryptoEnv.LoadBIO` (cctest). `BIO_seek(bio, 2); ASSERT_EQ(BIO_tell(bio), 2)` fails because NodeBIO does not support tell. The failure reads `(int)BIO_ctrl(bio.get(), 128, ofs, __null)` is 0, expected 2 (`ofs`).
