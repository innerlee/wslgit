@echo off

rem  Update: 2019-03-11
rem  Author: Liu Yue (hangxingliu@gmail.com)
rem
rem  Description:
rem    Pipe ssh invoking from Windows to ssh in WSL.
rem    And escape character "\\" to "\\\\"
rem
rem
rem  Knowledges:
rem   1. How to implements string replace in Windows batch:
rem        set "VAR=%VAR:REPLACE_FROM=REPLACE_TO%"
rem        Chinese blog: https://www.jb51.net/article/110243.htm
rem   2. Why prepend  `setlocal enabledelayedexpansion`
rem        Stackoverflow: https://stackoverflow.com/questions/6679907
rem   3. How to detect a variable is empty:
rem        Stackoverflow: https://stackoverflow.com/a/2541820/3831547
rem   4. Get command exit code: (Just like "$?" on linux)
rem        Stackoverflow: https://stackoverflow.com/a/334890/3831547
rem
rem

setlocal enabledelayedexpansion

set "currentdir=%cd:\=\\%"

rem Enable interactive mode by default.
rem And disable it by set Windows environment variale WSLSSH_USE_INTERACTIVE_SHELL to 0 or false
set "bashic=true"
if [%WSLSSH_USE_INTERACTIVE_SHELL%] == [0] set bashic=false
if [%WSLSSH_USE_INTERACTIVE_SHELL%] == [false] set bashic=false

if [%1] == [] goto WITHOUT_ARGS

:WITH_ARGS
	set args=%*
	set "args=%args:\=\\%"

	if %bashic% == true (
		wsl zsh -ic 'sshpass -e ssh %args%'
	) else (
		wsl ssh %args%
	)
	exit /b %errorlevel%

:WITHOUT_ARGS
	if %bashic% == true (
		wsl zsh -ic 'ssh'
	) else (
		wsl ssh
	)
	exit /b %errorlevel%
