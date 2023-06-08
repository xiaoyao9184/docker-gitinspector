@echo off
Setlocal enabledelayedexpansion
::CODER BY xiaoyao9184 1.0
::TIME 2016-10-24
::FILE GITINSPECTOR_PROJECT
::DESC run gitinspector with "--format=html --timeline --localize-output -w" options




:v

::variable set
%~d0
cd %~dp0
set d=%date:~0,10%
set t=%time:~0,8%
set tip=VCS-GITINSPECTOR
set ver=1.0
set gitinspectorPath=%cd%\gitinspector
set projectName=
set projectPath=
set reportPath=

set tipChoice_gitinspector=gitinspector not found, is it cloned through the network [Y yes; N no, manually specify the path]?
set tipEcho_gitinspectorPath=Enter your gitinspector path
set tipSet_gitinspectorPath=Enter or drag a directory here:
set tipEcho_projectPath=Enter your git repository path
set tipSet_projectPath=Enter or drag a directory here:
set tipEcho_projectName=Enter your project name
set tipSet_projectName=Enter name here:




:title
title %tip% %ver%

echo %tip%
echo Do not close!!!
echo ...




:check

::variable check
if not exist %gitinspectorPath% (
	goto :choice
)
goto :choiceEnd

:choice
set /P c=%tipChoice_gitinspector%
if /I "%c%" EQU "Y" goto :clone
if /I "%c%" EQU "y" goto :clone
if /I "%c%" EQU "N" goto :set
if /I "%c%" EQU "n" goto :set
goto :choice

:clone
git clone https://github.com/ejwa/gitinspector.git
goto :choiceEnd

:set
echo %tipEcho_gitinspectorPath%
set /p gitinspectorPath=%tipSet_gitinspectorPath%
goto :choiceEnd

:choiceEnd

if "%reportPath%"=="" (
	for %%p in (!gitinspectorPath!) do (
		set reportPath=%%~dpp
	)
)

if "%projectPath%"=="" (
	echo %tipEcho_projectPath%
	set /p projectPath=%tipSet_projectPath%
        set makeSure=true
)

if "%projectName%"=="" (
	for %%p in (!projectPath!) do (
		set projectName=%%~np
	)
)




:tip
echo Your gitinspector path is: %gitinspectorPath%
echo Your project path is: %projectPath%
echo Your project name is: %projectName%
echo Your project report path is: %reportPath%
echo Your project report file is: %projectName%_%d:/=-%_%t::=-%.html
if "%makeSure%"=="true" pause
echo Running...




:begin

python %gitinspectorPath%\gitinspector.py --format=html --timeline --localize-output --weeks %projectPath% > "%reportPath%\%projectName%_%d:/=-%_%t::=-%.html"




:exit
echo Press any key to exit...

pause
