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

    # Add a function flip that flip the content of red and blue of the current object
    def flip(....

if "__main__" == __name__:
    color1 = Color(1,2,3)
    print(color1)
    assert str(color1) == "RGB=(1,2,3)"
    color1.flip()
    print(color1)
    assert str(color1) == "RGB=(3,2,1)"
