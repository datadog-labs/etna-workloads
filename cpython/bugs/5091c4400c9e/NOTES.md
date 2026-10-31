Replays the events of test_newline_within_block_trailing_whitespace (using the test package's pyrepl support helpers): type a block, move the cursor into it, press Enter twice, then twice again at the end of the line before trailing whitespace.
Clean: `reader.finished` is True and the buffer has no stray newline.
Buggy: `finished` is False and the buffer contains an extra "\n" (the block isn't terminated because the check for a newline before the cursor was removed).
