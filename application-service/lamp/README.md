# LAMP

> Linux + Apache + MySQL/MariaDB + PHP/Python/Perl 开源组合套餐

## Web 资源类型

- 静态资源：原始形式与相应内容一致
- 动态资源：原始形式通过为程序文件，需要在服务器端执行之后结果返回给客户端

- 客户端脚本：html, css, javascript
- 服务器端脚本：php, jsp, python
- MIME 协议支持的资源: application/x-http-php(服务器需要查找相应程序运行)

## CGI

> Command Cateway Interface，通用网管接口(协议)

作用：可以让一个客户端，从网页浏览器向执行在网络服务器上的程序输出数据；CGI 描述了客户端和服务器程序之间传输的一种标准

- 程序=指令+数据
  - 指令：代码文件
  - 数据：数据存储系统、文件

- 数据模型：
  - 层次模型
  - 网状模型
  - 关系模型：表（行+列）

- 关系模型：IngreSQL, Oracle, Sybase, Infomix, DB2, SQL Server, MySQL, PostgreSQL, MariaDB

- 请求流程：Client->(httpd)->httpd--(cgi)--> application server(program file) -- (mysql)--> mysql

## PHP

> 服务器脚本编程语言、嵌入到html中的嵌入式web程序开发语言

基于 zend 编译成 opcode（二进制格式的字节码，重复运行，可省略编译环境）

### PHP简介

PHP是通用**服务器端脚本编程语言**，其主要用于web开发以实现动态web页面，它也是最早实现将脚本嵌入HTML源码文档中的服务器端脚本语言之一。同时，php还提供了一个命令行接口，因此，其也可以在大多数系统上作为一个独立的shell来使用。

Rasmus Lerdorf于1994年开始开发PHP，它是初是一组被Rasmus Lerdorf称作“Personal Home Page Tool” 的Perl脚本， 这些脚本可以用于显示作者的简历并记录用户对其网站的访问。后来，Rasmus Lerdorf使用C语言将这些Perl脚本重写为CGI程序，还为其增加了运行Web forms的能力以及与数据库交互的特性，并将其重命名为“Personal Home Page/Forms Interpreter”或“PHP/FI”。此时，PHP/FI已经可以用于开发简单的动态web程序了，这即是PHP 1.0。1995年6月，Rasmus Lerdorf把它的PHP发布于comp.infosystems.www.authoring.cgi Usenet讨论组，从此PHP开始走进人们的视野。1997年，其2.0版本发布。

1997年，两名以色列程序员Zeev Suraski和Andi Gutmans重写的PHP的分析器(parser)成为PHP发展到3.0的基础，而且从此将PHP重命名为PHP: Hypertext Preprocessor。此后，这两名程序员开始重写整个PHP核心，并于1999年发布了Zend Engine 1.0，这也意味着PHP 4.0的诞生。2004年7月，Zend Engine 2.0发布，由此也将PHP带入了PHP 5时代。PHP5包含了许多重要的新特性，如增强的面向对象编程的支持、支持PDO(PHP Data Objects)扩展机制以及一系列对PHP性能的改进。

### PHP Zend Engine

Zend Engine是开源的、PHP脚本语言的解释器，它最早是由以色列理工学院(Technion)的学生Andi Gutmans和Zeev Suraski所开发，Zend也正是此二人名字的合称。后来两人联合创立了Zend Technologies公司。

Zend Engine 1.0于1999年随PHP 4发布，由C语言开发且经过高度优化，并能够做为PHP的后端模块使用。Zend Engine为PHP提供了内存和资源管理的功能以及其它的一些标准服务，其高性能、可靠性和可扩展性在促进PHP成为一种流行的语言方面发挥了重要作用。

Zend Engine的出现将PHP代码的处理过程分成了两个阶段：首先是分析PHP代码并将其转换为称作Zend opcode的二进制格式(类似Java的字节码)，并将其存储于内存中；第二阶段是使用Zend Engine去执行这些转换后的Opcode。

### PHP的 Opcode

