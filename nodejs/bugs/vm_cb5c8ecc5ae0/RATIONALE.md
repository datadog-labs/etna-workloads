# Rationale

**Bug**: In microtaskMode "afterEvaluate", `ModuleWrap::Evaluate()` returned the promise created inside the module's own context. Resolving that promise from the outer context enqueues a thenable job on the inner microtask queue, which was already checkpointed, so `await module.evaluate()` never continued (issue 59541).

**Change** (src/module_wrap.cc, `ModuleWrap::Evaluate`): one hunk, corresponding to the fix's single hunk. The code that created an outer-context `Promise::Resolver`, resolved it with the inner promise, replaced `result` with the outer promise, and then checkpointed the queue was removed. It is replaced with the original `if (!result.IsEmpty() && microtask_queue) microtask_queue->PerformCheckpoint(isolate);`. The inner-context promise is therefore returned directly, as before the fix. The code differs a little from the fix's diff because it is now inside a `result = module->Evaluate(context)` block with a watchdog, but the logic is the same.

**Failing test**: parallel/test-vm-module-after-evaluate (`not ok`, stable across 2 runs). The statement after `await module.evaluate()` is never reached, so `mustCall1` and the outer `.then(common.mustCall())` are not called, and the process exits with the mustCall failures.
