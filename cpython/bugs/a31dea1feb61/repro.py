from email.utils import getaddresses
print(getaddresses(['"Bud, Person" <bperson@dom.ain>',
                    'aperson@dom.ain (Al Person)',
                    '"Mariusz Felisiak" <to@example.com>']))
