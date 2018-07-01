# HTTP 协议

> Hyper Text Transfer Protocol, 应用层协议，80/tcp

HTML: Hyper Text Mark Language, 编程语言，超文本标记语言

## 协议版本

- http/0.9: 原型版本，功能简陋
- http/1.0: cache, MIME, method
  - MIME: Multipurpose Internet Mail Extension
  - method: GET, POST, HEAD, PUT, DELETE, TRACE, OPTIONS
- http/1.1: 增强了缓存功能
  - SPDY
- http/2.0:
  - rfc 文档

## http 工作模式

- http 请求报文: http request
- http 响应报文: http response

一次 http 事务: 请求 <-> 响应

- Web 资源：web resource
  - 静态资源(无需服务器端做出额外处理)：.jpg, .png, .gif, .html, .txt, .js, .css, .mp3, .avi
  - 动态资源(服务端需要通过执行程序做出处理，发送给客户端的是程序的运行结果)：.php, .jsp

  - 注意：一个页面中展示的资源可能有多个；每个资源都需要单独请求；
  - 资源的标识机制：URL
    - Uniform Resource Locator: 用于描述服务器某特定资源的位置
      - 例如：http://www.wovert.cm/index.html
        - Schema://Server[:Port]/PATH/TO/SOME_RESOURCE

**注意**：通过日志文件分析用户行为

## 一次完整的 htp 请求处理过程

1. 建立或处理连接：接受请求或拒绝请求；
2. 接受请求：接受来自于网络上的主机请求报文中对某特定资源的一次请求的过程；
3. 处理请求：对请求报文进行解析，获取客户端请求的资源及请求方法等相关系信息；
4. 访问资源：获取请求报文中请求的资源；
5. 构建响应报文；
6. 发送响应报文；
7. 记录日志；

## 接受请求的模型

- 并发访问响应模型
  - 单进程I/O模型：启动一个进程处理用户请求；这意味着，一次只能处理一个请求，多个请求被串行响应；
  - 多进程I/O模型：并行启动多个进程，每个进程响应一个请求；
    - 一个进程占用平均 5MB，创建，上下文切换，销毁等操作也占用内存
    - 等待3秒 损失70%用户，超过10秒损失95%用户，第二次不会来访问
    - 扩展：向上扩展(硬件)，向外扩展(多个服务器)
  - 复用的I/O结构：一个进程响应n个请求
    - 多线程模式：一个进程生成n个线程，一个线程处理一个请求；
    - 事件驱动(event-driver): 一个进程响应n个请求
  - 复用的多进程I/O结构：启动多个(m)个进程，每个进程生成(n)个线程；
    - 响应的请求的数量：m*n

## 处理请求：分析请求报文的 http 请求报文首部

- http 协议
  - http 请求报文
  - http 响应报文

- 请求报文首部的格式：
  - <method><URL><VERSION>
  - HEADERS:(name:value)
  - <request body>

## 访问资源：获取请求报文中的资源

- web 服务器，即存放了 web 资源的主机，负责向请求者提供对方请求的静态资源，或动态资源运行生成的结果；这些资源通常应该放置于本地文件系统某路径下；此路径称为 `DocRoot`;

```
/var/www/html;
  images/log.jpg
  http://www.wovert.com/images/logo.jpg


Web 服务器的资源路径映射方式

1. docroot
2. alias(路径别名)
3. 虚拟主机的 docroot
4. 用户家目录的 docroot
```

## http 请求处理中的连接模式

- 保持连接（长连接）：keep-alive（分手由服务器来连接断开）
  - 时间
  - 数量：请求数量
- 非保持连接（短连接）：每个进程都需要进行3次握手，4次断开

## Http 服务器程序

- 静态服务器
  - httpd(apache)
  - nginx(俄国人研发)
  - lighttpd(德国人研发)

- 应用程序服务器
  - IIS：.Net
  - tomcat: .jsp

- www.netcraft.com

- 35% 自然垄断

## 用户访问网站基本流程