> Opcode是一种PHP脚本编译后的中间语言，就像Java的ByteCode,或者.NET的MSL。PHP执行PHP脚本代码一般会经过如下4个步骤(确切的来说，应该是PHP的语言引擎Zend)：

1. Scanning(Lexing) —— 将PHP代码转换为语言片段(Tokens)
2. Parsing —— 将Tokens转换成简单而有意义的表达式
3. Compilation —— 将表达式编译成Opocdes
4. Execution —— 顺次执行Opcodes，每次一条，从而实现PHP脚本的功能

扫描-->分析-->编译-->执行

### php 的加速器

> 基于 PHP 的特殊扩展机制如opcode缓存扩展也可以将opcode缓存于php的共享内存中，从而可以让同一段代码的后续重复执行时跳过编译阶段以提高性能。由此也可以看出，这些加速器并非真正提高了 opcode 的运行速度，而仅是通过分析opcode后并将它们重新排列以达到快速执行的目的。

#### 常见的 php 加速器有

##### APC (Alternative PHP Cache)

> 遵循PHP License的开源框架，PHP opcode缓存加速器，目前的版本不适用于PHP 5.4。项目地址，http://pecl.php.net/package/APC。

##### eAccelerator

> 源于Turck MMCache，早期的版本包含了一个PHP encoder和PHP loader，目前encoder已经不在支持。项目地址， http://eaccelerator.net/。

##### XCache

> 快速而且稳定的PHP opcode缓存，经过严格测试且被大量用于生产环境。项目地址，http://xcache.lighttpd.net/

##### Zend Optimizer and Zend Guard Loader

> Zend Optimizer并非一个opcode加速器，它是由Zend Technologies为PHP5.2及以前的版本提供的一个免费、闭源的PHP扩展，其能够运行由Zend Guard生成的加密的PHP代码或模糊代码。 而Zend Guard Loader则是专为PHP5.3提供的类似于Zend Optimizer功能的扩展。项目地址，http://www.zend.com/en/products/guard/runtime-decoders

##### NuSphere PhpExpress

> NuSphere的一款开源PHP加速器，它支持装载通过NuSphere PHP Encoder编码的PHP程序文件，并能够实现对常规PHP文件的执行加速。项目地址，http://www.nusphere.com/products/phpexpress.htm

### PHP 源码目录结构

> PHP的源码在结构上非常清晰。其代码根目录中主要包含了一些说明文件以及设计方案，并提供了如下子目录：

1. build —— 顾名思义，这里主要放置一些跟源码编译相关的文件，比如开始构建之前的buildconf 脚本及一些检查环境的脚本等。

2. ext —— 官方的扩展目录，包括了绝大多数PHP的函数的定义和实现，如array系列，pdo系列，spl系列等函数的实现。 个人开发的扩展在测试时也可以放到这个目录，以方便测试等。

3. main —— 这里存放的就是PHP最为核心的文件了，是实现PHP的基础设施，这里和Zend引擎不一样，Zend引擎主要实现语言最核心的语言运行环境。

4. Zend —— Zend引擎的实现目录，比如脚本的词法语法解析，opcode的执行以及扩展机制的实现等等。

5. pear —— PHP 扩展与应用仓库，包含PEAR的核心文件。

6. sapi —— 包含了各种服务器抽象层的代码，例如apache的mod_php，cgi，fastcgi以及fpm等等接口。

7. TSRM —— PHP的线程安全是构建在TSRM库之上的，PHP实现中常见的*G宏通常是对TSRM的封装，TSRM(Thread Safe Resource Manager)线程安全资源管理器。

8. tests —— PHP的测试脚本集合，包含PHP各项功能的测试文件。

9. win32 —— 这个目录主要包括Windows平台相关的一些实现，比如sokcet的实现在Windows下和*Nix平台就不太一样，同时也包括了Windows下编译PHP相关的脚本。

## LAMP 介绍

- httpd：接收用户的web请求；静态资源则直接响应；动态资源为php脚本，对此类资源的请求将交由php来运行
- php：运行php程序
  - `# yum -y install php && rpm -ql php`
