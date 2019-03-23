---
title: 我的WafBypass之道 三篇笔记
categories:
  - 笔记
date: 2019-03-18 08:49:43
updated:
tags: [sql注入]
description:
keywords:
comments:
image:
---
先知帖子我的WafBypass之道笔记
<!--more-->
# 我的WafBypass之道(sql)
已在: [sql注入](https://e1sewhere.github.io/2019/02/05/SQL%E6%B3%A8%E5%85%A5/)里总结

# 我的WafBypass之道(upload)
已在: [upload labs 练习](https://e1sewhere.github.io/2019/02/13/upload-labs-%E7%BB%83%E4%B9%A0/)里总结

# 我的WafBypass之道（大杂烩篇）

## Bypass 菜刀连接拦截
多数waf对请求进行检测时由于事先早已纳入了像菜刀这样的样本。通常waf对这块的,检测就是基于样本，所以过于死板

## webshell免杀
讲webshell免杀也就直接写写姿势，一些特性功能、畸形语法、生僻函数比如回调等绕过查杀语法，不断变种、变种、变种。。。
编码解码绕过

## Bypass CDN查找原IP
由于cdn可能覆盖的非常完全，那么可以采用国外多地ping的方式，或者多收集一些
小国家的冷门dns然后nslookup domain.com dnsserver。