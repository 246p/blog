#!/bin/bash 
if [ $# -eq 1 ]
then
    mv $1 ./public/image
    echo "./../../image/$1"
else
    echo "usage : ./image.sh image_file"
fi