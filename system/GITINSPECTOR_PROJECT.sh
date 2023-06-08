#CODER BY xiaoyao9184 1.0
#TIME 2016-10-25
#FILE GITINSPECTOR_PROJECT
#DESC run gitinspector for git local repository project




#! /bin/sh




# v

tip=VCS-GITSTATS
ver=1.0
gitinspectorPath=$(cd "$(dirname "$0")"; pwd)/gitinspector
projectName=
gitPath=
reportPath=
date=$(date '+%Y-%m-%d')


# check

while [ ! -x "$gitinspectorPath" ]; do
    read -p "Cant find $gitinspectorPath, will clone form github?" yn
    case $yn in
        [Yy]* ) git clone https://github.com/ejwa/gitinspector.git $gitinspectorPath; break;;
        [Nn]* ) echo -n "Enter your gitinspector path:"; read gitinspectorPath;;
        * ) echo "Please answer yes or no.";;
    esac
done


if [ -z ${gitPath} ]; then
    echo -n "Enter your git local repository path:"
    read gitPath
fi

if [ -z ${projectName} ]; then
    projectName=${gitPath##*/}
fi

if [ -z ${reportPath} ]; then
    reportPath=${gitinspectorPath%/*}/$projectName
fi




# tip

echo "Your gitinspector path is $gitinspectorPath"
echo "Your project path is $gitPath"
echo "Your project name is $projectName"
echo "Your project report path is $reportPath"
echo "Your project report file is $projectName@${date}.html"

echo "Running..."



#begin

cd $gitinspectorPath

python ./gitinspector/gitinspector.py --format=html --timeline --localize-output --weeks $gitPath > "$reportPath/$projectName@${date}.html"




# end

read -n1 -r -p "Press any key to exit..." key
exit 0