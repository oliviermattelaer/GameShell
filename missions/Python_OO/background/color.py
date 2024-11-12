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

    def flip(self):
        """flip the content of red and blue of the current object"""
        self.blue, self.red = self.red, self.blue


    def __add__(self, other):
        """ return the average for each of the RGB value """
        r = (self.red + other.red)/2 
        g = (self.green + other.green)/2
        b = (self.blue + other.blue)/2
        return Color(r,g,b)

    def __eq__(self, other):

        return self.red == other.red and self.green == other.green and self.blue == other.blue 

# Define here a new class ColorTransparent
# which is a normal "Color" but also has a new attribute transparency
class ColorTransparent(Color):

    def __init__(self, red, green, blue, alpha=0):
        #Do not write the following line
        # self.red = red
        # you can use Color.__init__ or super().__init__
        Color.__init__(self, red, green, blue)    
        self.alpha = alpha

    def __str__(self):
        "should return something like RGB=(1,2,3) alpha=0.5"
        # again the first part is the one from color, just reuse it
        return super().__str__() + f" alpha={self.alpha}"

    def display(self, background):
        """ return a Color that should be effectively displayed given the backgroun """

        # first check that background is of the correct type
        if not .....:
            raise Exception

        # compute the result:
        # red = (1-alpha) * self.red + alpha * background.red
        # ...


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


    

