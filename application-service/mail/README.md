# Mail Server

## UUCP

> Unix to Unix CoPy, Unix 主机复制文件的协议

## SMTP

> Simple Mail Transfer Protocol，简单邮件传送协议

- 邮件发送协议
- 传输路由的功能
- C/S架构

### SMTP 如何工作

- Servers: smtpd(sendmail)
- Client: smtp

- 客户 -> A邮件服务器(邮件中继:邮件服务器转发邮件) -> B邮件服务器(邮件中继) -> 目标邮件服务器

- smtpd: tcp/25

- 邮件传输：MT （smtp协议传输邮件）
- 邮件投递：MD （邮件发送到邮筒）
- 邮件用户：MU（mail函数）
- 邮件用户代理: MUA
  - 先发给本地SMTP邮件服务器（LMTP）
  - MUA ------smtp协议------>SMTPD(MTA: Mail Transfer Agent) -> LMTP协议发送给本地邮箱
  
  - SMTP客户端 -----SMTP协议-----> 远程SMTPD -> 远程MDA(Mail Deliver Agent, 邮件投递代理) -> 邮件邮筒 -> MUA来查看邮件内容

早期计算机有 Unix 主机用户都有自己的家目录

主机A的用户Alice(alice@a.com)向主机B的用户Bob(bob@b.com)发送邮件。

1. 主机A用户在本地使用编辑器(vi)编写邮件内容发送给主机B的用户Bob。但是bob@b.com是在b.com域内。

2. 主机A使用客户端smtp链接主机B的smtpd服务，根据目标邮件地址的域，判断域名所在主机，向DNS服务器查询请求（b.com MX mail.b.com => mail A 2.2.2.2）可能会有多个MX记录，这时会找优先级高的MX记录，主机A客户端smtp试图连接主机B的smtpd服务的端口的套接字（tcp/25），客户端使用随机大于5000未使用的端口。使用三次握手。使用smtp协议负责邮件传输。

3. 服务器收到邮件数据之后，邮件数据不可能放到用户B的家目录。邮件数据放到B用户的所对应**邮筒**目录下（每个用户都有邮箱中转站，是用户名相同的文件），主机B的用户登录服务器之后，有个脚本文件不停地检索用户所在的邮箱中是否有邮件，如果有文件发送通知给该当前用户。当前用户也可以查看是否含有邮件。mail命令收发邮件时，去除邮件放到用户家目录下，而此时用户邮筒没有邮箱（早起的使用方式，现在可以复制内容）。用户看过的内容都在用户家目录下，没有看过的都在用户邮筒目录下。用户家目录下生成`mbox`文件。

4. 邮件到达服务器之后，有另外一个组件完成邮件放到邮筒。这个组件叫做邮件投递。

5. bob回复邮件到alice。使用编辑器编辑邮件之后，使用本地smtp客户端连接Alice主机的smtpd服务进行邮件传输。邮件到达A主机的Alice的邮筒。alice登录主机后，取回邮件到alice家目录下。

6. alice@a.com 发送给 bike@a.com 邮件。本地客户端连接本地smtpd服务。smtpd服务会把邮件发送到目标本地用户邮筒上。

7. 每个用户编辑邮件发送的工具就是客户端。这个工具通过smtp协议将邮件送往本地服务器的。他不是直接连接远程服务器，而且这个机制也不是 smtp工具，male命令可以发送邮件。mail命令专门写邮件而且将用户邮件发送的。邮件用户（MU）。

8. 邮件用户代理（MUA）让邮件用户编写邮件。用户每一次发送邮件，打开邮件用户代理编辑界面（Outlook），在此处写好邮件之后，并不发往目标邮件的。任何邮件服务器都有自己所允许的目标服务器，这个服务器通常是本地的。这个SMTPD本地服务器。这个邮件服务器通常直接发给本地SMTPD服务器。邮件账号所在的SMTPD邮件服务器，它不是直接发送给远程服务器，而本地邮件服务器负责分拣，来判定用户的邮件发往什么地方去。分拣为两类，有本地和远程的。本地邮件直接发往本地用户的家目录。这个过程叫做lmtp 本地邮件传送协议。如果是远程的邮件，SMTPD服务器调用SMTP客户端，由它去负责链接远程SMTPD邮件服务器，目标远程SMTPD服务器收到邮件之后，判断是否为自己所在的域的用户邮件。SMTPD服务器连接投递MDA（Mail Delivery Agent），由这个MDA发往用户的邮筒。Bob查看邮件，使用MUA(mail命令)查看邮筒内容，查看完之后放到自己的家目录。

9. 回复邮件，MUA写好邮件，提交给SMTPD服务，SMTPD分拣之后发现这不是本地邮件，调用本地的SMTP客户端通过smtpx协议连接要回复的远程SMTPD服务器。SMTPD服务器收到数据之后，的确是自己负责的域，发给MDA负责邮件发送到目标用户的邮筒。用户登录之后，通过MUA接口邮件。这是回复的路线。

