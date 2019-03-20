---
title: Linux Vulhub安装过程的学习
date: 2019-02-27 09:09:54
updated:
tags: [靶场,linux]
description:
keywords:
comments:
image:
categories:
  - 笔记
---
搭建Vulhub,以及遇到的问题,熟悉一点linux
<!--more-->
挑选了搭建较为简单的Vulhub
Vulhub是一个面向大众的开源漏洞靶场，无需docker知识，简单执行两条命令即可编译、运行一个完整的漏洞靶场镜像。
官网建议使用Ubuntu.只是搭建一个靶机,所以我也使用ubuntu 16.04x64.

如果要查看如何安装直接跳到 [整理后的命令](#zl)

# 总结
最开始使用的ubuntu 18.04,遇到很多问题,然后换用推荐的16.04,依然是编译问题,而且,使用curl安装pip也出了问题.只能使用apt安装,安装后就是编译问题,按着报错提示,更改命令,也搜索了不少帖子.没有解决
折腾了半天,没解决.
然后切换了root用户,不再使用sudo命令,所有的操作都按照vulhub官方给的安装方法,成功了.

新手遇到需要配置学习的东西尽量还原教程的环境,这样会避免许多不必要的问题.然后,linux要配置什么环境果然还是用root用户,反正只是靶机以后都用root估计会避免很多问题.
然后代理也得挂着,不然下载软件实在是没办法.

# 我的执行过程
最开始当然是vm里安装ubuntu,我的ubuntu是`ubuntu-18.04.1-desktop-amd64`
vm使用最新版本会避免很多问题 ,之前使用vm12,安装很麻烦.装vmtools都花了好多时间.

下面进入vulhub安装
首先按照命令安装pip

```
eva12@eva12-virtual-machine:~$ curl -s https://bootstrap.pypa.io/get-pip.py | python3

Command 'curl' not found, but can be installed with:

sudo apt install curl
```

提示缺少curl,那么按照提示安装curl

```
sudo apt install curl
```

要求输入密码,直接输入系统密码
> 注意:linux输入的密码是不会显示的.

由于安装pip还要用到py3,我们还是先安装好吧

```
sudo apt-get install python3
```
一路回车

继续安装pip

```
curl -s https://bootstrap.pypa.io/get-pip.py | python3
```

报错

```
Traceback (most recent call last):
  File "<stdin>", line 21361, in <module>
  File "<stdin>", line 197, in main
  File "<stdin>", line 82, in bootstrap
  File "/tmp/tmpmxmcr3g5/pip.zip/pip/_internal/__init__.py", line 40, in <module>
  File "/tmp/tmpmxmcr3g5/pip.zip/pip/_internal/cli/autocompletion.py", line 8, in <module>
  File "/tmp/tmpmxmcr3g5/pip.zip/pip/_internal/cli/main_parser.py", line 8, in <module>
  File "/tmp/tmpmxmcr3g5/pip.zip/pip/_internal/cli/cmdoptions.py", line 14, in <module>
ModuleNotFoundError: No module named 'distutils.util'
```
ModuleNotFoundError,猜测是py环境的原因吧,大概需要指定系统为py3环境(猜的)

我们直接搜索下ubuntu中pip如何安装.
中途发现有这样一个知识.
> 在使用apt安装任何软件包之前，建议使用以下命令更新软件包列表：
> sudo apt update

那么我更新下再重安装下curl和py3

然后可以顺便给py2也装个pip

```
sudo apt install python-pip
```
py2的pip瞬间成功,更加坚定了py3安装pip的报错是环境原因
但还是验证下版本.

```
p~$ ip --version
9.0.1 from /usr/lib/python2.7/dist-packages (python 2.7)
```
安装用于构建Python模块所需的开发工具，以供Python 2运行：

```
sudo apt install build-essential python-dev python-setuptools
```

**为Python 3安装pip**

这里没有使用vulhub官网的安装命令,直接使用包管理安装

```
sudo apt install python3-pip
```
成功了,同样查看下版本

```
va12@eva12-virtual-machine:~$ pip3 --version
pip 9.0.1 from /usr/lib/python3/dist-packages (python 3.6)
```
安装用于构建Python模块所需的开发工具，以供Python 3运行：

```
va12@eva12-virtual-machine:~$ sudo apt install build-essential python3-dev  python3-setuptools
Reading package lists... Done
Building dependency tree       
Reading state information... Done
build-essential is already the newest version (12.4ubuntu1).
python3-setuptools is already the newest version (39.0.1-2).
python3-setuptools set to manually installed.
python3-dev is already the newest version (3.6.7-1~18.04).
python3-dev set to manually installed.
0 upgraded, 0 newly installed, 0 to remove and 405 not upgraded.
```

回到vulhub官网,安装最新版本docker

```
eva12@eva12-virtual-machine:~$ curl -s https://get.docker.com/ | sh
# Executing docker install script, commit: 40b1b76
+ sudo -E sh -c apt-get update -qq >/dev/null
+ sudo -E sh -c apt-get install -y -qq apt-transport-https ca-certificates curl >/dev/null
+ sudo -E sh -c curl -fsSL "https://download.docker.com/linux/ubuntu/gpg" | apt-key add -qq - >/dev/null
Warning: apt-key output should not be parsed (stdout is not a terminal)
+ sudo -E sh -c echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic edge" > /etc/apt/sources.list.d/docker.list
+ sudo -E sh -c apt-get update -qq >/dev/null
+ sudo -E sh -c apt-get install -y -qq --no-install-recommends docker-ce >/dev/null
+ sudo -E sh -c docker version
Client:
 Version:           18.09.2
 API version:       1.39
 Go version:        go1.10.6
 Git commit:        6247962
 Built:             Sun Feb 10 04:13:47 2019
 OS/Arch:           linux/amd64
 Experimental:      false

Server: Docker Engine - Community
 Engine:
  Version:          18.09.2
  API version:      1.39 (minimum version 1.12)
  Go version:       go1.10.6
  Git commit:       6247962
  Built:            Sun Feb 10 03:42:13 2019
  OS/Arch:          linux/amd64
  Experimental:     false
If you would like to use Docker as a non-root user, you should now consider
adding your user to the "docker" group with something like:

  sudo usermod -aG docker eva12

Remember that you will have to log out and back in for this to take effect!

WARNING: Adding a user to the "docker" group will grant the ability to run
         containers which can be used to obtain root privileges on the
         docker host.
         Refer to https://docs.docker.com/engine/security/security/#docker-daemon-attack-surface
         for more information.

** DOCKER ENGINE - ENTERPRISE **

If you’re ready for production workloads, Docker Engine - Enterprise also includes:

  * SLA-backed technical support
  * Extended lifecycle maintenance policy for patches and hotfixes
  * Access to certified ecosystem content

** Learn more at https://dockr.ly/engine2 **

ACTIVATE your own engine to Docker Engine - Enterprise using:

  sudo docker engine activate
```
看回显安装完成了,为了保险还是看下版本

```
12@eva12-virtual-machine:~$ docker --version
Docker version 18.09.2, build 6247962
```

启动docker服务

```
service docker start
```
要求输入密码,没有回显.代表启动成功了.

安装compose

```
pip install docker-compose 
```
输出一大堆信息.没报错就成功了.

下载vulhub项目

```
wget https://github.com/vulhub/vulhub/archive/master.zip -O vulhub-master.zip
unzip vulhub-master.zip
```

解压

```
unzip vulhub-master.zip
```

进入

```
cd vulhub-master
```

进入某一个漏洞/环境的目录

```
cd flask/ssti
```

自动化编译环境

```
docker-compose build
```
开始报错了,无法识别命令.搞了很久不行.从这里开始尝试使用ubuntu16.04

安装过程略过.

首先切换到root用户

输入`sudo passwd root`
修改密码.
输入`su`
输入密码,进入root模式

```
eva22@eva22-virtual-machine:~$ su
Password: 
root@eva22-virtual-machine:/home/eva22# 
```
更新apt

```
sudo apt update
```

安装curl
```
sudo apt install curl
```

安装pip
```
curl -s https://bootstrap.pypa.io/get-pip.py | python3
```

安装最新版docker

```
curl -s https://get.docker.com/ | sh
```

启动docker服务

```
service docker start
```

安装compose

```
pip install docker-compose 
```
terminal添加代理

```
export http_proxy=http://proxyAddress:port
export https_proxy=https://proxyAddress:port
```

下载项目

```
wget https://github.com/vulhub/vulhub/archive/master.zip -O vulhub-master.zip

```

解压


```
unzip vulhub-master.zip
```

进入某一个漏洞/环境的目录

```
cd flask/ssti
```

动化编译环境

```
docker-compose build
```

启动整个环境

```
docker-compose up -d
```

每个环境目录下都有相应的说明文件，请阅读该文件，进行漏洞/环境测试。
测试完成后，删除整个环境

```
docker-compose down -v
```

<span id="zl"></span>
# 整理后的安装命令
使用ubuntu16.04x64.

## 准备
切换到root用户

输入`sudo passwd root`
修改密码.
输入`su`
输入密码,进入root模式

```
eva22@eva22-virtual-machine:~$ su
Password: 
root@eva22-virtual-machine:/home/eva22# 
```
更新apt

```
sudo apt update
```

terminal设置代理
```
export http_proxy=http://proxyAddress:port
export https_proxy=https://proxyAddress:port
```

## 安装

安装curl
```
sudo apt install curl
```

安装pip
```
curl -s https://bootstrap.pypa.io/get-pip.py | python3
```

安装最新版docker

```
curl -s https://get.docker.com/ | sh
```

启动docker服务

```
service docker start
```

安装compose

```
pip install docker-compose 
```
terminal添加代理

```
export http_proxy=http://proxyAddress:port
export https_proxy=https://proxyAddress:port
```

下载项目

```
wget https://github.com/vulhub/vulhub/archive/master.zip -O vulhub-master.zip

```

解压


```
unzip vulhub-master.zip
```

进入某一个漏洞/环境的目录

```
cd flask/ssti
```

动化编译环境

```
docker-compose build
```

启动整个环境

```
docker-compose up -d
```

每个环境目录下都有相应的说明文件，请阅读该文件，进行漏洞/环境测试。
测试完成后，删除整个环境

```
docker-compose down -v
```


# 关于不了解的命令/工具
## curl
在Linux中curl是一个利用URL规则在命令行下工作的文件传输工具，可以说是一款很强大的http命令行工具。它支持文件的上传和下载，是综合传输工具，但按传统，习惯称url为下载工具

语法：# curl [option] [url]

```
-A/--user-agent <string>              设置用户代理发送给服务器
-b/--cookie <name=string/file>    cookie字符串或文件读取位置
-c/--cookie-jar <file>                    操作结束后把cookie写入到这个文件中
-C/--continue-at <offset>            断点续转
-D/--dump-header <file>              把header信息写入到该文件中
-e/--referer                                  来源网址
-f/--fail                                          连接失败时不显示http错误
-o/--output                                  把输出写到该文件中
-O/--remote-name                      把输出写到该文件中，保留远程文件的文件名
-r/--range <range>                      检索来自HTTP/1.1或FTP服务器字节范围
-s/--silent                                    静音模式。不输出任何东西
-T/--upload-file <file>                  上传文件
-u/--user <user[:password]>      设置服务器的用户和密码
-w/--write-out [format]                什么输出完成后
-x/--proxy <host[:port]>              在给定的端口上使用HTTP代理
-#/--progress-bar                        进度条显示当前的传送状态
```

## pip
Pip用法

使用pip，我们可以从PyPI，版本控制，本地项目和分发文件安装软件包，但在大多数情况下，您将从PyPI安装软件包。

假设我们想要安装一个名为scrapy的包，我们可以通过发出以下命令来实现：

pip install scrapy

scrapy是用于抓取网站并提取结构化数据的Python库

卸载程序包运行：

pip uninstall scrapy

从PyPI搜索软件包：

$pip search "search_query"

列出已安装的软件包：

$pip list
## weget
Linux系统中的wget是一个下载文件的工具，它用在命令行下。对于Linux用户是必不可少的工具，我们经常要下载一些软件或从远程服务器恢复备份到本地服务器。wget支持HTTP，HTTPS和FTP协议，可以使用HTTP代理。所谓的自动下载是指，wget可以在用户退出系统的之后在后台执行。这意味这你可以登录系统，启动一个wget下载任务，然后退出系统，wget将在后台执行直到任务完成，相对于其它大部分浏览器在下载大量数据时需要用户一直的参与，这省去了极大的麻烦。

wget [参数] [URL地址]


### 实例
4．使用实例：

实例1：使用wget下载单个文件

命令：

wget http://www.minjieren.com/wordpress-3.1-zh_CN.zip

说明：

以下的例子是从网络下载一个文件并保存在当前目录，在下载的过程中会显示进度条，包含（下载完成百分比，已经下载的字节，当前下载速度，剩余下载时间）。

实例2：使用wget -O下载并以不同的文件名保存

命令：

: wget -O wordpress.zip http://www.minjieren.com/download.aspx?id=1080

说明：

wget默认会以最后一个符合”/”的后面的字符来命令，对于动态链接的下载通常文件名会不正确。

错误：下面的例子会下载一个文件并以名称download.aspx?id=1080保存

wget http://www.minjieren.com/download?id=1

即使下载的文件是zip格式，它仍然以download.php?id=1080命令。

正确：为了解决这个问题，我们可以使用参数-O来指定一个文件名：

wget -O wordpress.zip http://www.minjieren.com/download.aspx?id=1080

实例3：使用wget –limit -rate限速下载

命令：

wget --limit-rate=300k http://www.minjieren.com/wordpress-3.1-zh_CN.zip

说明：

当你执行wget的时候，它默认会占用全部可能的宽带下载。但是当你准备下载一个大文件，而你还需要下载其它文件时就有必要限速了。

实例4：使用wget -c断点续传

命令：

wget -c http://www.minjieren.com/wordpress-3.1-zh_CN.zip

说明：

使用wget -c重新启动下载中断的文件，对于我们下载大文件时突然由于网络等原因中断非常有帮助，我们可以继续接着下载而不是重新下载一个文件。需要继续中断的下载时可以使用-c参数。

实例5：使用wget -b后台下载

命令：

wget -b http://www.minjieren.com/wordpress-3.1-zh_CN.zip

说明：

对于下载非常大的文件的时候，我们可以使用参数-b进行后台下载。

wget -b http://www.minjieren.com/wordpress-3.1-zh_CN.zip

Continuing in background, pid 1840.

Output will be written to `wget-log'.

你可以使用以下命令来察看下载进度：

tail -f wget-log

实例6：伪装代理名称下载

命令：

wget --user-agent="Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US) AppleWebKit/534.16 (KHTML, like Gecko) Chrome/10.0.648.204 Safari/534.16" http://www.minjieren.com/wordpress-3.1-zh_CN.zip

说明：

有些网站能通过根据判断代理名称不是浏览器而拒绝你的下载请求。不过你可以通过–user-agent参数伪装。

实例7：使用wget –spider测试下载链接

命令：

wget --spider URL

说明：

当你打算进行定时下载，你应该在预定时间测试下载链接是否有效。我们可以增加–spider参数进行检查。

wget --spider URL

如果下载链接正确，将会显示

wget --spider URL

Spider mode enabled. Check if remote file exists.

HTTP request sent, awaiting response... 200 OK

Length: unspecified [text/html]

Remote file exists and could contain further links,

but recursion is disabled -- not retrieving.

这保证了下载能在预定的时间进行，但当你给错了一个链接，将会显示如下错误

wget --spider url

Spider mode enabled. Check if remote file exists.

HTTP request sent, awaiting response... 404 Not Found

Remote file does not exist -- broken link!!!

你可以在以下几种情况下使用spider参数：

定时下载之前进行检查

间隔检测网站是否可用

检查网站页面的死链接

实例8：使用wget –tries增加重试次数

命令：

wget --tries=40 URL

说明：

如果网络有问题或下载一个大文件也有可能失败。wget默认重试20次连接下载文件。如果需要，你可以使用–tries增加重试次数。

实例9：使用wget -i下载多个文件

命令：

wget -i filelist.txt

说明：

首先，保存一份下载链接文件

cat > filelist.txt

url1

url2

url3

url4

接着使用这个文件和参数-i下载

实例10：使用wget –mirror镜像网站

命令：

wget --mirror -p --convert-links -P ./LOCAL URL

说明：

下载整个网站到本地。

–miror:开户镜像下载

-p:下载所有为了html页面显示正常的文件

–convert-links:下载后，转换成本地的链接

-P ./LOCAL：保存所有文件和目录到本地指定目录

实例11：使用wget –reject过滤指定格式下载

命令：
wget --reject=gif ur

说明：

下载一个网站，但你不希望下载图片，可以使用以下命令。

实例12：使用wget -o把下载信息存入日志文件

命令：

wget -o download.log URL

说明：

不希望下载信息直接显示在终端而是在一个日志文件，可以使用

实例13：使用wget -Q限制总下载文件大小

命令：

wget -Q5m -i filelist.txt

说明：

当你想要下载的文件超过5M而退出下载，你可以使用。注意：这个参数对单个文件下载不起作用，只能递归下载时才有效。

实例14：使用wget -r -A下载指定格式文件

命令：

wget -r -A.pdf url

说明：

可以在以下情况使用该功能：

下载一个网站的所有图片

下载一个网站的所有视频

下载一个网站的所有PDF文件

实例15：使用wget FTP下载

命令：

wget ftp-url

wget --ftp-user=USERNAME --ftp-password=PASSWORD url

说明：

可以使用wget来完成ftp链接的下载。

使用wget匿名ftp下载：

wget ftp-url

使用wget用户名和密码认证的ftp下载

wget --ftp-user=USERNAME --ftp-password=PASSWORD url

备注：编译安装

使用如下命令编译安装： 

> tar zxvf wget-1.9.1.tar.gz 
> cd wget-1.9.1 
> ./configure 
> make 
> make install 


