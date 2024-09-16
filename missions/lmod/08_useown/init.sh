#!/usr/bin/env sh

cd "$GSH_HOME"
git disable VESUVE 2&> /dev/null
if [ ! -e Movies ]; then
	mkdir Movies
fi
cd Movies
if [ ! -e gl_1971 ]; then
        mkdir gl_1971
fi
cd gl_1971


if [ ! -e thx_1138.sh ];then
	echo "#!/usr/bin/env python3" > thx_1138.sh
	echo "import thx1138" >> thx_1138.sh
	echo "print(\"You are a true believer, blessings of the State, blessings of the masses. Work hard, increase production, prevent accidents, and be happy.\")" >> thx_1138.sh
fi
chmod +x thx_1138.sh

cd "$GSH_HOME"/Movies
if [ ! -e lib ]; then
        mkdir lib
fi
cd lib
if [ ! -e site-package ]; then
        mkdir site-package
fi
cd site-package
if [ ! -e "python3.10" ]; then
        mkdir "python3.10"
fi
cd python3.10

if [ ! -e thx1138.py ];then
	echo "print(\"quote from the movie...\")" > thx1138.py
fi

cd "$GSH_HOME"

if [ ! -e .local ]; then
        mkdir .local
fi
cd .local
if [ ! -e modules ]; then
        mkdir modules
fi
cd "$GSH_HOME"



true
