import mailbox, os
os.makedirs('box/tmp'); os.makedirs('box/new'); os.makedirs('box/cur')
for s in 'new', 'cur':
    with open(f'box/{s}/.foo{s}', 'wb') as f:
        f.write(b'@')
box = mailbox.Maildir('box')
print(sorted(box.iterkeys()))
print('.foonew' in box)
