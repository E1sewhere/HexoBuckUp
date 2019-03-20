---
title: HEXO 使用Github作为图床
date: 2018-09-07 22:53:16
updated: [hexo,博客]
tags:
description:
keywords:
comments:
image:
categories:
  - 解决方法
---
想把hexo的文章同步到博客园,但是文章的图片使用本地链接,在博客园就不能使用了,使用图床时发现.国内的图床都需要身份验证,不是很喜欢这样,所以暂时就使用github的page直接作为图床吧.
<!--more-->
直接把图片链接改为`https://yourname.github.io/images/xxx.png`
然后图片放在source下的images文件夹内(便于管理)
就这样.
这样做缺点很多,完全没有专业的图床好.
需要科学上网才能访问,而且没有push前本地调试也是看不见图片的
空间也很少
等到有时间了,给hexo装个压缩插件,应该能够+1s.