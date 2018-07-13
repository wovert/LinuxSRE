# httpd

## httpd 的安装和使用

ASF：Apache Software Foundation

Apache Project: httpd/tomcat/hadoop/

httpd: apache

a patchy(补丁) server = apache

## httpd 特性

- 高度模块化：core + modules
- DSO: Dynamic Shared Object
- MPM: Multipath Processing Modules 多路处理模块
  - prefork: 多进程模型，每个进程响应一个请求；
    - 一个主进程：负责生成子进程及回收子继承；负责创建套接字；负责接收请求，并将其派发给某子进程进行处理；
    - n个子进程：每个子进程处理一个请求；
    - 工作模型：会预生成几个空闲进程，随时等待用于响应用户请求；最大空闲和最小空闲；
  - worker：多进程多线程模型，每个线程处理一个用户请求；
    - 一个主进程：负责生成子进程；负责创建套接字；负责接收请求，并将其派发给某子进程进行处理；
    - 多个子进程：每个子进程负责生成多个线程；
    - 每个线程：负责响应用户请求；
    - 并发响应数量：m*n
      - m: 子进程数量
      - n: 每个子进程所能创建的最大线程数量；
  - event：事件驱动模型，多进程模型，每个进程响应多个请求；
    - 一个主进程：负责生成子进程；负责创建套接字；负责接收请求，并将其派发给某子进程进行处理；
    - 子进程：基于事件驱动机制直接响应多个请求；
    - http-2.2: 测试使用模型
    - httpd-2.4: event 可生产环境使用
  
## httpd 的程序版本

- httpd  1.3: 官方已经停止维护
- httpd 2.0 主流版本
- httpd 2.2 主流版本 （CentOS 6 默认版本）
- httpd 2.4 目前最新稳定版 （CentOS 7 默认版本）

## httpd 功能特性

- CGI: Common Gateway Interface
- 虚拟主机：IP,PORT,FQDN
- 反向代理
- 负载均衡
- 路径别名
- 丰富的用户认证机制
  - basic
  - digest
- 支持第三方模块

## httpd 安装

- rpm 包安装：CentOS 发行版中直接提供
- 编译安装：定制新功能，或其他原因；

- CentOS 6: httpd-2.2
  - 程序环境：
    - 配置文件：
      - `/etc/httpd/conf/httpd.conf`
      - `/etc/httpd/conf.d/*.conf`
    - 服务脚本
      - `/etc/rc.d/init.d/httpd`
      - 脚本配置文件：`/etc/sysconfig/httpd`
    - 主程序文件：
      - `/usr/sbin/httpd`
      - `/usr/sbin/httpd.event`
      - `/usr/sbin/httpd.worker`
    - 日志文件
      - `/var/log/httpd`
        - `access.log` 访问日志
        - `error_log` 错误日志
    - 站点文档：
      - `/var/www/html`
    - 模块文件路径：
      - `/usr/lib64/httpd/modules`

    - 服务控制和启动
      - 开启自启动：`# chkconfig httpd on|off`
      - `# service {start|stop|restart|status|configtest|reload} httpd`

``` shell
# rpm -ql httpd
# service httpd start

访问 http://172.16.1.1

# cd /etc/httpd/conf.d/
# ls
# mv welcome.conf welcome.conf.bak
# service httpd reload
# vim /var/www/html/test.html
  <h1>Test Site</h1>

访问 http://172.16.1.1

```

- CentOS 7: httpd-2.4
  - 安装 httpd: `# yum -y install httpd && rpm -ql httpd`
  - 程序环境
    - 配置文件
      - 主配置文件: `/etc/httpd/conf/httpd.conf`
      - 其他配置文件: `/etc/httpd/conf.d/*.conf`
      - 模块相关的配置文件：`/etc/httpd/conf.modules.d/*.conf`
    - systemd unit file:
      - `/usr/lib/systemd/system/httpd.service`
    - 主程序文件：
      - `/usr/sbin/httpd`
      - httpd-2.4 支持 MPM 的动态切换
    - 日志文件
      - `/var/log/httpd`
        - `access.log` 访问日志
        - `error_log` 错误日志
    - 站点文档：
      - `/var/www/html`
    - 模块文件路径：
      - `/usr/lib64/httpd/modules`

    - 服务控制
      - 开启自启动：`# systemctl enable|disable httpd.service`
      - 服务命令：`# systemctl {start|stop|restart|status} httpd.service`

## httpd-2.2 的常用配置

``` shell
# systemctl start httpd.service
# systemctl status httpd.service
```

### 主配置文件

> `/etc/httpd/conf/httpd.conf`

`# grep -i "Section" httpd.conf` 查看主配置分段信息

- Section 1: Global Enviroment 全局配置
- Section 2: 'Main' Server configuration 中心主机配置段
- Section 3: Virtual Hosts 虚拟主机配置段

### 配置格式

> directive value

- directive: 不区分字符大小写
- value: 为路径时，是否区分字符大小写，取决于文件系统

### 常用格式

`~]# cd /etc/httpd/conf/ && cp -v httpd.conf{,.backup}` 备份主配置文件

#### 1. 修改监听的 IP 和 PORT: 

> `Listen [IP:]PORT`

- 省略 IP 表示为 0.0.0.0 (本机正常使用的所有 IP)
- `Listen` 指令可重复出现多次，监听多个端口
  - `Listen 80`
  - `Listen 8080`
- 修改监听 `socket`，重启服务进程方可生效

#### 2. 持久连接

> Persistent Connection: tcp 连接建立后，每个资源获取完成后不全断开连接，而是继续等待其他资源请求的进行

- 如何断开连接？
  - 数量限制
  - 时间限制

- 副作用：对并发访问量较大的服务器，长连接机制会使得后续某些请求无法得到正常响应

