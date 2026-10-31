import dbm.dumb as d, os
with d.open('db', 'n') as f:
    pass
print(os.path.exists('db.dir'))
os.unlink('db.dir')
with d.open('db', 'c') as f:
    print(os.path.exists('db.dir'))
    f.sync()
    os.unlink('db.dir')
    f.sync()
    print(os.path.exists('db.dir'))
print(os.path.exists('db.dir'), os.path.exists('db.bak'))
