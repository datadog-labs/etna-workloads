`repro.py` calls `annotationlib.call_annotate_function` with Format.STRING on an annotate function that only supports Format.VALUE (raises NotImplementedError otherwise).
Clean: prints `{'x': 'str'}` (falls back to VALUE and stringifies). Buggy: the NotImplementedError fallback is gone, so a different result/exception is produced.
