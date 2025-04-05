@echo off

echo %~dp0

cd /d %~dp0



git add *

git commit -m "auto push"

git push

pause

exit