10. 如果alice@a.com 发送给 cary@c.com 到 b.com 的smtpd服务器。smtpd服务器收到邮件之后，发现不是本地邮件，于是调用本地smtp客户端连接它所认为的目标服务器的smtpd的服务(cary@c.com)端。cary@c.com服务器smtpd服务认为是b.com发过来邮件。因为连接smtpd的服务客户端是b.com服务器。但是发件人依然是 alice@a.com。发过来的邮件主机客户端是 b.com。发件人(alice@a.com)和发件的主机(b.com)之间没有必然联系。垃圾邮件由此诞生。只要是 b.com 发过来的邮件都拒收。无论如何b.com都会转发邮件。**随意转发**的邮件服务器会有滥用的风险。邮件转发的机制 **open Relay（开放式中继）**。因此关闭中继。垃圾邮件服务器黑名单。

MUA到SMTPD之间，SMTPD接受之后分拣，只要分拣之后是否为本地邮件，如果不是本地邮件转向smtp客户端负责发送邮件。如果是本地邮件，本地用户允许中继，是基于IP认证。70%是家贼。

基于用户密码认证才能发送邮件。中继不管是谁，要么可以发送，要么禁止发送，中继只管收件人士谁，不管发件人是谁。所以，在使用中继过程当中，发件人随意，冒充谁都可以。

### smtpd 如何用户认证

> smtpd协议本分没有认证功能, 借助于额外的认证工具。通过 SASL(Simple Authentication SEcure Layer, 简单认证安全层) 协议，给邮件服务器加了一个层，邮件服务器就可以认证功能了。

MUA (id:pw) ---smtp协议---> SMTPD服务器 -----sasl协议------> SASL 服务器 ---验证id:pw---> MUA ------> SASL服务器 ------> SMTPD服务器(合法性得到验证发送邮件，否则拒绝发送邮件)

### ESMTP

> Extended Simple Mail Transfer Protocol

## POP3

> Post Office Protocol 3，邮件收发协议

### POP3 如何工作

PC机上有MUA，为了避免用户登录服务器收发邮件，在服务器上安装服务（MRA）PC连接上的用户提供账号和密码，此服务帮PC机用户检索用户账号锁对应的邮件并返回给PC机用户MUA。

- MRA：Mail Retrieval Agent 邮件取回代理

为了避免每个用户都使用MUA，使用浏览器完成所有邮件工作。邮箱服务器上安装Web服务器后，用户通过浏览器连接Web服务器。用户触发发送邮件按钮，会在Web服务器与SMTP客户端连接，判断目标邮件是否为本地或远程邮件。如果是远程远程邮件，与目标远程邮件服务器SMTP服务进行连接。

收发邮件时通过Web服务器的邮件模块与pop3服务器进行连接进行检索邮件返回给Web服务器。这种机制叫做**Web Mail**。

Web服务器和POP3服务器都需要用户验证需要用户验证。在`/etc/passwd`放邮箱用户，利用文件系统存储。他会载入所有账号数据到内存进行检索。Are you joking? 解决方案：用户适应关系型数据来管理账号，进行索引来检索用户。不用载入所有数据。当我们用户数据量超大量的时候，用户数据量依然是太庞大了。有一种协议，在实现用户检索的速度超快的，比MySQL数据库快快一个数量级（10倍），LDAP协议（轻量级目录访问协议 Lightweight Directory Access Protocol）。LDAP协议按照目录的组织进行检索，它有个缺陷是读的巨快，写的速度巨慢(比MySQL慢数量级)。所有LDAP协议适合一次写入多次读取。如果量级不大，可以使用MySQL，管理比LDAP方便。大量用户系统，大量检索系统都使用LDAP。OS对LDAP实时最好的是 Windows Server。RHCE 书籍当中LDAP一本书来讲解。一个公司上万个用户可以使用LDAP协议。Windows通过图像化方式实现走在Linux前面。Windows Server 2018 直接整合了 AD, ACtive Direction (LDAP服务的实现)。

虚拟用户：与OS用户无关的邮箱账号在数据库存储（用户名和数据库）。仅用于访问某服务的数字标识。用户：字符串，凭证，密码加密存放。POP3（自带MySQL驱动，也有LDAP驱动）可以连接查找MySQL服务器的账号和密码。SMTPD没有此功能（SASL有查找系统用户功能，没有查找MySQL功能，如何查找MySQL？附加额外的功能组件，这个组件能够让SASL连接MySQL）。

- 垃圾邮件：垃圾邮件过滤器组件
- 病毒邮件：病毒邮件过滤器组件

### IMAP4

> Internet Mail Access Protocol 4

比 POP3 功能强大，但消耗性能更多

## postfix

