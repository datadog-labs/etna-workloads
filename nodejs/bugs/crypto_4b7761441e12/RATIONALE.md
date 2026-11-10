# Bug
WebCrypto EC `namedCurve` validation used the generic `validateString`/`validateOneOf` helpers, so invalid curves (e.g. 1, true, {}, "P-512") rejected with a Node TypeError (ERR_INVALID_ARG_VALUE / ERR_INVALID_ARG_TYPE) instead of a `NotSupportedError` DOMException as WebCrypto requires.

# Change
Single hunk in `lib/internal/crypto/webidl.js` (`namedCurveValidator`, now shared by EcKeyGenParams/EcKeyImportParams; the code that ec.js's ecGenerateKey/ecImportKey hunks touched has moved here). It corresponds to both ec.js hunks of the fix: the `ArrayPrototypeIncludes(...)` + `lazyDOMException('Unrecognized namedCurve','NotSupportedError')` check is replaced by `validateString` + `validateOneOf(..., ObjectKeys(kNamedCurveAliases))`, restoring the pre-fix behaviour. Added the `validators` import and `ObjectKeys` primordial.

# Failing test
parallel/test-webcrypto-keygen: `not ok`; assertion expected `name: 'NotSupportedError'` but got `TypeError` with code `ERR_INVALID_ARG_VALUE`. Stable over two runs.
