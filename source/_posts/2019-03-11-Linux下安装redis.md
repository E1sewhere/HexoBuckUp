---
title: Linux下安装redis
date: 2019-03-11 11:21:05
updated:
tags: [linux,redis]
description:
keywords:
comments:
image:
categories:
  - 笔记
---
安装redis
<!--more-->

# 环境
Ubuntu 16.04x64

# 安装
直接官网下载: `wget http://download.redis.io/releases/redis-3.0.0.tar.gz`
我下载失败了,直接从网上找的其他包下载的(文件直接拖到Desktop).

解压

```
tar -zxvf redis-3.0.0.tar.gz 
```

进入解压目录

```
cd ./redis-3.0.0
```
编译

```
make
```

编译完成之后，可以看到解压文件redis-3.0.0 中会有对应的src、conf等文件夹，这和windows下安装解压的文件一样，大部分安装包都会有对应的类文件、配置文件和一些命令文件

编译成功后，进入src文件夹

```
cd ./src
```
安装到制定目录

```
make PREFIX=/usr/local/redis install
```

redis.conf是redis的配置文件，redis.conf在redis源码目录。
拷贝配置文件到安装目录下
进入源码目录，里面有一份配置文件 redis.conf，然后将其拷贝到安装路径下

```
cd /usr/local/redis
mkdir conf
cp /home/eva33/Desktop/redis-3.0.0/redis.conf  /usr/local/redis/bin
```

我们看到安装目录下是这样的目录结构

```
eva22@eva22-virtual-machine:/usr/local/redis$ ls ./ bin
./:
bin  conf  ect
```

进入`bin`目录,`bin`目录下结构是这样的

```
eva22@eva22-virtual-machine:/usr/local/redis/bin$ ls
redis-benchmark  redis-check-rdb  redis.conf      redis-server
redis-check-aof  redis-cli        redis-sentinel
```

redis-benchmark   redis性能测试工具
redis-check-aof     AOF文件修复工具
redis-check-rdb     RDB文件修复工具
redis-cli      redis命令行客户端
redis.conf   redis配置文件
redis-sentinal   redis集群管理工具
redis-server  redis服务进程

# 启动

## 前端启动
直接运行`bin/redis-server`将以前端模式启动，前端模式启动的缺点是ssh命令窗口关闭则`redis-server`程序结束，不推荐使用此方法
![](https://e1sewhere.github.io/images/028.png)

## 后端模式启动
修改`redis.conf`配置文件， `daemonize yes` 以后端模式启动

```
vi /usr/local/redis/bin/redis.conf
```
![](https://e1sewhere.github.io/images/029.png)

执行如下命令启动redis：

```
redis-server /usr/local/redis/etc/redis.conf
```
服务端启动成功后，执行`redis-cli`启动Redis 客户端，查看端口号

# 参考
https://www.jianshu.com/p/cc91e55da3e4