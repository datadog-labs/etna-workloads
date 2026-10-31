Calls runpy.run_module with several invalid names and runpy.run_path on a directory
without __main__.py, printing ImportError.name. Clean: name is the requested module
name ('__main__' for run_path). Buggy: name is None.
