#!/bin/sh

# Set variables


# If number of arguments is less than 2, exit with error
if [ "$#" -ne 2 ]; then
  echo "Missing arguments"
  exit 1
fi

updBashrc = $1
updVimrc = $2

if [ $updBashrc ]; then
  echo "Bash True"
else
  echo "Bash False"
fi

if [ $updVimrc ]; then
  echo "Vim True"
else
  echo "Vim False"
fi

#if [ $updBashrc ]; then
  
