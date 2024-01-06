#!/bin/bash 
echo -e "\033[0;32mDeploying update to github...\033[0m"
hugo -t PaperMod
cd public
git add .
msg="rebuilding site `date`"
if [ $# -eq 1 ]
	then msg="$1"
fi
git commit -m "$msg"
git push -u origin main
cd ..
git add .
msg="rebuilding site `date`"
if [ $# -eq 1 ]
	then msg="$1"
fi
git commit -m "$msg"
git push -u origin main