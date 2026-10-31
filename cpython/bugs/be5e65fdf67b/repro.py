import mailbox, os
os.mkdir('foo.bar')
box = mailbox.MH('foo.bar')
print(os.listdir('foo.bar'))
try:
    box.lock()
    box.unlock()
except Exception as e:
    print(type(e).__name__)
print(os.listdir('foo.bar'))
