:input
title hexoԴ���Զ��ύ

set /p des=�����ύ����ENTER����:

echo "begin it ..."
E:
cd E:\AElseworld\Code\Github\myfirst_hexo
::ÿ���ύǰ�л���master��֧
git checkout master
git add .
git commit -m "%des%"
echo �����ύ:%des%
git push origin master
echo "finshished!"

pause>nul
cls & goto input