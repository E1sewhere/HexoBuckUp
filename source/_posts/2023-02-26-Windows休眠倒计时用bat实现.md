---
title: Windows休眠倒计时用bat实现
categories:
  - 默认
date: 2023-02-26 21:56:22
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
有休眠需求，本来以为和shutdown一样直接简单命令就行了，可是要调用可执行程序，命令有点长干脆写个bat算了，bat命令如下：

title 定时休眠
@ECHO OFF&SETLOCAL ENABLEDELAYEDEXPANSION
SET /p t=请输入休眠时间（单位秒,只输入数字）：
SET /a s=t+1
FOR /l %%i in (1,1,!s!) do (
    SET /a s-=1
    ping -n 2 127.1>nul
    title 休眠倒计时： !s! 需要终止请直接关闭控制台
)

START "" rundll32.exe powrprof.dll,SetSuspendState 0,1,0
直接cmd里执行或者创建一个bat后缀文件复制上述内容即可。其中有中文回显注意编码否则会乱码。
既然写了那也付一个关机倒计时吧，同理可得

title 定时关机
@ECHO OFF&SETLOCAL ENABLEDELAYEDEXPANSION
SET /p t=请输入关机时间（单位秒,只输入数字）：
SET /a s=t+1
FOR /l %%i in (1,1,!s!) do (
    SET /a s-=1
    ping -n 2 127.1>nul
    title 关机倒计时： !s! 需要终止请直接关闭控制台
)
shutdown -s -t 1