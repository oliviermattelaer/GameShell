#!/usr/bin/env python3

class Color:
    """A class describe a color"""

    def __init__(self, red, green, blue):
        self.red = red
        self.blue = blue
        self.green = green

    # Need to define a string that represent the object (for print/...)
    # Please use the format RGB=(x,y,z)
    def ...


# Do not change anything below this line
if "__main__" == __name__:
    color1 = Color(1,2,3)
    print(color1)
    assert str(color1) == "RGB=(1,2,3)"
