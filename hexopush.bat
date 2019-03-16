:input
title hexo源码自动提交

set /p des=输入提交描述ENTER结束:

echo "begin it ..."
E:
cd E:\AElseworld\Code\Github\myfirst_hexo
::每次提交前切换到master分支
git checkout master
git add .
git commit -m "%des%"
echo 正在提交:%des%
git push origin master
echo "finshished!"

pause>nul
cls & goto input