- MariaDB：数据管理系统

- http 与 php结合的方式
  - CGI
  - FastCGI(常用结合方式)
  - modules (把php编译成为httpd的模块，性能一般，但服务稳定) MPM:
    - prefork: libphp5.so
    - event, worker: libphp5-zts.so

## 安装 LAMP

CentOS 6 下安装 LAMP

```shell
# yum -y install httpd php php-mysql mysql-server
# service httpd start
# service mysqld start
```

CentOS 7 下载安装 LAMP

``` shell
# yum -y install httpd php php-mysql mariadb-server
# systemctl start httpd.wervice
# systemctl start mariadb.service
```

MySQL 的命令行客户端程序

``` shell
# mysql -uUSERNAME -hHOST -pPASSWORD
# mysql -utestuesr -h172.168.100.67 -p
Error ... (...): Access denied for user 'testuser'@'localhost' (Using password:YES)
错误原因：默认IP地址172.168.100.67进行反解，如果反解的主机名与地址授权分配不匹配，则mysql服务器不能登录
```

解决方案

``` shell
# vim /etc/my.cnf或vim /etc/my.cnf.d/server.cnf
  [mysqld]
  skip_name_resolve = ON

# show GLOBAL VARIABLIES LIKE '%skip%'
# SELECT USER()
```

### 支持 SQL 语句对数据管理：DDL，DML

- DDL(Data Definition Language)： CREATE， ALTER， DROP， SHOW
- DML(Data Manipulation Language)： INSERT， DELETE，SELECT， UPDATE

授权能远程的连接用户

``` mysql
mysql> GRANT ALL PRIVILEGES ON db_name.tbl_name TO username@host IDENTIFIED BY 'password';
mysql> GRANT ALL PRIVILEGES ON testdb.* TO testuser@’%’ IDENTIFIED 'testpass'	> FLUSH PRIVILEGS 刷新权限(mysql进程重读授权表)

'%'：任何追加
'172.16.%.%'：172.16网段
```

实践作业：部署lamp，以虚拟主机安装wordpress, phpwind, discuz;

## AMP

- 静态资源：Client -- http --> httpd
- 动态资源：Client -- http --> httpd --> libphp5.so () -- mysql --> MySQL server

### 快速部署 AMP

- CentOS 6：httpd, php, php-mysql, mysql-server
- CentOS 7:
  - Modules：httpd, php, php-mysql, mariadb-server
  - FastCGI：httpd, php-fpm, php-mysql, mariadb-server

- php：Zend Engine
- 编译：opcode是一种PHP脚本编程后的中间语言
- 执行：PHP引擎里执行opcode代码

- Scanning->Parsing->Compilation->Execution
- 极速器(opcode存储在php共享内存)：APC,eAccelerator,Xcache

### Sendfile()

> 在内核空间直接打包响应

### Event 事件驱动

- 用户空间：通过系统调用，请求获取资源文，继续执行其他进程。
- 内核空间：获取资源文件，通知进程资源装载至内存，用户空间进程收到信息，则复制内存数据到用户空间内存空间当中。如果没有收到系统空间通知，则再此发送通知，直到用户空间收到通知为止。
- 复制内存数据过程是阻塞IO（进程参与）

- 阻塞IO怎么解决？AIO（Asynchronization IO）

1. 调用请求
2. IO 执行过程，把内核空间的内存数据复制到用户空间进程内存数据

非阻塞

事件驱动机制

Linux：epoll()

- 事件驱动
  - 水平触发（多次通知）
  - 边缘触发（一次通知）

- client -> httpd(2.4版本的mod_proxy_fcgi) -> php-fpm(mysql接口) -> mysql

### PHP脚本语言解释器

- 配置文件`：/etc/php.ini,  /etc/php.d/*.ini`

- 配置文件在php解释器启动时被读取，因此，对配置文件的修改如何生效？
  - Modules：重启httpd服务
  - FastCGI：重启php-fpm服务
    - FastCGI: CGI主控进程，控制和管理子进程
    - 独立的服务进程，类似prefork进程

