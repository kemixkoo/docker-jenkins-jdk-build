#!/bin/bash

#
# Usage: ./gitx.sh <command>
#
# Author: Kemix Koo <kemix_koo@163.com>
#

WS_Path=$(pwd)
commandName=$*

if [ "$#" -lt 1 ]; 
then
	commandName="status"
fi


#record start time
starttime=$(date +'%s')

GIT_REPO_FLAG=".git"
num=0
for gitRepoPath in $(find $WS_Path -mindepth 1 -maxdepth 4 -type d -name $GIT_REPO_FLAG | sort);
do
    let num=$num+1
	repoPath=${gitRepoPath%$GIT_REPO_FLAG}
	cd $repoPath
	echo "###############################################"
	echo "Git repo: $repoPath"
	echo "..............................................."
    git $commandName
    echo 
done

#check spent time
endtime=$(date +'%s')
spenttime=$((endtime-starttime))
minutes=$((spenttime/60))
seconds=$((spenttime%60))
spentstr="$spenttime s"
if [[ $minutes>0 ]]; then
    spentstr="${minutes}m ${seconds}s"
fi
echo 
echo   ">>>> Finished to do 'git ${commandName}' on '${num}' repositories in $spentstr <<<<"
echo 

