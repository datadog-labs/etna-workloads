Calls the variadic generic method expression `(*Q[int]).Push` through a func value. The buggy compiler builds the wrapper call without the variadic flag, so compilation fails (clean prints "100 99").