- 折衷：使用较短的持久连接时长，以及较少的请求数量
  - `KeepAlive On|Off` 默认是 Off
  - `KeepAliveTimeout 15` 长连接持续时间
  - `MaxKeepAliveRequests	100` 最多请求资源数量，超出这个数量限制自动断开连接

- 模拟请求资源测试长连接：
``` shell
telnet 连接请求资源
# telnet 172.16.100.6 80
Trying 172.16.100.6...
Connected to 172.16.100.6.
Escape character is '^]'.
GET /test.html HTTP/1.1
Host: 172.16.100.6
Enter
Enter

响应请求资源
HTTP/1.1 200 OK
Date: xxx
Server: Apache/2.2.xx(CentOS)
Last-Modified: xxx
ETag: "xxx"
Accept-Range: bytes
Content-Length: 19
Connection: close
Content-Type: text/html; charset=UTF-8

<h1>Test</h1>
Connection closed by foreigh host.

长连接
# vim httpd.conf
KeepAlive On
KeepAliveTimeout 15
MaxKeepAliveRequests: 100

重启服务
# service httpd reload

再一次 telnet 连接请求资源
# telnet 172.16.100.6 80
Trying 172.16.100.6...
Connected to 172.16.100.6.
Escape character is '^]'.
GET /test.html HTTP/1.1
Host: 172.16.100.6
Enter
Enter
```

- 在限定时长内最多可以请求多少个连接，不包括第一个连接，总共可以连接100+1

- 客户端模拟请求：时间过期和最大请求数
```
# yum -y install telent
# telnet 192.168.1.61 80
GET /test.html HTTP/1.1
Host: 192.168.1.61
```

#### 3. MPM

> http-2.2不支持同时编译多个 MPM 模块，所以只能编译选定要使用的哪个

- CentOS 6 的 rpm 包为此专门提供了三个应用程序文件
  - httpd(prefork)
  - httpd.worker
  - httpd.event

- 分别用于实现对不同的MPM机制的支持；确认现在使用的哪个程序文件的方法：
  - `# ps aux | grep httpd`
  - 默认使用的 `/usr/sbin/httpd`，其为`prefork`的MPM模块

- 查看 httpd 程序的模块列表
  - 查看静态编译的模块：`# /usr/sbin/httpd -l`
    - core.c 核心模块
    - prefork.c prefork模块
    - http_core.c http核心模块
    - mod_so.c 动态加载模块

  - 查看静态编译及动态编译的模块：`# /usr/sbin/httpd -M`

- 更换使用httpd程序，以支持其他 MPM 机制
``` shell
# service httpd stop
# vim /etc/sysconfig/httpd 默认使用prefork
HTTPD=/usr/sbin/httpd.{worker|event}
# service restart stop
```

- 脚本配置文件：
``` shell
# vim /tmp/useradd.conf`
username=myuser`

# vim useradd.sh`
#!/bin/bash`
[ -f /tmp/useradd.conf ] && source /tmp/useradd.conf
username=${username:-testuser}
useradd $username # myser
```


##### MPM配置

- prefork配置
``` prefork.conf
<IfModule prefork.c>
StartServers 8 服务进程启动时子进程数量
MinSpareServers 5 最少空闲进程数
MaxSpareServers 20 最多空闲进程数
ServerLimit 256 允许在线最大进程数量
MaxClients 256 最大响应客户端请求数量
MaxRequestsPerChild 4000 每个进程最多处理多少个请求，达到4000个销毁进程，创建新的子进程
</IfModule>
```

1秒处理5请求，256进程请求一秒内处理多少个请求，256x5=1280
一天38400x1280 = 1亿，一个页面100个资源= 1亿/100=100万PV。每个请求10KB, 1280个请求， 1280x10KB=12800KB/1024=12MBx8=96Mbps，没有算报文首部和其他开销数据，所以带宽 100Mbps 可能不够。

- 以峰值作为标准性能指标
- PV: Page View 页面浏览量(css+js+html+mp3+mp4+...)
- UV: User View 用户浏览量

- worker配置
``` worker.conf
<IfModule worker.c>
StartServers 4 服务启动时子进程数量
MaxClients 300 最大响应客户端请求数量
MinSpareThreads 25 最少空闲线程数
MaxSpareThreads 75 最大空闲线程数
ThreadsPerChild 25 每个进程生成多少个线程
MaxRequestsPerChild 0 (0：无限)
</IfModule>
```

问题：子进程4 x 每个进程生成25个线程 VS 最大空闲线程数 75,4X25 vs 75??? 脑残设计

```
A shell 运行
# vim /etc/sysconfig/httpd
  HTTPD=/usr/sbin/httpd.worker
# ps aux | grep httpd
# watch -n.5 'ps aux | grep httpd'

B shell 运行
# service htptd restart

发现开始生成4个进程，之后删除一个进程
```

#### 4. DSO

> Dynamic Share Object, 动态共享对象

配置指令实现模块加载 : `LoadModule <mod_name> <mod_path>`

模块文件路径可使用相对路径：相对于 `ServerRoot` (默认/etc/httpd)

``` shell
# ls -l /etc/httpd/
  logs -> ../../var/log/httpd
  modules -> ../../usr/lib64/httpd/modules
  run -> ../../var/run/htpd
```

#### 5. 定义 Main Server（中心主机）的文档页面路径

- 提供一个站点方式：
  - 可以在 mainServer 定义(只有一个站点时使用)
  - 可以在虚拟主机定义一个站点（多个站点时使用）

- 文档路径映射：
  - `DocumentRoot` 执向的路径为 URL 路径的起始位置
  - 其相当于**站点 URL 的根路径**
  - (FileSystem)/var/www/html/index.html => (URL)/index.html

- **http-2.4**版本的 `DocumentRoot和访问控制列表`同时设置才可生效

``` shell
# mkdir -pv /web/host1
# vim /web/host1/index.html
  <h1>New Location</h1>

