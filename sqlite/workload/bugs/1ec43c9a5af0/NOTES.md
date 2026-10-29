Reproducer: with empty_result_callbacks=1, ANALYZE on an empty db makes the loader callback get argv==NULL; buggy shell crashes/asserts, clean returns normally.
