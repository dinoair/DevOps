#! /usr/bin/env bash

if [ -z $1 ] || [ -z $2 ] || [ -z  $3 ]
then
    echo "You need to put"
    echo "$0 <repo> <branch1> <branch2>"
    exit
fi


fd="hw1-1"
rm -rf ${fd} 2> /dev/null
mkdir ${fd}
cd ${fd}
rep_name="repo"
git clone $1 ${rep_name}
cd ${rep_name}
git checkout $2 > /dev/null
git checkout $3 > /dev/null
git diff --name-only $2..$3 > ../difference.txt
cd ..
rm -rf ${rep_name}
