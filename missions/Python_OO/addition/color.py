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

    def __str__(self):
        """ return a string for this object"""
        return f"RGB=({self.red},{self.green},{self.blue})"

    def flip():
        """flip the content of red and blue of the current object"""
        self.blue, self.red = self.red, self.blue


    def __add__(self, other):
        """ return the average for each of the RGB value """

if "__main__" == __name__:
    color1 = Color(2,4,6)
    color2 = Color(0,0,0)
    color3 = color1 + color2
    print(color1)
    print(color2)
    print(color3)
    assert id(color1) != id(color3)
    assert id(color2) != id(color3)
    assert color3.red == 1 and color3.green==2 and color3.blue==3 