# vim /etc/httpd/http.conf
  DocumentRoot "/web/host1"
  # 站点访问控制
  <Directory>
  </Directory>
# service httpd reload
在浏览器访问 172.16.100.6
```

#### 6. 站点访问控制常见机制

> 基于两种机制指明对哪些资源进行何种访问控制

1. 文件系统路径

所有目录及其子目录
``` config
<Directory "">
...
</Directory>
```

单个文件访问控制
``` config
<File "">
...
</File>
```

类文件访问控制
```
<FileMatch "PATTERN">
...
</FileMatch>
```

2. URL路径
```
<Location "">
...
</Location>
```

```
<LocationMatch "">
...
</LocationMatch>
```

---
##### <Directory> 中"基于源地址"实现访问控制

1. `Options`: 后跟 1 个或多个以空白字符分隔的选项列表
- `Indexes`：指明的 URL 路径下不存在与定义的主页面资源相符的资源文件时，返回索引列表给用户；推荐不使用
- `FollowSymLinks`：仅允许跟踪符号链接文件指向的源文件内容；推荐不使用
``` shell
# cd /web/host1
# cd
# ln -sv /etc/fstab /web/host1/test2.html
# ls -l /web/host1/
# vim httpd.conf
  Options FollowSymLinks
# service httpd reload
访问 http://172.16.100.1/test2.html，显示 /etc/fstab文件内容  

```

- `SymLinksifOwnerMatch`：与目标文件属主属组相同时访问源文件内容
- `ExecCGI`：通用网管 CGI
- `MultiViews`：内容协商，消耗资源
- `None`：不使用
- `All`：所有都使用

---

2. `AllowOverride None`
- 与访问控制相关的哪些指令可以放在`.htaccess`文件（每个目录下都可以有一个）中；
- `All` 影响性能
- `None` 不能存放在.htaccess

---

3. Order allow,deny
- `order`：定义生效次序；写在后面的表示默认法则
- `order allow,deny`：白名单
- `deny,allow`：黑名单

- Allow from 来源地址, Deny from 来源地址
  - 来源地址:
    - IP
    - NetAddr : 网段地址
      - 172.16
      - 172.16.0.0
      - 172.16.0.0/16
      - 172.16.0.0/255.255.0.0

- 除了 172.16.100.6 之外 172.16 网段访问

``` config
Order,allow,deny
Deny from 172.16.100.6
Allow from 172.16
```

---

4. 定义路径别名

格式：`Alias /URL/ "/PATH/TO/SOMEDIR/"`

- `DocumentRoot "/www/htdocs"`
  - `http://IP/download/bash-4.4.2-3.el6.x86_64.rpm`
    - `/www/htdocs/download/bash-4.4.2-3.el6.x86_64.rpm`

- `Alias /download/ "/rpms/pub/"`
  - `http://IP/download/bash-4.4.2-3.el6.x86_64.rpm`
    -`/rpms/pub/bash-4.4.2-3.el6.x86_64.rpm`

- `http://IP/images/logo.png`
  - `/www/htdocs/images/logo.png`

#### 7. 定义站点主页面

> `DirectoryIndex` index.html index.html.var

#### 8. 设定默认字符集

> `AddDefaultCharset UTF-8`

- 中文字符集：GBK, GB2312, GB18030

#### 9.日志设定

> 日志类型：访问日志和错误日志


**错误日志**：`ErrorLog` 指令（进程运行错误、用户访问错误页面）
``` log
ErrorLog logs/error_log (logs 相对于ServerRoot => /etc/httpd)
LogLevel warn 日志级别
  Possible values include: debug(所有信息), info(信息), notice(注意), warn(警告), error(错误), crit(严重错误), alert,emerg(紧急错误)
```

**访问日志**：`CustomLog` 指令（用户访问页面）
``` log
组合日志格式
LogFormat %h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" combined

访问日志指定
CustomLog logs/access_log combined
```

日志记录格式：`LogFormat "" 格式名称`