1. 用户使用客户端浏览器里输入网站地址(https://lingyima.com)回车后，用户系统首先查找系统本地的DNS缓存及hosts文件信息，确实是否存在该域名对应的IP解析记录(Linux:/etc/hosts)，如果有直接获取IP地址，然后去访问这个IP地址对应的域名的服务器。一般第一次请求时，DNS缓存是没有解析记录的，而 hosts 文件在本地测试时使用

2. 本地没有域名对应的解析记录，系统会版浏览器解析请求发送给客户端本地设置的DNS服务器地址（LDNS, Local DNS）解析，如果LDNS服务器有对应的解析记录一会直接返回IP地址给客户端。若没有，则LDNS会负责继续请求其他的DNS服务器

3. LDNS从DNS系统的(".")根开始请求对域名的解析，并这对各个层级的 DNS 服务器系统进行一系列的查找，最终查找到域名对应的授权 DNS 服务器，而这个授权 DNS 服务器正式企业购买域名时用于管理域名解析的服务器。也可以在别的 DNS域名解析服务器上设置（国内：dnspod.cn）

4. 域名授权的 DNS 服务器会把域名对应的最终IP解析记录发送LDNS

5. LDNS 把来自授权 DNS 服务器域名对应的IP地址解析记录发给客户端浏览器，并把该域名和IP的对应解析缓存起来，一便下次更快的返回相同解析请求的记录，这些缓存记录在指定的时间（DNS TTL值控制）内不会过期。

6. 客户端浏览器获取域名对应IP之后，请求获取IP地址对应的网站服务器。本机打包本机IP/MAC地址和目标IP地址，通过局域网发送ARP请求包获取目标IP地址对应的MAC地址，交换机或路由器收到ARP请求之后分发给局域网每个主机，每个主机授权ARP请求检查目标主机IP与本地IP地址是否相同，相同则响应ARP响应包(目标:ip/mac, 源：ip/mac)给发送请求ARP请求主机，如果没有相同则丢弃包。
- 主机收到ARP响应之后把目标IP/MAC地址缓存起来，以便下次使用(TTL值控制之内有效)；主机发送TCP请求三次握手连接，连接成功后目标主机响应给客户端请求资源

- 主机没有收到ARP响应结果，那么ARP请求发送给网关，由网关(一般是路由器)再次互联网发出ARP广播请求得到目标IP地址所对应的MAC，互联网上各个路由层层发送ARP请求响应目标IP地址的MAC。

- 主机收到MAC地址之后，打包TCP请求三次握手之后，目标服务器响应给用户所请求的地址资源。

- Windows 客户端本地缓存的DNS解析记录：`>ipconfig /displaynds`

- Windows 客户端清除本地缓存的DNS解析记录 ：`>ipconfig /flushdns`

- Windows hosts 域名解析记录路径文件：`C:\Windows\System32\drivers\etc\hosts`

## DNS 系统解析基本流程

> Domain Name System, 域名解析为对应IP地址

### DNS解析类型

- Address Recored(A 记录)：域名到IP的解析过程
- DNAME(别名记录)：一个域名解析到另一个域名，常用于 CDN 加速服务商应用
- MX（邮件记录）：搭建邮件服务时使用
- PTR：反向解析，IP地址解析为对应的域名（常用于邮件服务等业务） 

### DNS 系统架构

> 类似于一棵倒挂着的树，它的顶点时"."
```
.
com/gov/org/net/cn/edu/info
cn
  com/gov/org/net
com
   lingyima
    blog
      cg
```

### DNS 解析流程

1. 用户在浏览器上输入网址后，系统首先查找系统本地的DNS缓存及 host 文件信息，确定是否存在域名所对应的IP解析记录，如果有直接获取IP地址，然后去访问这个IP地址所对应的域名所配置在的服务器。第一次请求时，DNS缓存是没有解析记录的，host 文件是内部历史测试使用

2. 浏览器的解析请求发送给客户端本地设置的DNS服务器地址LDNS解析，LDNS有对应的解析记录就会直接返回IP地址给客户端；如果没有，则LDNS负责继续请求其他的DNS服务器

3. LDNS从DNS系统的(".")根开始请求对域名的解析，根DNS服务器在全球一共有13台，根服务器下面没有域名解析记录，但是在根下面有域名对应的顶级域 .com 的解析记录，因此，根会把 .com 赌赢的DNS 服务器地址返回给LDNS.

4. LDNS 获取 .com 对应的DNS服务器地址后，就去 .com 服务器请求域名的解析，而 .com服务器下面也没有域名对应的解析记录，但是有 lingyima.com 域名的解析记录，因此, .com 服务器把 lingyima.com 对应的 DNS服务器地址返回给 LDNS

5. LDNS 按以上方式获取到域名所对应的IP解析记录，并IP地址返回给LDNS

6. LDNS 会在本地把域名和IP的对应解析记录缓存起来，以便下次更快的返回相同解析请求的记录。

### Linux dig命令

``` shell
# dig +trace www.lingyima.com
# yum install bind-utils
```