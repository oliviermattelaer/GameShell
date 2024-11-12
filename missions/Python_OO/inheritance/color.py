#!/usr/bin/env python3

# You do not have to change anything in this class
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

# Define here a new class ColorTransparent
# which is a normal "Color" but also has a new attribute transparency
class ColorTransparent

    def __init__(self, red, green, blue, alpha):
        #Do not write the following line
        # self.red = red
        # you can use Color.__init__ or super().__init__
    
        self.alpha = alpha

    def __str__(self):
        "should return something like RGB=(1,2,3) alpha=0.5"
        # again the first part is the one from color, just reuse it
        

    # note that flip is not defined in ColorTransparent but is used below!!

# Do not edit the code below
if "__main__" == __name__:
    color1 = Color(2,4,6)
    print(color1)
    colort1 = ColorTransparent(1,2,3,.5)
    print(colort1)
    assert str(colort1) == "RGB=(1,2,3) alpha=0.5"
    #note that flip is defined automatically!!!
    colort1.flip()
    assert str(colort1) == "RGB=(3,2,1) alpha=0.5"
    
    # note that this will work nicely
    mylist = [Color(1,0,0) , ColorTransparent(0,0,1,0.3)]
    for c in mylist:
        print(c)
        c.flip()
        print(c)

    