[LogFormat format strings](http://httpd.apache.org/docs/2.2/mod/mod_log_config.html#formats)

- `LogFormat %h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" combined`

- **%h** : **客户端IP地址**
- **%l** : 远程登入用户名(remote user), 通常为一个减号（"-"）
- **%u** : remote user (from auth; may be bogus if return status(%s) is 401)认证名；非为登录访问时，其为一个减号；
- **%t** ：服务器收到**请求时的时间**
- **%r** ： First line of request，**请求报文的首行**; **METHOD /URL HTTP/版本**
- **%>s** ：**响应的状态码**
- **%b** ：**响应报文的大小**，单位是字节；不包括响应报文的 HTTP 首部
- **%{Referer}i** ：请求报文中首部**referer的值**；即从哪个页面中的超链接跳转至当前页面的(i表示特定首部的值)
- **%{User-Agent}i** ：请求报文中首部 User-Agent的值；发出**请求的应用程序**

#### 10. 基于用户的访问控制
- 认证方式：
  - 表单认证(form+db)
  - http 协议认证(http)

1.认证质询：
  - WWW-Authenticate：响应码为 401，拒绝客户端请求，并说明要求客户端提供账号和密码

2.认证：
  - Authorization：客户端用户填入账号和密码后再次发送请求报文；认证通过时，则服务器发送响应的资源；
  - 认证方式有两种：
    - basic : 明文
    - digest : 信息摘要（很多浏览器可能不支持）

3.安全域：需要用户认证后方能访问的路径；应该通过名称对其进行标识，以便于告知用户认证的原因；

- 用户的账号和密码存放于何处？
  - 虚拟账号：仅用于访问某服务时用到的认证标识

  - 存储：
    - 文本文件
    - SQL数据库
    - ldap目录存储

##### basic认证配置示例：

1. 定义安全域
```
<Directory "/web/host1/admin">
  Options None
  AllowOverride	None
  AuthType Basic
  AuthName "Please input your admin name and password."
  AuthUserFile "/etc/httpd/conf/.htpasswd"
  Require user tom jerry
</Directory>
```
- 允许账号文件中的所有用户登录访问：`Require valid-user`

2. 提供账号和密码存储（文本文件）

使用专用命令完成此类文件的创建及用户管理

``` shell
# htpasswd [opitons] /PATH/TO/HTTPD_PASSWD_FILE username
-c：create a new file **自动创建**此处指定的文件，因此，仅应该在此文件不存在时使用；
-m：md5 加密
-s：SHA 加密
-D：删除指定用户
```

``` shell
# htpasswd -h
# htpasswd -c -m /etc/httpd/conf/.htpasswd tom
# htpasswd -m /etc/httpd/conf/.htpasswd jerry
# htpasswd -m /etc/httpd/conf/.htpasswd obama
```

3. 测试配置文件是否有语法错误
``` shell
# httpd -t (CentOS 7)
# service httpd configtest (CentOS 6)
# service httpd reload` 注意一定要先检查语法错误
```

##### 基于组账号进行认证：
1. 定义安全域
``` config
<Directory "/web/host1/admin">
  Options None
  AllowOverride	None
  AuthType Basic
  AuthName "Please input your admin name and password."
  AuthUserFile "/etc/httpd/conf/.htpasswd"
  AuthGroupFile "/etc/httpd/conf/.htgroup"
  Require group mygrp mygrp2
</Directory>
```

3. 创建用户账号和组账号文件
- `vim /etc/httpd/conf/.htgroup`
  - mygrp: obama black eric

- 组文件：每一行定义一个组
  - GRP_NAME:username1 usernam2 ...

#### 11.虚拟主机
- 站点标识：socket
  - IP相同，但端口不同（易于实现，并不实用）
  - IP不同，但端口均为默认端口
  - FQDN不同
    - 请求报文首部
    - Host:www.lingyima.com （根据Host判断实用哪个虚拟主机）

- 有三种实现方案：
  - 基于IP：
    - 为每个虚拟主机准备至少一个IP地址
  - 基于PORT:
    - 为每个虚拟主机使用至少一个独立的PORT
  - 基于FQDN：
    - 为每个虚拟主机使用至少一个FQDN

- 注意：一般**虚拟主机不要与中心主机混用**；因此，要使用虚拟主机，得先禁用main主机；
禁用方法：注释中心主机的**DocumentRoot指令**即可；

- 虚拟主机的配置方法：
``` config
<VirtualHost IP:PORT>
  ServerName FQDN
  DocumentRoot ""
</VirtualHost>
```

- 其他可用指令：
``` shell
ServerAlias：虚拟主机的别名;可多次使用`
ErrorLog
CustomLog
```

```
<Directory "">
...
</Directory>
Alias
```

```
# ifconfig eth0:0 172.168.6.0/16
# ifconfig eth0:1 172.168.6.1/16
# ifconfig eth0:2 172.168.6.2/16
```

- 基于IP的虚拟主机示例：
```
<VirtualHost 172.168.6.0:80>
  ServerName www.a.com
  DocumentRoot "/www/a.com/html"
</VirtualHost>
```

```
<VirtualHost 172.168.6.1:80>
  ServerName www.b.net
  DocumentRoot "/www/b.net/html"
</VirtualHost>
```

```
<VirtualHost 172.168.6.2:80>
  ServerName www.c.org
  DocumentRoot "/www/c.org/html"
</VirtualHost>
```

- 基于端口的虚拟主机示例：
```
Listen 80
Listen 8080
Listen 8089
<VirtualHost 172.168.6.0:80>
	ServerName www.d.com
	DocumentRoot "/www/d.com/html"
</VirtualHost>

<VirtualHost 172.168.6.1:8080>
	ServerName www.e.net
	DocumentRoot "/www/e.net/html"
</VirtualHost>

<VirtualHost 172.168.6.2:8089>
	ServerName www.f.org
	DocumentRoot "/www/f.org/html"
</VirtualHost>
```

- 基于FQDN的虚拟主机示例：

- 基于名称虚拟主机配置, **httpd-2.2**版本必须设置
```
NameVirtualHost 172.168.6.0:80

<VirtualHost 172.168.6.0:80>
ServerName www.g.com
DocumentRoot "/www/g.com/html"
</VirtualHost>

<VirtualHost 172.168.6.0:80>
ServerName www.h.net
DocumentRoot "/www/h.net/html"
</VirtualHost>

<VirtualHost 172.168.6.0:80>
ServerName www.i.org
DocumentRoot "/www/i.org/html"
</VirtualHost>
```

#### 12.status页面

> `LoadModule status_module modules/mod_status.so` 必须开启

```
<Location /server-status>
  SetHandler server-status
  Order allow,deny
  Allow from all
</Location>
```



# http协议
- URL：Uniform Resouce Locator，统一资源定位符
- https://www.lingyima.com:443/bbs/index.php

## 基本语法：	
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
	+ http://www.lingyima.com/bbs/hello;gender=f
- query
	+ http://www.lingyima.com/bbs/item.php?user=tom&title=abc
- frag
 	+ http://www.lingyima.com/index.html#heaer-2

- http协议 version：
	+ http/0.9, http/1.0, http/1.1,http/2.0
	+ stateless：无状态 
		* 服务器无法持续追踪访问者来源
		* 解决方案：cookie（追踪同一个用户）

- http事务
	+ 请求：request
	+ 响应：response

	+ 报文的语法格式
		* request报文
			<method> <request-URL> <version>
			<header>


			<entity-body>
		* response报文
			<version> <status> <reason-phrase>
			<headers>

			<entity-body>

		* method：请求方法，标明客户端希望服务器对资源执行的动作; GET,HEAD,POST
		* version: HTTP/<majr>.<minor>
		* status: 三位数字，如200,301,302,404,502; 描述请求处理过程中发生的情况
		* reason-phrase: 状态码所标记的状态的简要描述
		* headers: 每个请求或响应报文可包含任意个首部；每个首部都有首部名称，后面跟一个冒号，而后跟上一个可选空格，接着是一个值；
		* entity-body: 请求时附加的数据或响应时附加的数据

	+ method(方法)：
		* GET：从服务器获取一个资源
		* POST: 向服务器发送要处理的数据
		* HEAD: 只从服务器获取文档响应首部
		* PUT: 将请求的主体部分存储在服务器上（危险）
		* DELETE：请求删除服务器上指定的文档
		* TRACE：跟踪请求到大服务器中间经过的代理服务器
		* OPTIONS：请求服务器返回对指定资源支持使用的请求方法
		
		协议查看或分析的工具：
			tcpdump,tshark,wireshark
	+ status(状态码)
		* 1xx: 100-101，额外信息提示
		* 2xx: 200-206，响应成功的信息
		* 3xx: 300-305，服务器端重定向类信息
		* 4xx: 400-415，客户端错误信息
		* 5xx: 500-505，服务器端错误信息
		
		常用状态码：
			200: 请求的所有数据通过响应报文的entity-body部分发送；OK
			301: 请求的URL指向的资源已经被删除；但在响应报文中通过首部Location指明了资源现在所处的新位置；永久重定向；Moved Permanently
			302: 与301相似，但在响应报文中通过Location指明资源现在所处临时新位置；Found
			304: 客户端发出了条件式请求，但服务器上的资源未曾发生改变，则通过响应此响应状态码通知客户端；Not Modified
			401: 需要输入账号和密码认证方能访问资源；Unauthorized
			403: 请求被禁止；Forbidden
			404: 服务去无法找到客户端请求的资源；Not Found
			500: 服务器内部错误；Internal Server Error
			502: 代理服务器从后端服务器收到一条伪响应：Bad Gateway
	+ headers
		格式：
			Name: Value

Request Headers:
GET / HTTP/1.1 
Host: www.qq.com 
Connection: keep-alive 
	+ 是否保持连接
Upgrade-Insecure-Requests: 1 
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.99 Safari/537.36 
Accept: text/html,application/xhtml+xml,application/
xml;q=0.9,image/webp,*/*;q=0.8 
Accept-Encoding: gzip, deflate, sdch 
Accept-Language: zh-CN,zh;q=0.8
Cookie: tvfe_boss_uuid=aead7ae45ac1d686; pac_uid=1_67668283; eas_sid=X1L418a0g0W4z5l2t168w6T2V9; mobileUV=1_158dd38a6b7_391c4; ts_uid=9246952727; ptui_loginuin=67668283; pgv_pvid=6872186886; o_cookie=67668283; ptcz=04ed5113ef85398a5b53ab269f1faa6d8d6d765f31bce6cad37e4383362eaaae; pt2gguin=o0067668283


Response Headers:
HTTP/1.1 200 OK 
Server: squid/3.5.20 
Date: Fri, 30 Dec 2016 09:36:27 GMT 
Content-Type: text/html; charset=GB2312 
	+ 内容类型
Transfer-Encoding: chunked 
Connection: keep-alive 
Vary: Accept-Encoding 
Expires: Fri, 30 Dec 2016 09:37:27 GMT 
Cache-Control: max-age=60 
Vary: Accept-Encoding 
Content-Encoding: gzip 
Vary: Accept-Encoding 
X-Cache: HIT from tianjin.qq.com

- 首部的分类：
	+ 通用首部

	+ 请求首部
	+ 响应首部

	+ 实体首部
	+ 扩展首部

- 通用首部：
	+ Date: 报文的**创建时间**
	+ Connection: **连接状态**，如keep-alive, close
	+ Via：显示报文经过的**中间节点**
	+ Cache-Control: **控制缓存** http 1.0
	+ Pragma: 控制缓存 **http-1.1版本**

- 请求首部：
	+ Accept: 通过服务器自己可接受的**媒体类型** */* 任意类型
	+ Accept-Charset: 接受的**字符集**
	+ Accept-Encoding: 接受**编码格式**，如gzip,deflate,sdch
	+ Accept-Language: 接收的**语言**

	+ Client-IP: **客户端IP**
	+ Host: 请求的**服务器名称和端口号**
	+ Referer: 包含当前正在**请求的资源的上一级资源**
	+ User-Agent: **客户端代理**

	+ 条件式请求首部：
		* Expect: 期望发送什么样的信息
		* If-Modified-Since: 自从指定的时间之后，请求的资源**是否发生过修改**
		* If-Unmodified-Since:自从指定的时间之后，请求的资源**是否发生过没有修改**
		* If-None-Match:本地缓冲中存储的文档的**ETag标签是否**与服务器文档的Etag**不匹配**
		* If-Match:本地缓冲中存储的文档的**ETag标签**是否与服务器文档的Etag**匹配**

	+ 安全请求首部：
		* Authorization: 向服务器发送**认证信息**，如账号和密码
		* Cookie：客户端向服务器**发送cookie**
		* Cookie2: **cookie版本**

	+ 代理请求服务：
		* Proxy-Authorization: 向**代理服务器认证**

- 响应首部：
	+ 信息性：
		* Age: **响应持续时长**
		* Server: 服务器程序**软件名称和版本**

	+ 协商首部：其资源有多重表示方法时使用
		* Accept-Range: 服务器可接受的**请求范围类型**
		* Vary: 服务器查看的其他首部列表

	+ 安全响应：
		* Set-Cookie: **向客户端设置cookie**
		* Set-Cookie2: 向客户端设置cookie
		* WWW-Authenticate: 来自服务器的对客户端的质询**认证表单**

- 实体首部：
	+ Allow: 列出对此**实体可使用的请求方法**
	+ Location: 告诉客户端真正的**实体位于何处(重定向)**

	+ Content-Encoding: 内容**编码格式**
	+ Content-Language: 内容**语言**
	+ Content-Length: 主体的**长度**
	+ Content-Location: 实体真正所处**位置**
	+ Content-Range: 实体**范围**
	+ Content-Type: 主体的**对象类型**

	+ 缓存相关：
		* ETag: 实体的**扩展标签**
		* Expires: 实体的**过期时间**
		* Last-Modified: **最后一次修改的时间**

### 13.curl命令
基于URL语法在**命令行方式**下工作的**文件传输工具**
支持FTP,FTPS,HTTP,HTTPS,GOPHER,TELNET,DICT,FILE及LOAP等协议
curl支持HTTP认证，并且支持HTTP的POST、PUT方法、FTP上传，kerberos认证，HTTP上传，代理服务器，cookies, 用户名/密码认证，下载文件断点续传，http代理服务器管道（proxy tunneling），甚至它还支持IPv6, socks5代理服务器，通过http代理服务器上传文件到FTP服务器等等

curl [options] [URL...]

curl常用选项：
	-A/--user-agent <string> 	设置用户代理发送给服务器
	-e/--refere <URL>			来源网址

	--basic 						使用http基本认证
	-u/--user <user[:password]>	设置服务器的用户和密码

	--tcp-nodelay 			
	--cacert <file>				CA证书(ssl)
	--compressed				要求返回是压缩的格式(传输过程压缩)
	-H/--header <line>			自定义首部信息传递给服务器
	-I/--head					只显示响应报文首部信息
	--limit-rate <rate>			设置传输速度
	-O/--http1.0				使用http1.0


MIME: major/minor
images/png
image/gif
text/html
text/plain

- elinks [OPTIONS] [URL]...
	+ -dump：不进入交互式模式，而直接将URL的内容输出至标准输出

### 14.user/group
- 指定以哪个用户的身份运行httpd服务进程
`User apache`
`Group apache`

- rpm安装：apache
- 编译安装：daemon

`suid`
`SUexec`

### 15.mod_deflate
- 使用mod_deflat模块压缩页面优化传输速率
- 使用场景：
1. 节约带宽，额外消耗CPU；同时，可能有些叫老浏览器不支持
2. 压缩适于压缩的资源，**文本文件**

- 输出过滤器
`SetOutputFilter DEFLATE`

- # mod_deflat configuration

`# Restrict compression to these MIME types`
`AddOutputFilterByType DEFLATE text/plain`
`AddOutputFilterByType DEFLATE text/html`
`AddOutputFilterByType DEFLATE application/xhtml+xml`
`AddOutputFilterByType DEFLATE text/xml`
`AddOutputFilterByType DEFLATE application/xml`
`AddOutputFilterByType DEFLATE application/x-javascript`
`AddOutputFilterByType DEFLATE text/javascript`
`AddOutputFilterByType DEFLATE text/text`

- # Level of compression (Hightest 9 - Lowest 1)
`DeflateCompressionLevel 9`

- 排除老式浏览器
- # Netscape 4.x has come problems
`BroserMatch ^Mozilla/4 gzip-only-test/html`

- # Netscape 4.06-4.08 have some more problems
`BrowserMatch ^Mozilla/4\.0[678] no-gzip`

- # MSIE masquerades as Netscape, but it is fine
`BrowserMatch \bMSI[E] !no-gzip !gzip-only-text/html`

`Content-Encoding: gzip`

### 16.https， http over ssl

- SSL会话简化过程：
1. 客户端发送可供选择的加密方式，并向服务器请求证书；
2. 服务器端发送证书以及选定的加密方式给客户端；
3. 客户端取得证书并进行证书验证：

	+ 如果新人给其他证书的CA：
	* a) 验证证书来源的合法性；用CA的公钥解密证上的数字签名；
	* b) 验证证书的内容的合法性；完整性验证；
	* c) 检查证书的有效期限；
	* d) 检查证书是否被吊销；
	* e) 证书中拥有者的名字，与访问的目标主机要一致；
