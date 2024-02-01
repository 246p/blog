#!/bin/bash 
if [ $# -eq 1 ]
then
    mv $1 ./public/image
    echo -n "./../../image/$1" | pbcopy

    echo "path copied"
else
    echo "usage : ./image.sh image_file"
fi