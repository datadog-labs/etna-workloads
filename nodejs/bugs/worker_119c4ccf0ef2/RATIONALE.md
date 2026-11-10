# Re-introduced bug: SharedArrayBuffer outliving its creating Worker's allocator

**Bug.** A Worker's `ArrayBufferAllocator` was owned solely by the worker thread's `WorkerThreadData`. A `SharedArrayBuffer` posted to another thread can outlive the worker, so its backing store was freed through an allocator that had already been destroyed. This crashed in the original report.

**Today's code.** The release no longer has `SharedArrayBufferMetadata`, because V8 backing stores replaced it. The allocator is a `shared_ptr` that is a local in the `WorkerThreadData` constructor, passed as `params.array_buffer_allocator_shared`. V8 holds that reference through the backing store, which is what keeps the allocator alive now. The fix's three pieces (a Worker-owned `shared_ptr`, a getter, and metadata holding a reference) map onto that one V8 mechanism.

**Change (src/node_worker.cc only).**
1. The allocator becomes a `WorkerThreadData` member, `allocator_`, instead of a constructor local. This matches the fix's removal of the `unique_ptr` member from `WorkerThreadData`, in reverse. Its lifetime is now tied to the worker thread.
2. `params.array_buffer_allocator_shared = allocator` becomes `params.array_buffer_allocator = allocator` (a raw pointer). V8 then takes no reference. This corresponds to the fix's `SharedArrayBufferMetadata` hunks that kept the allocator alive for the buffer's lifetime. With the raw pointer, a surviving SAB no longer extends the allocator's life.
3. `allocator.get()` becomes `allocator` in the `CreateIsolateData` call, a consequence of the local now being a raw pointer.

**Failing test.** `parallel/test-worker-sharedarraybuffer-from-worker-thread` fails on both runs with exit code -6 and `Assertion failed: allocations_.empty()`. The allocator is destroyed while the SAB's memory is still live. `parallel/test-worker-arraybuffer-zerofill` still passes.
