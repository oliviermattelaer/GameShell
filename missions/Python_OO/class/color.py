#!/usr/bin/env python3

#
#
# Here define a class Color 
# which has three attribute red green blue 
#
class Color:
    """A class describe a color"""

    def __init__(self, ....):
        .....

# Do not touch anything below this line
if "__main__" == __name__:
    color1 = Color(1,0,0)
    color2 = Color(0,0,0)
    color3 = Color(0,1,0)
    color4 = Color(0,0,1)
    print(f'color1 has {color1.red} {color1.green} {color1.blue}')
    print(f'color2 has {color2.red} {color2.green} {color2.blue}')
    # check that order of color are correct
    assert color1.red == 1 
    assert color3.green == 1
    assert color4.blue == 1


