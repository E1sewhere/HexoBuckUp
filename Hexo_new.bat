:input
title hexo新建笔记

set /p des=输入提交描述ENTER结束:

echo "begin it ..."
hexo new "%des%"

echo 正在新建笔记:%des%

echo "finished!"

pause>nul
cls & goto input