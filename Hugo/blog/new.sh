#!/bin/bash 
if [ $# -eq 2 ]
then
    hugo new post/$1/$1_$2.md
else
    echo "usage : ./new.sh directory name"
fi