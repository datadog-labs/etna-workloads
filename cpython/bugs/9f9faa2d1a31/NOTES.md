Closes an epoll object's fd behind its back with os.close(), then calls epoll.close().
Clean: raises OSError(EBADF) -> prints "OSError True". Buggy: the errno check in
select_epoll_close_impl is wrong, so the error is swallowed -> prints "no error".
