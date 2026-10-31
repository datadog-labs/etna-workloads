Schedules three events with identical time/priority, cancels the middle one, runs the scheduler, prints the executed events.
Clean: ['a', 'c']. Buggy: Event equality ignores the action, so cancel removes the wrong (first-equal) event and the output is ['c', 'b'].