- MTA(Mail Transfer Agent)邮件传输代理
  - SMTP服务器
  - SMTP服务软件
    - sendmail 软件（使用 UUCP 协议）
      - 单体结构，SUID，配置文件语法（`m4`编写）
    - qmail
      - 数学家开发的，速度比sendmail快20倍，体积比sendmail 小
      - 短小精悍，性能超强
      - 使用短，所以抛弃了
      - 有些商业邮件，使用qmail核心
    - postfix
      - 新贵, 设计避免于sendmail缺陷和SUID
      - **模块化**设计
      - **安全**
      - 跟sendmail兼容性好
      - 投递**效率**高于sendmail 40倍
    - exim
      - 英国剑桥大学，exim(MTA)
      - 使用配置很简单
    - Exchange(Windows OS)
      - 异步消息协作平台
      - 必须装有 AD

- SASL(v1，v2用的比较多)：
  - cyrus-sasl 提供
    - yum list all | grep sasl
      - cyrus-sasl.xxx 核心组件 （服务器端）
  - courier-authlib 带认证机制
    - 美籍俄罗斯人开发的

- MDA: 邮件投递代理
  - 投递软件
    - procmail
    - maildrop
      - 美籍俄罗斯人，配有垃圾邮件过滤

- MRA：邮件检索代理 (pop3, imap4)
  - MRA 软件
    - cyrus-imap
    - dovecot
      - 功能强大，性能很好

- MUA：邮件用户代理
  - Outlook Express(精简版), Outlook(专业版)
  - Foxmail(腾讯)
  - Thunderbird(Linux)
  - Evolution(Linux)
  - mutt（基于文本界面的）

- Webmail
  - Openwebmail（Perl开发的）
  - squirerelmail(PHP开发的)
    - yum list all | grep mail
  - Extmail(Extman 界面)（Perl开发的）
    - 国内开源, 在OS中定制版
    - EMOS，CentOS 商业版

### 邮箱配置架构程序

- 发送邮件：Postfix + SASA(认证，或 courier-authlib） + MysQL
- 收邮件: Dovecot + MySQL
- webmail: Extmail + Extman + httpd

- redhat: postfix rpm编译的时候不支持SASL的虚拟用户的认证

``` sh
# netstat -tnlp
# service sendmail stop
# chkconfig sendmail off
# rpm -e sendmail --nodeps

安装
```

1. 安装cyrus-sasl

``` sh
# yum list all | grep sasl
cyrus-sasl-devel-xxx 安装就没有问题

# yum install cyrus-sasl
# rpm -ql cyrus-sasl-devel
  /usr/include/sasl 头文件
  /usr/lib/libsasl2  库文件

# ls -l /usr/lib/sasl2

启动saslauthd服务，并将其加入到自动启动队列
# service saslauthd start
# chkconfig saslauthd on
``

1. 安装 mariadb并设置root用户密码

``` sh

# service mysqld start
# chkconfig mysqld on
# mysqladmin -root password 'password'

```

2. 安装 [postfix](http://www.postfix.org/)


[postfix-2.11.11](ftp://ftp.cuhk.edu.hk/pub/packages/mail-server/postfix/official/postfix-2.11.11.tar.gz)

``` sh

邮件发送用户
# groupadd -g 2525 postfix
# useradd -g postfix -u 2525 -g /sbin/nologin -M postfix

投递邮件用户
# groupadd -g 2526 postdrop
# useradd -g postdrop -u 2526 -s /sbin/nologin -M postdrop

# id postfix
# id postdrop

# cd /usr/local/src
# wget ftp://ftp.cuhk.edu.hk/pub/packages/mail-server/postfix/official/postfix-2.11.11.tar.gz
# tar xcvf postfix-2.11.11.tar.gz
# cd postfix-2.11.11
# ls
# less INSTALL

CCARGS 哪里查找头文件
AUXLIBS 辅助的库文件路径
DUSE_TLS 支持SMTPS协议（加密传输）
-lz 压缩库文件
-lm 模块
-lssl 库
-lssl2 库
-lcrypto 库

yum安装
# make makefiles 'CCARGS=-DHAS_MYSQL -I/usr/include/mysql -DUSE_SASL_AUTH -DUSE_CYRUS_SASL -I/user/include/sasl -DUSE_TLS' 'AUXLIBS=-L/usr/lib/mysql -lmysqlclient -lz -lm -L/usr/lib/sasl2 -lsasl2 -lssl -lcrypto'

源码安装
# make makefiles 'CCARGS=-DHAS_MYSQL -I/usr/local/mysql/include/mysql -DUSE_SASL_AUTH -DUSE_CYRUS_SASL -I/user/include/sasl -DUSE_TLS' 'AUXLIBS=-L/usr/local/mysql/lib -lmysqlclient -lz -lm -L/usr/lib/sasl2 -lsasl2 -lssl -lcrypto'


# make
# make install
```