4. 客户端生成临时会话密钥（对称加密），并使用服务期端的公钥加密此数据发送给服务器，完成密钥交换；
5. 服务用此密钥加密用户请求的资源，响应给客户端；

注意：SSL会话是基于**IP地址**创建；所以**单IP**的主机上，仅可以使用**一个https虚拟主机**

- 配置httpd支持https:
1. 为服务器申请数字证书
	+ 测试：通过私建CA发证书
		* a) 创建私有CA
		* b) 在服务器创建证书签署请求
		* c) CA签证
2. 配置httpd支持使用ssl, 及使用的证书
`# yum -y install mod_ssl`
	+ 配置文件：/etc/httpd/conf.d/ssl.conf
		`DocumentRoot`
		`ServerName`
		`SSLCentificateFile`
		`SSLCertificateKeyFile`

3. 测试基于https访问相应的主机
`# openssl s_client [-connect host:port] [-cert filename] [-CApath directory] [-CAfile filename]`

示例：
172.16.100.67
`# cd /etc/pki/CA/`
`# ls`
`# (umask 077; openssl genrsa -out private/cakey.pen 2048)`
`# ll private/`
`# openssl req -new -x509 -key private/cakey.pem -out cacert.pem` 自签证书
CN
Beijing
Beijing
Lingyima
Ops
ca.lingyima.com
caadmin@lingyima.com
`CA]# touch serial index.txt`
`CA]# echo 01 > serial`
# 

