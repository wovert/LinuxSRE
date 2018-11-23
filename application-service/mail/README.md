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

- 邮件传输代理：MTA(Mail Transfer Agent)

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

41:00

### ESMTP

> Extended Simple Mail Transfer Protocol

## POP3

> Post Office Protocol 3，邮件收发协议

### IMAP4

> Internet Mail Access Protocol 4

比 POP3 功能强大，但消耗性能更多