- ini：
  - [foo]：Section Header
  - directive = value

```
注释符：较新的版本中，已经完全使用;进行注释；
#：纯粹的注释信息
;：用于注释可启用的directive
```

data.timezone=Asia/Shanghai
php.ini的核心配置选项文档：  http://php.net/manual/zh/ini.core.php
php.ini配置选项列表：http://php.net/manual/zh/ini.list.php

mariadb(mysql)：

SQL接口：
分析器：分析SQL语句
操作求解器：求解如何执行
计划执行器：执行的路径
优化器：选择最优路径
存储引擎：
文件和存取接口
缓冲管理器
磁盘空间管理器
事务管理器、锁管理器
恢复管理器

补充材料：RDMBS设计范式基础概念

设计关系数据库时，遵从不同的规范要求，设计出合理的关系型数据库，这些不同的规范要求被称为不同的范式，各种范式呈递次规范，越高的范式数据库冗余越小。

目前关系数据库有六种范式：第一范式（1NF）、第二范式（2NF）、第三范式（3NF）、巴德斯科范式（BCNF）、第四范式(4NF）和第五范式（5NF，又称完美范式）。满足最低要求的范式是第一范式（1NF）。在第一范式的基础上进一步满足更多规范要求的称为第二范式（2NF），其余范式以次类推。一般说来，数据库只需满足第三范式(3NF）就行了。

(1) 第一范式（1NF）
所谓第一范式（1NF）是指在关系模型中，对域（字段）添加的一个规范要求，所有的域都应该是原子性的，即数据库表的每一列都是不可分割的原子数据项，而不能是集合，数组，记录等非原子数据项。即实体中的某个属性有多个值时，必须拆分为不同的属性。在符合第一范式（1NF）表中的每个域值只能是实体的一个属性或一个属性的一部分。简而言之，第一范式就是无重复的域。

说明：在任何一个关系数据库中，第一范式（1NF）是对关系模式的设计基本要求，一般设计中都必须满足第一范式（1NF）。不过有些关系模型中突破了1NF的限制，这种称为非1NF的关系模型。换句话说，是否必须满足1NF的最低要求，主要依赖于所使用的关系模型。

(2) 第二范式(2NF)
第二范式（2NF）是在第一范式（1NF）的基础上建立起来的，即满足第二范式（2NF）必须先满足第一范式（1NF）。第二范式（2NF）要求数据库表中的每个实例或记录必须可以被唯一地区分。选取一个能区分每个实体的属性或属性组，作为实体的唯一标识。

第二范式（2NF）要求实体的属性完全依赖于主关键字。所谓完全依赖是指不能存在仅依赖主关键字一部分的属性，如果存在，那么这个属性和主关键字的这一部分应该分离出来形成一个新的实体，新实体与原实体之间是一对多的关系。为实现区分通常需要为表加上一个列，以存储各个实例的唯一标识。简而言之，第二范式就是在第一范式的基础上属性完全依赖于主键。

(3) 第三范式（3NF）
第三范式（3NF）是第二范式（2NF）的一个子集，即满足第三范式（3NF）必须满足第二范式（2NF）。简而言之，第三范式（3NF）要求一个关系中不能包含已在其它关系已包含的非主关键字信息。简而言之，第三范式就是属性不依赖于其它非主属性，也就是在满足2NF的基础上，任何非主属性不得传递依赖于主属性。

数据库：数据集合
表：为了满足范式设计要求，将一个数据集分拆为多个
约束：constraint，向数据表插入的数据要遵守的限制规则
主键：一个或多个字段的组合，填入主键中的数据，必须不同于已存在的数据；不能为空
外键：一个表中某字段中能插入的数据，取决于另外一张表的主键中的数据；
惟一键：一个或多个字段的组合，填入惟一键中的数据，必须不同于已存在的数据；可以为空
检查性约束：取决于表达式的要求

索引：将表中的某一个或某些字段抽取出来，单独将其组织一个独特的数据结构中

常用的索引类型：
  b-tree
  Hash
  有助于读请求，但不利于写请求

关系运算：
  选择：挑选出符合条件的行；
  投影：挑选出符合需要的列；
  连接：将多张表关联起来；

数据抽象：
  物理层：决定数据的存储格式，即如何将数据组织成为物理文件；
  逻辑层：描述DB存储什么数据，以及数据间存在什么样的关系；
  视图层：描述DB中的部分数据；

关系模型的分类：
  关系模型
  实体-关系模型
  基于对象的关系模型
  半结构化关系模型(xml)

## php-fpm

- CentOS 6：
  - PHP-5.3.2-：默认不支持fpm机制；需要自行打补丁并编译安装
  - httpd-2.2：默认不支持fcgi协议，需要自行编译此模块
  - 解决方案：编译安装httpd-2.4, php-5.3.3+

- CentOS 7：
  - httpd-2.4：rpm包默认编译支持了fcgi模块；
  - php-fpm包：专用于将php运行于fpm模式；

### 配置文件

- 服务配置文件(配置PHP服务进程)：`/etc/php-fpm.conf,  /etc/php-fpm.d/*.conf`
- php环境配置文件：`/etc/php.ini, /etc/php.d/*.ini`

``` shell
# vim /etc/php-fpm.conf`
  include=/etc/php-fpm.d/*.conf`
  [global]
  pid = /run/php-fpm/php-fpm.ipd
  error_log = /var/log/php-fpm/error.log
  log_level = notice
  ;emergency_restart_threshold = 0
  ;emergency_restart_interval = 0
  ;process_control_timeout = 0
  daemonize = no 	运行前台用于测试

# vim /etc/php-fpm.d/www.conf
  [www]
  listen = 127.0.0.1:9000 若单独主机，监听与外部httpd主机通信的地址
  ;listen.backlog = -1 后援队列，-1无限制，连接池满了的时候，等待队列的长度
  listen.allowed_clients = 127.0.0.1 允许哪个httpd的地址发起请求

  连接池：
  pm = static|dynamic  
    static：ftpm固定数量的子进程；pm.max_children；最大并发连接数
    dynamic: httpd prefok模式；子进程数据以动态模式管理
  
  pm.start_servers：开始启动进程数
  pm.min_spare_servers：最少空间进程数
  pm.max_spare_servers：最多空间进程数
  ;pm.max_requests = 500：每个进程最大请求连接数
  ;pm.status_path = /status
  ;ping.path = /ping
  php_admin_value[error_log] = /var/log/php-fpm/www-error.log
  php_admin_flag[log_errors_log] = on
  php_value[session.save_handler] = files
  php_value[session.save_path] = /var/lib/php/session

# systemctl start php-fpm.service
# systemctl status php-fpm.service 五个空闲请求任务
# httpd -M | grep fcgi http是否开启fcgi模块
# cd /etc/httpd/conf.modules.d/
# vim 00-proxy.conf
  LoadModule proxy_fcgi_module modules/mod_proxy_fcgi.so
# cd ..
# vim conf/httpd.conf
# vim conf.d/fcgi.conf
```

创建session目录，并确保运行php-fpm进程的用户对此目录有读写权限

``` shell
# mkdir  /var/lib/php/session
# chown apache.apache /var/lib/php/session
```

### 配置 httpd

创建`/etc/httpd/conf.d/fcgi.conf`配置文件

1. 中心主机配置

``` config
DirectoryIndex index.php 默认访问页面
ProxyRequests Off 是否开启反向代理,在这里反向代理
ProxyPassMatch ^/(.*\.php)$  fcgi://127.0.0.1:9000/var/www/html/$1
  代理解析匹配以url后缀.php结束，转义至fcgi协议127.0.0.1:9000端口/var/www/html/$1的资源文件
  ^/(.*\.php)$
  http://www.demo.com/(admin/index.php)
# systemctl restart php-fpm.service
测试访问phpinfo()函数内容
```

2. 虚拟主机配置

- 注释中心主机配置: DocumentRoot "/var/www/html"
- 定义虚拟主机文件名: vhosts.conf

```
DirectoryIndex index.php
<VirtualHost *:80>
  ServerName www.b.net
  AliasName b.net
  DocumentRoot /apps/vhosts/b.net
  ProxyRequests Off
  ProxyPassMatch ^/(.*\.php)$  fcgi://127.0.0.1:9000/apps/vhosts/b.net/$1

<Directory "/apps/vhosts/b.net">
  Options None
  AllowOverride None
  Require all granted
  </Directory>
</VirtualHost>
```

### 编译安装lamp

- httpd：编译安装，httpd-2.4
- mairadb：通用二进制格式，mariadb-5.5
- php5：编译安装，php-5.4

- 注意：任何一个程序包被编译操作依赖到时，需要安装此程序包的“开发”组件，其包名一般类似于name-devel-VERSION；

**CentOS 7**

1. 安装环境开发包

`# yum -y groupinstall "Development Tools" "Server Platform Development"`

2. 安装Mariadb

``` shell
# useradd -r mysql
# tar xf mariadb-5.5.46-linux-x86_64.tar.gz -C /usr/local
# cd /usr/local
# ln -sv mariadb-5.5.46-linux-x86_64 mysql
# cd mysql && chown -R root.mysql ./*
# mkdir /mydata/data && chown -R mysql.mysql  /mydata/data
# mkdir /etc/mysql
# cp support-files/my-large.cnf /etc/mysql/my.cnf
# vim /etc/mysql/my.cnf
  datadir = /mydata/data
  innodb_file_per_table = ON
  skip_name_resolve = ON
# cp /support-files/mysql.server /etc/rc.d/init.d/mysqld
# chkconfig --add mysqld
# bin/mysqld_safe --help --verbose | less
# scripts/mysql_install_db --user=mysql datadir=/mydata/data
# mysql_secure_installation
# service mysqld start
# ss -ltn
# /usr/local/mysql/bin/mysql
# vim /etc/profile.d/mysql.sh
  export PATH=/usr/local/mysql/bin:$PATH
# . /etc/profile.d/mysql.sh


导出库文件
# vim /etc/ld.so.conf.d/mysql.conf
  /usr/local/mysql/lib
# ldconfig OS重载库
# ldconfig -p

httpd-2.4
# yum -y install pcre-devel apr-devel apr-util-devel openssl-devel
#./configure --prefix=/usr/local/apache24 --sysconfdir=/etc/httpd24 \
--enable-so --enable-ssl --enable-rewrite(url重写) \
--with-zlib --with-pcre --with-apr=/usr --with-apr-util=/usr \
--enable-modules=most --enable-mpms-shared=all \
--with-mpm=prefork
# make -j 4 && make install


php-5.4
# yum -y install libxml2-devel libmcrypt-devel bzip2-devel 开发库包

# ./configure --prefix=/usr/local/php \
--with-mysql=/usr/local/mysql \
--with-mysqli=/usr/local/mysql/bin/mysql_config \
--enable-mbstring(多字节字符,支持中文字符) --with-png-dir --with-jpeg-dir \
--with-freetype-dir(字体) --with-openssl --with-zlib \
--with-libxml-dir=/usr --enable-xml --enable-sockets(通信方式) \
--with-apxs2=/usr/local/apache24/bin/apxs --with-mcrypt(加密库) \
--with-config-file-path=/etc --with-config-file-scan-dir=/etc/php.d --with-bz2 --enable-maintainer-zts (线程模式work,even，prefork时不用添加)`

# make -j 4 && make install
# cp php.ini-production /etc/php.ini
# cd /etc/httpd24
# cp httpd.conf{,.backup}
# vim /etc/httpd24/httpd.conf
  AddType application/x-httpd-php .php
  DirectoryIndex index.php index.html
# apachectl stop
# apachectl start
# vim /usr/local/apache24/htdocs/index.php

<?Php echo phpinfo(); ?>

```

Httpd: IO 密集型（避免与MySQL放在一起）
  URL分析(URL映射)：CPU密集型

PHP：CPU密集型（避免与PHP放在一起）
  并发500个位很理想

MySQL: CPU/IO密集型

组合方案：

1. httpd+php,mysql
2. httpd,php,mysql

10000个并发
8000个静态并发
2000个动态并发
  极限500个并发，解决？横向扩展，集群
  20%访问数据(mysql, 400个请求)
    数据数据逻辑复杂，大量事务（极限50个并发）
    解决：
      纵向扩展：主从复制
      横向扩展：mysql集群

### ab命令：远程测试

`# ab -n 20000 -c 200 http://url/phpmyadmin/index.php`

执行三遍，平均数据

测试较大资源文件：执行857k大小(/var/log/message)， log.html

**Concurrency Level: 200** 并发量
**Requests per second:555.55** [#/sec](mean，平均值) 每秒完成多少个请求
**Time per request:	360.005** [ ms ] 一次并发200个请求完成时间
Time per request:	1.800 [ ms ] 每个请求完成时间 （360/200=1.8）
**Transfer rate：带宽x8** = 实际带宽

min mean[+/-sd] median max (单位：ms)
**Connect**: C<---连接---->S 连接时间
  消耗很长：
    1. 网络带宽有限
    2. 服务器过于繁忙已经跑满负载，并发200,你是201个

**Processing**: 服务器上处理I 服务器处理时间
  消耗很长：
    1. 服务器IO慢
    2. 脚本运行慢

**Waiting**: 响应给客户端响应时间
  消耗很长：
    1. 服务器带宽有限
    2. 客户端带宽慢

Total: 总计时间总时间

50% 244 ms
...
**98% 1315** (20000个请求，200并发的98%完成请求量，使用1.3s左右)

虚拟机：一部分空间
虚拟主机：独立空间

phpmysqmin

``` shel
# openssl rand -base64 20 生成随机数
# vim config.inc.php
  $cfg['blowfish_secret'] = '粘贴'

```

- xcache
- epel源中
  - 程序包：yum -y install php-xcache

编译安装 xache 的方法

``` shell
# yum install php-devel
# cd  xcache-3.2.0
# phpize
# ./configure --enable-xcache  --with-php-config=/usr/bin/php-config
# make && make install
# cp  xcache.ini  /etc/php.d/
  xcahce.shm_scheme = "mmap"
  xcache.size = 60M (内存缓存)
  xcache.count = 1 (服务器几个内存)
  xcache.slots = 8k (槽大小)
  xcache.ttl = 0 (缓存时间) 0:永远，空间不够时，使用最近最少使用算法腾出空间
  xcache.

# systemctl restart php-fpm.service

测试 phpfino()
```

php 以扩展模块方式组合

多次访问 php 页面，预热，产生缓存

再次 ap 命令测试，并发量

没有效果时，调整内核参数

使用 CentOS 6 测试

关闭xcache功能, 没mv /etc/php.d/xcache.ini 移走

**安装xcache之后，测试ab命令**

Connection(tcp三次握手，建立连接)：时间太长，网络带宽有限，服务器繁忙(并发高)
服务器构建报文(服务器慢,脚本慢)
服务器响应报文(带宽有限，客户端接受能力有限)

**远程测试ab命令** - 本地测试没有考虑带宽

**一定要有效带宽测试**

博客作业一：CentOS 7, lamp (module)；

(1) 三者分离于两台主机；

(2) 一个虚拟主机用于提供phpMyAdmin；另一个虚拟主机用于提供wordpress；

(3) xcache

(4) 为phpMyAdmin提供https虚拟主机；

博客作业二：CentOS 7, lamp (php-fpm)；

(1) 三者分离于三台主机；

(2) 一个虚拟主机用于提供phpMyAdmin；另一个虚拟主机用于提供wordpress；

(3) xcache

博客作业三：CentOS 6, lamp (编译安装，模块或php-fpm)；

(1) 三者分离于两台或三台主机；

(2) 一个虚拟主机用于提供phpMyAdmin；另一个虚拟主机用于提供wordpress；

(3) xcache

(4) 尝试mpm为非prefork机制