172.16.100.6
`# cd /etc/httpd/`
`# ls`
`# mkdir ssl`
`# cd ssl/`
`# ls`
`# (umask 077;penssl genrsa -out httpd.key 1024)`
`# openssl req -new -key httpd.key -out httpd.csr`
CN
Beijing
Beijing
Lingyima
Ops
www.lingyima.com
webadmin@lingyima.com
`# scp httpd.csr root@172.16.100.67:/tmp/`

172.16.100.67
`# cd /etc/pki/CA/`
`# openssl ca -in /tmp/httpd.csr -out certs/httpd.crt`
y y
`# scp certs/httpd.crt 172.16.100.6:/etc/httpd/ssl/`

第一步完成
------------------------------------------
172.16.100.6
`# yum -y install mod_ssl`
`# rpm -ql mod_ssl`
`# httpd -M | grep ssl`
`# cd /etc/httpd/conf.d/`
`# cp -pv ssl.conf{,.backup}`
`# vim ssl.conf`
DcoumentRoot "/var/www/html"
ServerName www.lingyima.com
SSLCertificateFile /etc/httpd/ssl/httpd.crt
SSLCertificateKeyFile /etc/httpd/ssl/httpd.key
`# httpd -t`
`# service httpd restart`
`# ss -tln`
443

