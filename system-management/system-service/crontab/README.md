# Linux任务计划
>未来的某时间点执行一次某任务：at,batch

# 周期性任务执行
>周期性任务执行：crontab
- 执行结果会通过邮件发送给本地主机的用户

## 查看本地邮件服务:
- `# ss -tnl`
- `# netstat -tnl`
> 127.0.0.1:25	IPv5 local 25 port
> ::1:25		IPv6
> master主控进程监听25端口

## 本地电子邮件服务
- **smtp**：simple mail transmission protocol (发送邮件)
- **pop3**：Post Office Protocol (收发邮件)
- **imap4**：Internet Mail Access Protocol (收发邮件)

## mail命令
- mailx - send and receive Internet mail (CentOS 7)
	+ MUA: Mail User Agent，用户收发邮件的工具程序
	+ `mailx [-s 'Subject'] username[@hostname]`

```
# mail -s "hello centos" centos
How are you these days?
.
EOT
# su - centos
$ mail  不带任何参数时，接受邮件
& 1 邮件编号
& q 退出邮件
```
### 邮件收发格式
- From redhat@CentOS6.localdomain  Mon Jan  9 10:07:59 2017 
发送人	发送时间
- Return-Path: <redhat@CentOS6.localdomain> 回复是给谁
- X-Original-To: centos
邮件原始发给谁（可以转发，代收用户）
- Delivered-To: centos@CentOS6.localdomain 
投递给谁
- Date: Mon, 09 Jan 2017 10:07:58 +0800
- To: centos@CentOS6.localdomain
- Subject: You are so happy
- User-Agent: Heirloom mailx 12.4 7/29/08
- Content-Type: text/plain; charset=us-ascii
- From: redhat@CentOS6.localdomain
- Status: RO

### 发送邮件：
- `# mail [-s SUBJECT] username@[hostname]`
- `# mail -s "SUBJECT" local_username`
- `# cat /var/spool/mail/centos`

### 邮件正文的生成：
1. 交互式输入：单独成行可以表示正文结束；Ctrl+d提交即可
2. 通过输入重定向 
- `# mail -s 'SUBJECT' root < mail.content`
3. 通过管道，命令的执行结果
- `# cat file | mail -s 'SUBJECT' root`

## at命令执行一次
- `at [OPTION]... TIME`
>at的作业有队列，用单个字母表示队列，默认使用a队列

- 常用选项：
	+ -l：查看作业队列，相当于atq 命令，执行之后看不到
	+ -d <number>：删除指定的作业，相当于atrm # 命令
	+ -f /PATH/TO/SOMEFILE：从指定文件中读取作业任务，而不用在交互输	
	+ -c <number>: 查看at作业内容

- TIME 
	+ HH:MM [YYYY-mm-dd]
	+ noon 正午
	+ midnight 午夜
	+ teatime 4pm
	+ tomorrow
	+ now+#
		* UNIT: min[utes],hours,days or weeks
		* `# at now+1min`

- `#　at min+2min`
- `cat /etc/fstab`
- `echo "hello world"`
- `Ctrl+D 			保存退出`
- `#　at -l 			作业列表`
- `#　at -d <number> 	删除作业` 
- `#　at -c <number> 	查看作业内容`

### 执行文件
- `# vim at.task`
- `# cat /etc/inittab`
- `#　echo "hello a echo"`
- `# at -f at.task　now+5min`

- 提交at命令的用户已经退出，内容上面有环境配置来执行at
- -q：queue:指明队列

- **注意**：作业执行结果是一以邮件发送给提交作业的用户


## batch命令
>batch会让系统选择在系统资源较空闲时间去执行指定的任务

## crontab命令
- 服务程序：
	+ cronie：主程序包

- 确保crond守护进程(daemon)处于运行状态
	+ CentOS 7: `systemctl status crond.service`
		* Active: active(running) ... ...

	+ CentOS 6: `service crond status`
		* ... Is running.

### 向crond提交作业的方式不同于at，它需要使用专用的配置文件，此文件有固定格式，不建议使用文本编辑器直接编辑此文件；要使用crontab命令

#### cron任务分为两类：
- 系统 cron 任务：主要用于实现系统自身的维护；
	+ 手动编辑 /etc/contab 文件
- 用户 cron 任务：/etc/crontab 文件
	+ 命令：crontab 命令
	
