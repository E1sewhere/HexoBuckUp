:input
title hexoԴ���Զ��ύ

set /p des=�����ύ����ENTER����:

echo "begin it ..."
C:
cd C:\Users\ese\Desktop\E1sewhere_Hexo
git remote add origin git@github.com:e1sewhere/HexoBuckUp.git
git add .
git commit -m "%des%"
echo �����ύ:%des%
git push HexoBuckUp master
echo "finished!"

pause>nul
cls & goto input

# �״�ִ��ǰ��Ҫɾ������.git�ļ���Ȼ��ִ��git init �Լ� git remote add origin git@github.com:E1sewhere/HexoBuckUp