- 测试访问：172.16.100.67
`# openssl s_client -connect www.lingyima.com:443`
`# openssl s_client -connect www.lingyima.com:443 -CAfile /etc/pki/CA/cacert.pem`
GET /index.html HTTP/1.1
Host: www.lingyima.com

浏览器加载CA证书：

- CA服务器
`# scp root@172.16.100.67:/etc/pki/CA/cacert.pem ./`
`# mv cacert.pem cacert.crt`

- 证书管理器->授权中心->导入
https://172.16.100.6

### 17.httpd自带的工具程序
htpasswd: basic认证基于文件实现时，用到的账号密码文件生成工具；
apachectl: httpd自带的服务控制脚本，支持start和stop, gracefulll；
apxs: 有httpd-devel包提供，扩展httpd使用第三方模块的工具；
rotatelogs: 日志滚动工具；
access.log -->
access.log(新的文件), access.1.log -->
access.log, access.1.log, access.2.log
suexec：访问某些有特殊权限配置的资源时，临时切换至指定用户身份运行；
ab: apache bench

### 18.httpd的压力测试工具
- CLI: ab, webbench, http_load, seige
- GUI: jmeter, loadrunner
- tcpcopy: 网易开发的，复制生产环境中的真实请求，并将之保存下来；

ab [OPTIONS] URL
-n: 总请求数；
-c：模拟的并发数；
-k：以持久连接模式测试；

ab -c 100 -n 1000

### httpd-2.4的常用配置：
- New features：
1. MPM支持运行为DSO机制；以模块形式按需加载；
2. Event MPM 生产环境可用
3. Asynchronous support,异步读写功能
4. 支持每模块及每目录的单独日志级别定义
5. 每请求相关的专用配置
6. 增强版的表达式分析器
7. 毫秒级持久连接时长定义
8. 基于FQDN的虚拟主机也不再需要NameVirtualHost指令
9. 新指令AllowOverrideList
10. 支持用户自定义变量
11. 更低的内存消耗

- 新模块：
1. mod_proxy_fcgi(驱动fastCGI库) (PHP)
2. mod_proxy_scgi (Python)
3. mod_remoteip

### 安装httpd-2.4：
- httpd-2.4依赖于apr-1.4+, apr-util-1.4+, [apr-iconv]
- apr: apache portable runtime

##### CentOS 6下安装httpd-2.4：
- 默认：apr-1.3.9, apr-util-1.3.9
`# rpm -q apr`
`# rpm -q apr-util`

- 编译安装步骤：
	+ 开发环境包组：`Development Tools, Server Platform Development`
	+ 开发程序包：`pcre-devel`, 支持perl正则表达式

