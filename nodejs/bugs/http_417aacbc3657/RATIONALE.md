# Re-introduced bug: closeIdleConnections() ignores sockets that never sent data

Bug: `server.closeIdleConnections()` only treated a connection as idle if its parser had
completed a message (`last_message_start_ == 0`). A socket that connected but never sent
any bytes (pre-request) was not returned by `ConnectionsList::Idle`, so it stayed open
and `server.close()` never finished closing it.

Changes (all in src/node_http_parser.cc), each reverting one fix hunk:
1. Removed `received_data_ = true;` in the message-begin handler (fix hunk 1).
2. Removed `parser->received_data_ = false;` in Parser::Initialize when a connectionsList is given (hunk 2).
3. Removed the `bool received_data_ = false;` member (hunk 3).
4. In `ConnectionsList::Idle`, condition back to `parser->last_message_start_ == 0` (hunk 4).
   Pre-request parsers have last_message_start_ set at init, so they are no longer idle.

Failing test: parallel/test-http-server-close-idle-connections-pre-request
 -> AssertionError: function should not have been called at ...pre-request.js:15
 (the socket is not closed within the timeout window; the mustNotCall timer fires).
