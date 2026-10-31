import mailbox
mb = mailbox.mbox('box')
k = mb.add('From foo@bar blah\nFrom: foo\n\nbody\n')
print(mb.get_string(k, from_=True).startswith('From foo@bar blah\n'))
mb.close()
