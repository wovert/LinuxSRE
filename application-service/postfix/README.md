# mail server
- SMTP: Simple Mail Transfer Protocol,简单邮件传输协议
- ESMTP: Extended Simple Mail Transfer Protocol

- POP3: Post Office Protocol, 邮局协议
- IMAP4: Internet Mail Access Protocol, 因特网邮件访问协议


- UUCP: Unix to Unix Copy
Uniux主机复制文件的协议

## SMTP：简单邮件传输协议
- 邮件中继：邮件转发的服务
Server 				Client
smtpd(25/tcp) 		smtp(sendmail)，随机端口

~/mbox
邮件传输：MT, mail transfer
邮件投递：MD, mail delivery
	邮件服务进程把邮件投递到用户的邮筒
邮件用户：MU, mail user

- MUA: Mail User Agert
	+ 邮件编写代理
		* Linux： mail命令
		* Windows: outlook
- MTA：Mail Transfer Agent
	+ 邮件传输代理

- LMTP: Local Mail Transfer Protocol, 
	+ 本地发送邮件协议

- 发送远程邮件：mstpd调用客户端smtp远程连接主机的smptd服务

- MDA: Mail Delivery Agent
	+ 邮件投递代理

MUA(编写邮件)----smpt协议----->SMTPD服务(MTA)---lmtp协议--->本地用户邮件
MUA(编写邮件)----smpt协议----->SMTPD(MTA)-----smtp客户端-----smtp协议------>连接远程邮件服务器（SMTPD服务）并发送邮件
---------> MDA(投递工具) ------> 邮筒------查看----> 邮件用户目录的mbox
回复邮件过程：MUA ---> smptd服务 ---> 不是本地邮件，调用smtp工具与远程服务器smptd服务连接并发送邮件 -> smtpd使用MDA --->  邮筒------查看----> 邮件用户目录的mbox

- Open Relay: 开放式中继， 发送 -> 中继 -> 目标
	+ 转发邮件到目标邮件服务器的邮件会成为垃圾邮件。因此，之后目标服务器会转发服务器发送的邮件拒收。
	+ 必须关闭开放式中继

允许本地用户必须中继
	MUA -> SMTPD
	SMTPD -> SMTP -----> SMTPd

SMTP不管发件的是谁，只关注接受邮件人是谁
smtp发件人随意伪装
账号和密码发送邮件，smtp不知认证功能

## smtp账号密码认证
- SASL：Simple Authentication Secure Layer, 简单认证安全层
	+ SMTPD服务转发到SASL服务验证用户是否存在，不存在拒绝发送，存在继续执行


## POP3
> 邮件接收协议
MRA: Mail Retrieval Agent，邮件检索代理
MUA ------pop3协议-----> 认证（用户名和密码）------> 收发邮件

user-----http协议----> 登录邮件网站：编辑邮箱发送 -----> SMTP（判断远程邮件服务器还是本地用户）  
user-----http协议----> 登录邮件网站-----pop3协议-----> POP3服务器-----> 检索对应用户邮件

- Webmail

- 邮箱用户？
	+ /etc/passwd 不可行
	+ 关系型数据库：mysql数据库服务器
	+ LDAP：Lightweight Directory Access Protocol, 轻量级目录服务器访问协议，比检索mysql块10倍，写入比mysql慢10倍
		* 不成熟，用于用户账号系统、检索系统
		* 
- 虚拟用户：仅用于访问某服务的数字标识
	用户：字符串，凭证（加密的密码）

	Webmail <------- POP3服务器 <---- Mysql（验证用户）<------ 组件检索 <---- SASL服务 <------- SMTPD服务

反垃圾邮件：对英文字符识别度高，对中文识别度不高
	附件邮箱炸弹（下载、执行=>木马）
	特征码相似度有多高

接受邮件->垃圾邮件分拣器->病毒邮件->发送






















