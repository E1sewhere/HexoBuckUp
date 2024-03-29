---
title: google hack 笔记
categories:
  - 笔记
date: 2019-03-29 15:30:55
updated:
tags: 
description:
keywords:
comments:
image:
---
关于google hack得笔记 从有道笔记转移
<!--more-->

# 基础关键字组合

- `""` 完全匹配(严格),双引号内的字符串不拆分.
- `+` 指定一个一定存在的关键词
- `-` 指定一个一定不存在的关键词
- `|` 或,满足其中一个关键词就可以.
- `AND` 所有关键词都必须满足(可以不像双引号一样必须连在一起)

# Site:
搜索指定域名下的结果

```
site:domain

site:baidu.com
```

# inurl:
搜索结果的url中一定有指定的内容

```
inurl:str

inurl:admin/login.php
```

# intitle:
搜索标题为指定内容的结果

```
intitle:str

intitle:后台管理
```

# cache:
缓存搜索,类似百度的快照可以可以搜索到google记录的网页历史快照

```
cache:url
```

# 组合
这个语法都可以自由自合
比如
搜索site为baidu.com 包含"有限公司"的结果

```
site:baidu.com "有限公司"
```

搜索site为baidu.com 标题中包含"有限公司"的结果

```
site:baidu.com intitle:有限公司
```


# 实用搜例子

- 查找目标管理员
`site:domain "发布人"`
可以再网站中搜索`发布人`这个关键字,后面跟随的信息就是网站发布小心的用户,而这个用户很可能就是管理员
- 查找目标脚本语言
`site:domain php`
可以在网站中搜索类似`php`这样的脚本语言扩展名,对于某些伪静态网站(比如页面全是html的),如果搜到某种扩展名基本可以判断这个网站使用的脚本语言.
- 查找弱点站
`inurl:ewebeditor admin`
可以用来批量查找存在某些弱点的站点.比如上面这个就是查找ewbeditor编辑器的后台页面,这种后台通常存在弱口令.
- 寻找c段主机
`site:49.122.21.*`