:input
title hexo源码自动提交

set /p des=输入提交描述ENTER结束:

echo "begin it ..."
C:
cd C:\Users\ese\Desktop\E1sewhere_Hexo
git remote add origin git@github.com:e1sewhere/HexoBuckUp.git
git add .
git commit -m "%des%"
echo 正在提交:%des%
git push HexoBuckUp master
echo "finished!"

pause>nul
cls & goto input

# 首次执行前需要删除所有.git文件，然后执行git init 以及 git remote add origin git@github.com:E1sewhere/HexoBuckUp
