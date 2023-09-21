#!/usr/bin/env python3

from string import ascii_lowercase

def cesar(char, key, decrypt=False):

    v1 = ascii_lowercase.find(char)

    if key == '':
        v2 = 10
    else:
        v2 = ascii_lowercase.find(key)
    if not decrypt:
        v = (v1 + v2)%26
        
    else:
        v = v1 -v2
        if v <= 0:
            v += 26

    return ascii_lowercase[v]

# CESAR VALIDATION
#print( cesar('a','a') , 'a')
#print( cesar('a','b') , 'b')
#print( cesar('b','b') , 'c')
#print( cesar('c','d') , 'f')
#print( cesar('f','d', True) , 'c')
#print( cesar('a','z') , 'z')

import calendar



key = []
for n in calendar.month_name[1:]:
    for m in range(len(n)):
        if n[m] not in key:
            key.append(n[m])
            break
    else:
        key.append(n)

out = []
messages = ['']*10
#KEY1
messages[0] = "tupinut"
messages[1] = "success"
messages[2] = "abcdef"
messages[3] = "qeerfg"
messages[4] = "adfvert"
messages[5] = "dvffer"
messages[6] = "dareggg"
messages[7] = "vvhtdc"
messages[8] = "tvddeyh"
messages[9] = "ivddfsy"
nb_messages = 8
#KEY2
for l,k in zip(messages[nb_messages], key):
    out.append(cesar(l,k))

if ''.join(out) != 'success':
    print('FATAL ERROR')
    import time
    time.sleep(0.1)
    import sys
    sys.exit(1)
else:
    print(''.join(out))
            
            

         
