import pathlib, zipapp, zipfile
source = pathlib.Path('src')
source.mkdir()
(source / '__main__.py').touch()
target = source / 'target.pyz'
target.touch()
try:
    zipapp.create_archive(source, target, filter=lambda p: not p.match('*.pyz'))
    with zipfile.ZipFile(target) as z:
        print(z.namelist())
except zipapp.ZipAppError as e:
    print('ZipAppError', e)