### 1. 系统 cron 的配置格式：/etc/crontab
```
SHELL=/bin/bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin
MAILTO=root
HOME=/

# For details see man 4 crontabs

# Example of job definition:
# .---------------- minute (0 - 59)
# |  .------------- hour (0 - 23)
# |  |  .---------- day of month (1 - 31)
# |  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ...
# |  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
# |  |  |  |  |
# *  *  *  *  * user-name command to be executed
```

#### 注意：
1. 每一行定义一个周期性任务，共7个字段；
	+ *  *  *  *  * : 定义周期性时间
	+ user-name : 运行任务的用户身份
	+ command to be executed：任务

2. 此处的环境变量不同于用户登录后获得的环境，因此，建议命令使用**绝对路径**，或者自定义PATH环境变量；

3. 执行结果邮件发送给**MAILTO**指定的用户

### 2. 用户cron的配置格式：/var/spool/cron/USERNAME
```
SHELL=/bin/bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin
MAILTO=root

# For details see man 4 crontabs

# Example of job definition:
# .---------------- minute (0 - 59)
# |  .------------- hour (0 - 23)
# |  |  .---------- day of month (1 - 31)
# |  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ...
# |  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
# |  |  |  |  |
# *  *  *  *  *   command to be executed	
```

#### 注意
1. 每行定义一个cron任务，共**6个字段**；
2. 此处的环境变量不同于用户登录后获得的环境，因此，建议命令使用绝对路径，或者自定义PATH环境变量；
3. **邮件发送给当前用户**；
			
### 时间表示法
1. 特定值
	+ 给定时间点有效取值范围内的值；
	+　注意：day of week和day of month一般不同时使用；
2. *
	+ 给定时间点上有效取值范围内的所有值；表“每..”
3. 离散取值：,
	+ 在时间点上使用逗号分隔的多个值； 
	+ #,#,#
4. 连续取值：-
	+ 在时间点上使用-连接开头和结束
	+ #-#
5. 在指定时间点上，定义步长: 
	+ /#：#即步长；

#### 注意
1. 指定的时间点不能被步长整除时，其意义将不复存在；
2. 最小时间单位为“分钟”，想完成“秒”级任务，得需要额外借助于其它机制；
3. 定义成每分钟任务：而在利用脚本实现在每分钟之内，循环执行多次；
					
### 示例
```
3 * * * *：每小时执行一次；每小时的第3分钟；
3 4 * * 5：每周执行一次；每周5的4点3分；
5 6 7 * *：每月执行一次；每月的7号的6点5分；
7 8 9 10 *：每年执行一次；每年的10月9号8点7分；
9 8 * * 3,7：每周三和周日；每天的8点9分
0 8,20 * * 3,7：每周三和周日；每天的8点整合20点整
0 9-18 * * 1-5：每周一到周五，每天9点整到18点整
*/5 * * * *：每5分钟执行一次某任务
*/5 */3 * * *：每天每3个小时每5分钟执行一次
03:05,03:10,03:15,...,03:55
06:05,06:10,06:15,...,06:55
		...
21:05,21:10,21:15,...,21:55
00:05,00:10,00:15,...,00.55
*/7 * * * *
07,14,21,...,56,
```

## crontab命令：
- crontab [-u user] [-l | -r | -e] [-i] 
	+ -e：编辑任务；
	+ -l：列出所有任务；
	+ -r：移除所有任务；即删除/var/spool/cron/USERNAME文件
	+ -i：在使用-r选项移除所有任务时提示用户确认
	+ -u user：root用户可为指定用户管理cron任务					
									
- **注意**：运行结果以邮件通知给当前用户；如果**拒绝接收邮件**：
	+ COMMAND >/dev/null
	+ COMMAND &>/dev/null

- 注意：定义COMMAND时，如果命令需要用到**%**，需要对其**转义**；但放置于**单引号中的%不用转义**亦可；
			

### 思考：某任务在指定的时间因关机未能执行，下次开机会不会自动执行？不会！

###　如果期望某时间因故未能按时执行，下次开机后无论是否到了相应时间点都要执行一次，可使用anacron实现；
				
### 课外作业：**anacron**及其应用
			
### 练习：
- 每 12 小时备份一次 /etc 目录至 /backups 目录中，保存文件 名称格式为"etc-yyyy-mm-dd-hh.tar.xz"
- 每周2、4、7备份 /var/log/secure 文件至 /logs 目录中，文件名格式为"secure-yyyymmdd"；

- 每两小时取出当前系统 /proc/meminfo 文件中以S或M开头的行信息追加至/tmp/meminfo.txt 文件中；