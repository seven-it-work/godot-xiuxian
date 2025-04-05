@echo off

echo %~dp0

cd /d %~dp0

git fetch --all

git merge origin/main

pause

exit