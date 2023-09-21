
messages = ['']*10
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

import random
import os
import sys

def get_new_text_random(input):
    template = "messages[%i] = \"%s\"\n"


    new_text = ""
    new_messages = messages[:]
    random.shuffle(new_messages)
    for i, msg in enumerate(new_messages):
        new_text += template % (i,msg)
        if msg == messages[nb_messages]:
            new_index = i

    new_text += "nb_messages =  %i\n" % new_index


    text = open(input, 'r').read()
    start, _  = text.split('#KEY1',1)
    _, end  = text.split('#KEY2',1)


    new_file = """%s
#KEY1
%s
#KEY2
%s
""" %(start, new_text, end)
    return new_file

input = 'produce.py'
import time

possible_flip = list(range(20,40))
flip = random.choices(possible_flip)[0]
for i in range(flip):
    text = get_new_text_random(input)
    fsock = open(input,'w')
    fsock.write(text)
    fsock.close()
    os.system('git commit -am "bug fix %s" ' % time.time())
    

text = open(input).read()
text = text.replace('calendar.month_name[1:]','calendar.month_name')
fsock = open(input,'w')
fsock.write(text)
fsock.close()
os.system('git commit -am "bug fix %s" ' % time.time())
    
for i in range(64-flip):
    text = get_new_text_random(input)
    fsock = open(input,'w')
    fsock.write(text)
    fsock.close()
    os.system('git commit -am "bug fix %s" ' % time.time())



            

         
