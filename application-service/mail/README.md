# Mail Server

## UUCP

> Unix to Unix CoPy, Unix 主机复制文件的协议

## SMTP

> Simple Mail Transfer Protocol，简单邮件传送协议

- 邮件发送协议
- 传输路由的功能
- C/S架构

- 客户 -> A邮件服务器(邮件中继:邮件服务器转发邮件) -> B邮件服务器(邮件中继) -> 目标邮件服务器

- smtpd: tcp/25

- 邮件传输：MT
- 邮件投递：MD
- 邮件用户：MU（mail函数）
- 邮件用户代理: MUA
  - 先发给本地SMTP邮件服务器（LMTP）
  - SMTPD(MTA: Mail Transfer Agent) -> SMTP客户端 ---SMTP协议-> 远程SMTPD -> 远程MDA(Mail Deliver Agent, 邮件投递代理) -> 邮件邮筒 -> MUA来查看邮件内容

### SMTP 如何工作

- Servers: smtpd(sendmail)
- Client: smtp

早期计算机有 Uniz 主机用户都有自己的家目录

### ESMTP

> Extended Simple Mail Transfer Protocol

## POP3

> Post Office Protocol 3，邮件收发协议

### IMAP4

> Internet Mail Access Protocol 4

比 POP3 功能强大，但消耗性能更多



