Starts and stops a QueueListener on a queue.Queue, then prints q.unfinished_tasks.
Clean: 0 (sentinel is task_done'd). Buggy: 1 (sentinel never marked done, so q.join() would hang).
