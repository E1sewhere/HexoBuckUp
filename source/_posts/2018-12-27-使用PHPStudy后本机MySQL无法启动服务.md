---
title: 使用PHPStudy后本机MySQL无法启动服务
date: 2018-12-27 15:31:46
updated:
tags: [mysql,坑]
description:
keywords:
comments:
image:
---
前段时间使用了下PHPStudy,今天做测试发现本机装的MySQL居然无法启动了.本文记录解决的流程

<!--more-->
# 问题描述
Win10系统,MySQL8.0.
命令行执行`mysql`报错

```
ERROR 2003 (HY000): Can't connect to MySQL server on 'localhost' (10061)
```

# 解决方案
猜想应该是服务没有启动, 于是去任务管理器找服务,发现MySQL的服务不见了
![mysqlphp.png](https://e1sewhere.github.io/images/mysqlphp.png)

+ 于是重新使用CMD(建议使用管理员权限)进入mysql 的`bin`文件夹执行命令

```
mysqld --install
```
+ 发现在已经有mysql 的服务了.
这是在任务管理器启动服务依然启动不了.

+ 继续命令初始化

```
mysqld --initialize
```

+ 使用命令启动服务

```
net start mysql
```

服务启动成功

+ 此时MySQL密码已经被重置,进入MySQL安装目录下的`date`目录,找到`.err`结尾的文件,文档打开搜索字段`password`看到`A temporary password is generated for root@localhost:`这段话后面的代码就是密码

+ 使用`mysql -uroot -p[密码]`登陆

+ 使用`ALTER USER 'root'@'localhost' IDENTIFIED BY 'xxxxxx';`修改密码

+ 现在推出重新登陆,MySQL已经可以用密码登陆成功了,然后删除本机的PHPStudy.

# 教训
以后做测试一定要在虚拟机搞,简直浪费时间...
