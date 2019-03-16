---
title: Android Studio安装踩坑
date: 2018-09-07 19:31:32
updated:
tags: [androidStudio]
description:
keywords:
comments:
image:
---
耗费将近两个小时把AS安装完毕并且运行成功了第一个HelloWorld.遇到了一些问题.此处做一个笔记.
<!--more-->

# 机器环境 #
+ 操作系统:win10
+ 电脑开启全局代理
+ 安装包为x64:android-studio-ide-173.4907809-windows

# 安装教程 #
直接参看这篇博客:https://www.cnblogs.com/xiadewang/p/7820377.html

## 安装注意事项 ##
确保能够科学上网,可以自己折腾免费的方法,也可以去购买服务,最靠谱的是自己搭建.我也是在学习过程中才发现不会科学上网是很麻烦的事情.

# 遇到的问题 #

## 完整删除AS ##
*首次安装时由于某些玄学问题,我的安装失败了,需要重装.*
使用目录自带卸载工具,或者使用IObit Uninstaller(推荐)卸载.
然后删除用户目录下含有androidstudio的文件夹,通常是`.`开头的隐藏文件,这个文件夹是AS的用户配置信息,在你需要重置设置时也可说通过删除它来达到.

## Gradle下载慢 ##
*虽然已经科学上网但是我的Gradle下载速度依然奇慢无比,低于10k的速度,直接在官网下载包在多线程的支持下能够达到1m*

首先,AS新建一个项目,AS会开始下载Gradle,等一会,打开如下目录`C:\Users\xxx\.gradle\wrapper\dists\gradle-4.4-all\xxxxxxxxxxxxxxx`
这里的`xxxxxxxxxxxx`是AS创建Gradle下载目录的时候自动创建的.
打开文件夹后强制关闭AS,删除这个目录下的所有文件(如果有).
你可以看到这个目录的上一级已经标明了你需要的Gradle版本,我的是`gradle-4.4-all`,这时到[Gradle下载地址](http://services.gradle.org/distributions/)下载对应`压缩包`
将`压缩包`直接放到`xxxxxxxxxxxx`
重新启动AS,创建项目,成功了.

## ADV模拟器运行报错 ##
我的报错信息为
```
18:21    Emulator: emulator: ERROR: x86 emulation currently requires hardware acceleration!

18:21    Emulator: Process finished with exit code 1
```
可以作为参考

google后原因似乎为Intel HAXM没有开启,实际上Android SDK 已经集成了这个软件，目录结构类似`C:\Users\xxx\AppData\Local\Android\Sdk\extras\intel\Hardware_Accelerated_Execution_Manager`
点击目录下的.exe可执行程序安装,如果安装报错需要在Bios里把 `Virtualization-Inter(R) Virtualization Technology `设成Enabled,具体方法google之.(我的机器没有这个选项,也没有报错很奇怪)
Bios设置好后就可以继续安装了
安装完成,再次运行模拟器,成功了


