Calls tempfile._infer_return_type with os.PathLike args and mkstemp(dir=<bytes PathLike>).
Clean: bytes PathLike gives bytes / TypeError on mixing str+bytes; buggy: PathLike is
treated as str (wrong return type, no TypeError, mkstemp returns str).
