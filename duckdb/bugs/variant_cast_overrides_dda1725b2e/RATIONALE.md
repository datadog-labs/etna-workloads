# Rationale

File: src/src/function/cast/variant/from_variant.cpp

Two hunks, both tracing to the fix's replacements of `value.DefaultTryCastAs(...)` with `conversion_data.TryCastAs(...)`:
1. `CastVariantToPrimitive` (~line 212): back to `value.DefaultTryCastAs(target_type, nullptr, true)`.
2. `CastVariant` (~line 682, the generic per-row cast): back to `value.DefaultTryCastAs(target_type, nullptr, true)`.

Casts out of VARIANT then use only the default cast set, not the client's full set (e.g. ICU TIMESTAMPTZ casts), so the session TimeZone is ignored.

## Oracle
```
FAIL     test/sql/types/variant/variant_icu_casts.test
         test/sql/types/variant/variant_icu_casts.test:17
         select '1992-09-20 12:30:00.123456789+05:00'::TIMESTAMPTZ::VARIANT as tv;
         1992-09-20 07:30:00.123456+00 <> 1992-09-20 09:30:00.123456+02
1 of 1 oracle units fail
```
