Reproducer for the asyncio.Semaphore FIFO wake-up bug (test_acquire_fifo_order_4).
Three tasks queue on Semaphore(0); one task releases three times, then a fourth task is created after c1 acquires.
Clean: c1 sees sem._value == 0 after acquire, result [1, 2, 3, 4].
Buggy: acquire() wakes only one extra waiter, so _value is 1 and result is [1, 2, 4, 3].
