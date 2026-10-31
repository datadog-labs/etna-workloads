import sys, runpy
sys.argv = ['mimetypes', 'a.txt', 'b.html']
runpy.run_module('mimetypes', run_name='__main__')
