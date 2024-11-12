#!/usr/bin/env python3

#
#
# Here define a class Color 
# which has three attribute red green blue 
#
class Color:
    """A class describe a color"""

    def __init__(self, red, green, blue):
        self.red = red
        self.blue = blue
        self.green = green

if "__main__" == __name__:
    color1 = Color(1,2,3)
    color2 = Color(4,5,6)
    print(color1)
    # Add here a print of the red component of the color2 object
    print(...)
    # Add here a print of the blue component of the color1 object
    print(...)
