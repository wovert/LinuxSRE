# HTTP 协议

> Hyper Text Transfer Protocol, 应用层协议，80/tcp

HTML: Hyper Text Mark Language, 编程语言，超文本标记语言

HTTP 协议的的应用是 WWW

MIME(Multiple Internet Mail Extension) 多用途互联网邮件协议

major/minor: text/html, text/plain, images/jpeg, ...

Web 资源：URL(SCHEME://SERVER:PORT/PATH/TO/SOURCE)

HTTP METHOD: GET/POST/PUT/DELETE//HEAD/TRACE/OPTIONS/...

http 事务：request <-> response

``` request
<method> <URL> <version>
<HEADERS>
...
回车换行
<body>
```

```response
<version> <status> <resason phrase>
<HEADERS>
...
回车换行
<body>
```

## WWW

> World  Wide Web, 万维网

HTTP服务=WWW服务=Web服务

## HTTP 协议版本

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

``` code
/var/www/html;
  images/log.jpg
  http://www.wovert.com/images/logo.jpg
```

Web 服务器的资源路径映射方式

1. docroot
2. alias(路径别名)
3. 虚拟主机的 docroot
4. 用户家目录的 docroot

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

``` dns
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

- URL：Uniform Resouce Locator，统一资源定位符
- https://www.lingyima.com:443/bbs/index.php

## 基本语法

- <scheme>://<user>:<pw>@<host>:<port>/<path>;<params>?<query>#<frag>
- params: 参数
- http://www.lingyima.com/bbs/hello;gender=f
- query: 查询
- http://www.lingyima.com/bbs/item.php?username=tom&title=article
- frag: 手雷

- 相对URL：同站访问站点
- 绝对URL：跨站访问站点

- <schem>://<user>:<passwords>@<host>:<port>/<path>;<params>?<query>#<frag>
- params
  - http://www.lingyima.com/bbs/hello;gender=f
- query
  - http://www.lingyima.com/bbs/item.php?user=tom&title=abc
- frag
  - http://www.lingyima.com/index.html#heaer-2

- http协议 version：
  - http/0.9, http/1.0, http/1.1,http/2.0
  - stateless：无状态 
    - 服务器无法持续追踪访问者来源
    - 解决方案：cookie（追踪同一个用户）

- http事务
  - 请求：request
  - 响应：response

报文的语法格式

``` request报文
<method> <request-URL> <version>
<header>


<entity-body>
```

``` response报文
<version> <status> <reason-phrase>
<headers>

<entity-body>
```

- method：请求方法，标明客户端希望服务器对资源执行的动作; GET,HEAD,POST
- version: HTTP/<majr>.<minor>
- status: 三位数字，如200,301,302,404,502; 描述请求处理过程中发生的情况
- reason-phrase: 状态码所标记的状态的简要描述
- headers: 每个请求或响应报文可包含任意个首部；每个首部都有首部名称，后面跟一个冒号，而后跟上一个可选空格，接着是一个值；
- entity-body: 请求时附加的数据或响应时附加的数据

- method(方法)：
  - GET：从服务器获取一个资源
  - POST: 向服务器发送要处理的数据
  - HEAD: 只从服务器获取文档响应首部
  - PUT: 将请求的主体部分存储在服务器上（危险）
  - DELETE：请求删除服务器上指定的文档
  - TRACE：跟踪请求到大服务器中间经过的代理服务器
  - OPTIONS：请求服务器返回对指定资源支持使用的请求方法

- 协议查看或分析的工具：`tcpdump,tshark,wireshark`

- status(状态码)
  - 1xx: 100-101，额外**信息**提示
  - 2xx: 200-206，响应**成功**的信息
  - 3xx: 300-305，服务器端**重定向**类信息
  - 4xx: 400-415，**客户端错误**信息
  - 5xx: 500-505，**服务器端错误**信息

- 常用状态码：
  - 200: 请求的所有数据通过响应报文的entity-body部分发送；OK
  - 301: 请求的URL指向的资源已经被删除；但在响应报文中通过首部Location指明了资源现在所处的新位置；永久重定向；Moved Permanently
  - 302: 与301相似，但在响应报文中通过Location指明资源现在所处临时新位置；Found
  - 304: 客户端发出了条件式请求，但服务器上的资源未曾发生改变，则通过响应此响应状态码通知客户端；Not Modified
  - 401: 需要输入账号和密码认证方能访问资源；Unauthorized
  - 403: 请求被禁止；Forbidden（用户没有权限）
  - 404: 服务去无法找到客户端请求的资源；Not Found
  - 500: 服务器内部错误；Internal Server Error
  - 502: 代理服务器从后端服务器收到一条伪响应：Bad Gateway

- headers
  - 格式：
    - Name: Value

``` request
Request Headers:
GET / HTTP/1.1
Host: www.qq.com
Connection: keep-alive 是否保持连接
Upgrade-Insecure-Requests: 1 
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.99 Safari/537.36 
Accept: text/html,application/xhtml+xml,application/
xml;q=0.9,image/webp,*/*;q=0.8 
Accept-Encoding: gzip, deflate, sdch 
Accept-Language: zh-CN,zh;q=0.8
Cookie: tvfe_boss_uuid=aead7ae45ac1d686; pac_uid=1_67668283; eas_sid=X1L418a0g0W4z5l2t168w6T2V9; mobileUV=1_158dd38a6b7_391c4; ts_uid=9246952727; ptui_loginuin=67668283; pgv_pvid=6872186886; o_cookie=67668283; ptcz=04ed5113ef85398a5b53ab269f1faa6d8d6d765f31bce6cad37e4383362eaaae; pt2gguin=o0067668283
```

``` response
Response Headers:
HTTP/1.1 200 OK
Server: squid/3.5.20
Date: Fri, 30 Dec 2016 09:36:27 GMT
Content-Type: text/html; charset=GB2312 内容类型
Transfer-Encoding: chunked
Connection: keep-alive
Vary: Accept-Encoding
Expires: Fri, 30 Dec 2016 09:37:27 GMT
Cache-Control: max-age=60
Vary: Accept-Encoding
Content-Encoding: gzip
Vary: Accept-Encoding
X-Cache: HIT from tianjin.qq.com
```

- 首部的分类：
  - 通用首部

  - 请求首部
  - 响应首部

  - 实体首部
  - 扩展首部

- 通用首部：
  - Date: 报文的**创建时间**
  - Connection: **连接状态**，如keep-alive, close
  - Via：显示报文经过的**中间节点**
  - Cache-Control: **控制缓存** http 1.0
  - Pragma: 控制缓存 **http-1.1版本**

- 请求首部：
  - Accept: 通过服务器自己可接受的**媒体类型** */* 任意类型
  - Accept-Charset: 接受的**字符集**
  - Accept-Encoding: 接受**编码格式**，如gzip,deflate,sdch
  - Accept-Language: 接收的**语言**

  - Client-IP: **客户端IP**
  - Host: 请求的**服务器名称和端口号**
  - Referer: 包含当前正在**请求的资源的上一级资源**
  - User-Agent: **客户端代理**

  - 条件式请求首部：
    - Expect: 期望发送什么样的信息
    - If-Modified-Since: 自从指定的时间之后，请求的资源**是否发生过修改**
    - If-Unmodified-Since:自从指定的时间之后，请求的资源**是否发生过没有修改**
    - If-None-Match:本地缓冲中存储的文档的**ETag标签是否**与服务器文档的Etag**不匹配**
    - If-Match:本地缓冲中存储的文档的**ETag标签**是否与服务器文档的Etag**匹配**

  - 安全请求首部：
    - Authorization: 向服务器发送**认证信息**，如账号和密码
    - Cookie：客户端向服务器**发送cookie**
    - Cookie2: **cookie版本**

  - 代理请求服务：
    - Proxy-Authorization: 向**代理服务器认证**

- 响应首部：
  - 信息性：
    - Age: **响应持续时长**
    - Server: 服务器程序**软件名称和版本**

  - 协商首部：其资源有多重表示方法时使用
    - Accept-Range: 服务器可接受的**请求范围类型**
    - Vary: 服务器查看的其他首部列表

  - 安全响应：
    - Set-Cookie: **向客户端设置cookie**
    - Set-Cookie2: 向客户端设置cookie
    - WWW-Authenticate: 来自服务器的对客户端的质询**认证表单**

- 实体首部：
  - Allow: 列出对此**实体可使用的请求方法**
  - Location: 告诉客户端真正的**实体位于何处(重定向)**

  - Content-Encoding: 内容**编码格式**
  - Content-Language: 内容**语言**
  - Content-Length: 主体的**长度**
  - Content-Location: 实体真正所处**位置**
  - Content-Range: 实体**范围**
  - Content-Type: 主体的**对象类型**

  - 缓存相关：
    - ETag: 实体的**扩展标签**
    - Expires: 实体的**过期时间**
    - Last-Modified: **最后一次修改的时间**