# Re-introduction of CVE-2020-8265 (use-after-free in StreamBase write/shutdown)

## The bug

`StreamBase::Write()` and `StreamBase::Shutdown()` create a `WriteWrap`/`ShutdownWrap`
request object and then call `DoWrite()`/`DoShutdown()`. For some stream types — notably
`TLSWrap` — these `Do*` calls can *synchronously* complete and destroy the request wrap
(via `Done()` → `OnDone()` → `Dispose()` → `Detach()`), dropping its last `BaseObject`
reference and freeing it while `StreamBase` still holds a raw pointer to it. The upstream
fix keeps the wrap alive for the full duration of the operation by taking a
`BaseObjectPtr<AsyncWrap>` strong reference (`req_wrap_ptr`) *before* calling `DoWrite`/
`DoShutdown` and carrying it out of `Write()` inside `StreamWriteResult::wrap_obj`.
Removing that strong reference re-introduces the use-after-free: during a TLS write the
previous request can be torn down synchronously, and the subsequent TLS write hits
`CHECK(!current_write_)` in `TLSWrap::DoWrite` (the freed/retained state is no longer
consistent), aborting the process.

## Hunk-by-hunk correspondence to the fix

The fix (b0ac080fa772) added a `BaseObjectPtr<AsyncWrap> req_wrap_ptr` strong reference in
both `Shutdown` and `Write` and threaded it through `StreamWriteResult`. The release has
since moved `Shutdown`/`Write` from `stream_base-inl.h` into `stream_base.cc`, but the lines
are otherwise the same. My change reverses exactly those retention hunks:

1. **`src/stream_base.cc`, `StreamBase::Shutdown`** — corresponds to the fix's
   `stream_base-inl.h` `Shutdown` hunk (`BaseObjectPtr<AsyncWrap> req_wrap_ptr;` +
   `if (req_wrap != nullptr) req_wrap_ptr.reset(req_wrap->GetAsyncWrap());`). I removed both
   lines, so nothing keeps the `ShutdownWrap` alive across `DoShutdown` — the pre-fix
   behaviour.

2. **`src/stream_base.cc`, `StreamBase::Write`** — corresponds to the fix's
   `stream_base-inl.h` `Write` hunk (`BaseObjectPtr<AsyncWrap> req_wrap_ptr(req_wrap->GetAsyncWrap());`
   inserted right after `CreateWriteWrap`, and `std::move(req_wrap_ptr)` passed into the
   returned `StreamWriteResult`). I removed the retention line and made the final
   `return StreamWriteResult{async, err, req_wrap, total_bytes, {}};` pass an empty
   `wrap_obj`, so no strong reference spans `DoWrite` or outlives the call — the pre-fix
   behaviour.

The `StreamWriteResult::wrap_obj` struct field (fix's `stream_base.h` hunk) is intentionally
left in place: it is referenced by code added to `StreamBase::FinishWrite` *after* the fix,
so removing it would break the build. Leaving it empty (`{}`) faithfully reproduces the
absence of the retained pointer while keeping the tree compilable. This keeps the change
minimal and confined to implementation files under `src/`.

## Failing oracle test

`parallel/test-tls-use-after-free-regression` — passes on the clean release, and with this
change it **fails** (crashes). TAP output:

```
not ok 1 parallel/test-tls-use-after-free-regression
  severity: crashed
  exitcode: -6
  stack: |-
      #  out/Release/node[60]: virtual int node::crypto::TLSWrap::DoWrite(...) at ../src/crypto/crypto_tls.cc:1091
      #  Assertion failed: !current_write_
```

The failure is stable across repeated runs (verified 3×).
