echo "begin it ..."
E:
cd E:\AElseworld\Code\Github\myfirst_hexo
git add .
git commit -m "$*"
echo $*
git push origin master
echo "finshished!"