:input
title hexoԴ���Զ��ύ

set /p des=�����ύ����ENTER����:

echo "begin it ..."
E:
cd E:\AElseworld\Code\Github\myfirst_hexo
git add .
git commit -m "%des%"
echo �����ύ:%des%
git push origin master
echo "finshished!"

pause>nul
cls & goto input