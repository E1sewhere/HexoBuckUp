---
title: '''虚第一次拟化物理机 FAILED Unable to find the system volume, reconfiguration is not'
categories:
  - 默认
date: 2023-02-26 22:03:09
updated:
top:
tags:
description:
keywords:
comments:
image:
---
无格式迁移
<!--more-->
之前一直用的WTG炸了，实在没有心情再搞一个，没有做好备份实在是后悔。 想起来VMware似乎直接有一个虚拟化物理的功能，遂尝试把本地的win10(x64 190x版本)给虚拟化了。

使用的VMware vCenter CS 6.x的版本，没有中文，靠着小学的英语水平操作了一波。由于原硬盘很大，我直接把c盘和数据盘选择最小大小。 一个小时后虚拟化完成了，看看task摘要：

%98 FAILED: Unable to find the system volume, reconfiguration is not possible.
失败了 先把已经完成的vmx等文件备份一下,开始Google,网页很少,就几个英文VM的论坛有相关信息,不过题主出的问题似乎和我差不多.靠着谷歌翻译和猜,把能做的操作都做了一遍,不知道原理反正做就是了.

启动一下,win10检测出启动问题,然后运行自带的修复程序.好了开机成功... 怀着疑问,我把之前没有操作过的虚拟机文件直接启动,win10修复后依然成功开机,也就是说前面一通操作完全没有必要,不得不说win10还是挺nb的.

开机后显卡驱动有问题,硬盘也搞得太小了.其他都还好,把更新禁止了,应该可以日用.