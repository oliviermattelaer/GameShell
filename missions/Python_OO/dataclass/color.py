#!/usr/bin/env python3

import sys
if  sys.version_info[1] < 7:
    print('This level needs python3.7 or newer')
    sys.exit(1)

import dataclasses
from dataclasses import dataclass


# Here you need a decorator !!! 
class Color:
    """A class describe a color"""

    # This you can remove (and replace by type annotation trick)
    def __init__(self, red, green, blue):
        self.red = red
        self.green = green
        self.blue = blue

    # This you can keep untouched
    def __str__(self):
        """ return a string for this object"""
        return f"RGB=({self.red},{self.green},{self.blue})"

    # this you can keep untouched
    def flip(self):
        """flip the content of red and blue of the current object"""
        self.blue, self.red = self.red, self.blue

    # this you can keep untouched
    def __add__(self, other):
        """ return the average for each of the RGB value """
        r = (self.red + other.red)/2 
        g = (self.green + other.green)/2
        b = (self.blue + other.blue)/2
        return Color(r,g,b)

    # this you can remove
    def __eq__(self, other):

        return self.red == other.red and self.green == other.green and self.blue == other.blue 

# here you also need a decorator
class ColorTransparent(Color):

    # This you can remove (and replace by type annotation trick)
    def __init__(self, red, green, blue, alpha=0):
        #Do not write the following line
        # self.red = red
        # you can use Color.__init__ or super().__init__
        Color.__init__(self, red, green, blue)    
        self.alpha = alpha

    #This you do not need to change
    def __str__(self):
        "should return something like RGB=(1,2,3) alpha=0.5"
        # again the first part is the one from color, just reuse it
        return super().__str__() + f" alpha={self.alpha}"

    # This you do not need to change
    def display(self, background):
        """ return a Color that should be effectively displayed given the backgroun """

        # first check that background is of the correct type
        if not isinstance(background, Color):
            raise Exception

    
        # compute the result:
        r = (1-self.alpha) * self.red + self.alpha * background.red
        g = (1-self.alpha) * self.green + self.alpha * background.green
        b = (1-self.alpha) * self.blue + self.alpha * background.blue

        return Color(r,g,b)

#do not change anything below this point
if "__main__" == __name__:
    color1 = Color(2,4,6)
    print(color1)
    colort1 = ColorTransparent(6,4,2,.5)
    print(colort1)
    assert str(colort1) == "RGB=(6,4,2) alpha=0.5"
    #note that flip is defined automatically!!!
    color2=colort1.display(color1)
    assert color2 == Color(4,4,4)
    if isinstance(color2, ColorTransparent):
        assert color2.alpha == 0
    assert str(colort1) == "RGB=(6,4,2) alpha=0.5"
    assert Color(0,0,0) != ColorTransparent(0,0,0,0)

    

