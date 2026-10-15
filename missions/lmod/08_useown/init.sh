#!/usr/bin/env sh

# TEMPORARY workaround: with Lmod's cached loads (LMOD_CACHED_LOADS=True,
# e.g. on lemaitre4), "module load use.own" fails with
# "Did not find mpath in mA". Remove once the cluster's Lmod is fixed.
export LMOD_CACHED_LOADS=no

cd "$GSH_HOME/Movies/gl_1971"
#git disable VESUVE 2&> /dev/null

if [ ! -e thx_1138.sh ];then
	echo "#!/usr/bin/env python3" > thx_1138.sh
	echo "import thx1138" >> thx_1138.sh
	echo "print(\"You are a true believer, blessings of the State, blessings of the masses. Work hard, increase production, prevent accidents, and be happy.\")" >> thx_1138.sh
fi
chmod +x thx_1138.sh

cd "$GSH_HOME"/Movies/lib/site-package/python3.10

if [ ! -e thx1138.py ];then
	echo "print(\"quote from the movie...\")" > thx1138.py
fi

cd "$GSH_HOME"



true
