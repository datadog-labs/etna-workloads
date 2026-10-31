Calls `wave.Wave_write.setframerate(0.4)`. Clean: rounds first, raises `wave.Error('bad frame rate')`.
Buggy: validates before rounding, so 0.4 is accepted (rate becomes 0) and the error only appears later on close().
