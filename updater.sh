#!/bin/sh

# Set variables


# If number of arguments is less than 2, exit with error
if [ "$#" -ne 2 ]; then
  echo "Missing arguments"
  exit 1
fi

updBashrc = $1
updVimrc = $2

echo "updBashrc : " + $updBashrc
echo "updVimrc : " + $updVimrc

#if [ $updBashrc ]; then
  