[apr](http://apr.apache.org)

1. apr-1.4+
`# ./configure --prefix=/usr/local/apr`
`# make && make install`

2. apr-util-1.4+
`# ./configure --prefix=/usr/local/apr-util \
--with-apr=/usr/local/apr`
`# make -j 2 && make install`

3. httpd-2.4
`# ./configure --prefix=/usr/local/apache24 \
--enable-so --enable-ssl --enable-cgi \
--enable-rewrite \
--enable-modules=most \
--enable-mpms-shared=all \
--sysconfdir=/etc/httpd24 \
--with-mpm=prefork \
--with-zlib --with-pcre \
--with-apr=/usr/local/apr \
--with-apr-util=/usr/local/apr-util \`
`# make && make install`

apr-1.5.0.tar.bz2
apr-util.1.5.3.tar.bz2
httpd-2.4.10.tar.bz2

`# tar xf apr-1.5.0.tar.bz2`
`# cd apr-1.5.0`
`# ./configure --help | less`
`# ./configure --prefix=/usr/local/apr`
`# make && make install`
`# ls -l /usr/local/apr`

`# tar xf apr-util-1.5.3.tar.bz2`
`# cd apr-util-1.5.3`
`# ./configure --prefix=/usr/local/apr-util \
--with-apr=/usr/local/apr`
`# make -j 2 && make install`
`# ls /usr/local/apr-util/`

`# tar xf htpd-2.4.10.tar.bz2`
`# cd httpd-2.4.10`
`# ./configure --prefix=/usr/local/apache24 \
--enable-so --enable-ssl --enable-cgi \
--enable-rewrite \
--enable-modules=most \
--enable-mpms-shared=all \
--sysconfdir=/etc/httpd24 \
--with-mpm=prefork \
--with-zlib --with-pcre \
--with-apr=/usr/local/apr \
--with-apr-util=/usr/local/apr-util \`


--enable/disable：启用/禁用特性
--with-?：依赖于哪些程序包
worker,event是基于线程模型
`# make && make install`

- 启动服务
`# /usr/local/apache24/bin/apachectl start`

- 查看httpd编译安装过程记录文件：
`# vim /usr/local/apache24/build/config.nice`


- 临时生效
`# export PATH=/usrl/local/apache24/bin:$PATH`
`# echo $PATH`

- 永久生效，但必须重启系统
`# vim /etc/profile.d/httpd.sh`
`export PATH=/usrl/local/apache24/bin:$PATH`

`# apachectl stop`
`# hash`

- 导出头文件
`# ln -sv /usr/local/apache24/include /usr/include/httpd`
`# ls /usr/include/httpd/`

- 导出库文件：
`# ldconfig -v	当前系统加载的库`
`# ldconfig -p	当前系统已经加载的库的所有路径`
`# vim /etc/ld.so.conf.d/httpd.conf`
/usr/local/apache24/lib
`# ldconfig -v 加载库文件`

- 配置http-2.4服务脚本
`# chkconfig --add httpd24`
`# chckconfig --list httpd24`
`# service httpd24 status|start|stop|reload`

- 切换MPM：
`# vim /etc/httpd24/httpd.conf`
`# 导入mpm配置文件`
include /etc/httpd24/extra/httpd-mpm.conf

- # 后者导入event模块
`LoadModule mpm_event_module modules/mod_mpm_event.so`
`# vim /etc/httpd24/extra/httpd-mpm.conf`

### CentOS 7下安装httpd-2.4：
`# yum -y install httpd`

- 配置文件：
	+ 主配置文件：`/etc/httpd/conf/httpd.conf`
	+ 模块配置文件：`/etc/httpd/conf.modules.d/*.conf`
	+ 配置文件组成部分：`/etc/httpd/conf.d/*.conf`

`# ls /etc/httpd/modules/`
`# httpd -l`
`# httpd -M`

- 配置应用
1. 切换MPM
	+ 启用要启用的MPM相关的LoadModule指令即可
	`# httpd -M`
	`# vim /etc/httpd/conf.moduled.d/00-mpm.conf`
		`LoadModule mpm_event_module modules/mod_mpm_event.so`
	`# systemctl restart httpd.service`
	`# httpd -M`

2. 基于IP人访问控制
	`DocumentRoot "/apps/www/htdocs"` 

	+ 允许所有主机访问：`Require all granted`
	+ 拒绝所有主机访问：`Require all deny`

	+ 控制特定的IP访问：
		* `Require ip IPADDR`		授权指定来源的IP访问
		* `Require not ip IPADDR`	拒绝指定来源的IP访问

	+ 控制特定的主机访问：
		* `Require host HOSTNAME`		授权指定来源的主机访问
		* `Require not host HOSTNAME`	拒绝指定来源的主机访问

	+ HOSTNAME:
		* FQDN：特定主机
		* Domain.tid：指定域名下的所有主机

	+ 示例：所有主机访问, 禁用Indexes
	<Directory "/apps/www/htdocs">
		Options -Indexes FollowSymLinks
		Require all granted
	</Directory>

	+ 所有主机访问，除了172.16.100.2
	<RequireAll>
		Require all granted
		Require not ip 172.16.100.2
	</RequireAll>

3. 虚拟主机
- 基于FQDN的虚拟主机不再需要设置NameVirtualHost指令

	<VirtualHost *:80>
		ServerName www.a.com
		DocumentRoot "/apps/www/htdocs"
		<Directory "/app/www/htdocs">
			Options None
			AllowOverride None
			Require all granted
		</Directory>
	</VirtualHost>


- 注意：任意目录下的页面只有现实授权才能被访问

- 没有虚拟主机与之配对的域名是访问第一个虚拟主机
默认虚拟主机设置：
	<VirtualHost _default_:80>
		ServerName _default_
		DocumentRoot "/apps/default/htdocs"
		<Directory "/app/default/htdocs">
			Options None
			AllowOverride None
			Require all granted
		</Directory>
	</VirtualHost>

4. ssl
`# yum -y install mod_ssl`
`# rpm -ql mod_ssl`

5. 毫秒级持久连接时长
`KeepAlive on`
`KeepAliveTimeout 30ms`
`MaxKeepAliveRequests	20`

### 练习：分别使用httpd-2.2和httpd-2.4实现
1. 建立httpd服务
1.1 提供两个基于名称的虚拟主机
www1.stuX.com，页面文件目录为/web/vhosts/www1；错误日志为/var/log/httpd/www1/error_log，访问日志为/var/log/httpd/www1/access_log;
www2.stuX.com，页面文件目录为/web/vhosts/www2；错误日志为/var/log/httpd/www2/error_log，访问日志为/var/log/httpd/www2/access_log;
1.2 通过www1.stuX.com/server-status输出其状态信息，且要求只允许提供账号用户访问
1.3 www1不允许192.168.1.0/24网络中的主机访问

2. 上面的第2个虚拟主机提供https服务，使得用户可以通过https安全的访问此web站点
2.1 要求使用证书，证书中要求使用国家(CN), 州(Beijing), 城市(Beijing)，组织为(lingyima)
2.2设置部分为Ops，主机名为www2.stux.com