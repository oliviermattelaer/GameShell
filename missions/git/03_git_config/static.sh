if (echo a version 2.23.0; git --version) | sort -Vk3 | tail -1 | grep -q git
then
    echo ""
else
    echo "Git version is too old: update your version of git to be more recent that 2.23.0 (use module load git if you are on cluster)."
    exit
fi

