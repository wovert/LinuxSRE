# Linux 运维架构-[零壹码博客](https://lingyima.com)
## [计算机入门 ComputersGetting started](./computerGetting-started/)
- [计算机概论](./computerGetting-started/computer-concepts/)
- [操作系统](./computerGetting-started/operating-system/)
- [计算机网络](./computerGetting-started/computer-network/)
- [程序设计语言](./computerGetting-started/programming-language/)

## [Linux 基础系统](./Linux-BasicSystem/)
- Linux 安装与配置环境
- Linux 基础入门
- 文件系统
- 文件操作工具
- bash 特性
- 文本处理工具及正则表达式
- 用户管理工具
- Linux 编辑器
- 压缩打包工具

## Linux 系统管理
- 磁盘分区
- 文件系统管理工具
- 程序包管理
- 网络管理
- 进程管理
- Linux 启动流程
- 内核管理
- 安装系统

## SHELL 脚本编程

## 系统服务管理
- systemd
- 任务计划
- SELinux
- OpenSSL
- OpenSSH
- DNS
- IPTABLES
- tcp wrapper
- nss and pam

## 服务安全及服务管理
- File Server
- FTP
- NFS
- SMB
- Web Service
	+ Apache
	+ PHP
	+ Mariadb(Storage)
	+ Cache
		* Memecache, varnish
	+ NoSQL(Cache)
		* Redis
		* MongoDB
		* HBase
	+ tomcap
	+ session replication cluster

- [Nginx](./application-service/nginx/)


## Cluster(集群)
- LB Cluster(负载均衡)
	+ LVS
	+ Nginx
	+ haproxy
- HA Cluster(高可用集群)
	+ keepalived
	+ Corosync+Pacemaker
	+ pcc/crmsh
- MySQL Cluster
	+ HA Cluster
	+ MHA
	+ Read-Write splitting

## 分布式
- zookeeper
- 分布式文件系统

## Linux OPS(运维工具)
- ansible(中小规模)
- puppet(大规模自动化工具，Ruby开发的)
- saltstack(Python开发的)
- cobbler

## Linux 监控
- zabbix

## 虚拟化技术
- Linux 操作系统原理
- 虚拟化技术原理
- XEN
- KVM
- 虚拟化网络
- SDN

## 云计算
- OpenStack(IAAS云)
- Docker

## 大数据
- Hadoop v2
- HBase
- Hive
- Storm
- Spark
- ELK Stack
	+ ElasticSearch(搜索引擎)
	+ Logstash(日志收集)
	+ Kibana(前段展示工具)

## 系统优化

## 人工智能

## 区块链

## IT 技术岗位

### 研发技术
- 硬件：机器语言（二进制的指令和数据）开发的接口代码
- 软件：程序写的程序代码
	+ 低级语言：汇编语言(机器(CPU能够执行的指令)相关的指令)，汇编器
	+ 高级语言：C/C++, 编译器
		* 系统级别(接近机器，机器执行性能更好)：C/C++ 
			性能服务类程序：操作系统, 数据库
		* 应用级(接近人类，人类易于编写)：Java, Python, Go
			应用程序：ansible, puppet

### 应用技术
- 运维：Linux 生态圈中的各应用程序的应用
	+ Shell 脚本编程：某些应用工作能自动完成
	+ Python：专业编程语言
		* Ansible Openstack
- DevOps: 开发运维


## RedHat 认证
- 认证考试	认证培训课程编号							认证培训课程名称
- RHCSA		RH124,RH135								红帽认证系统管理员
- RHCE		RH254									红帽认证工程师
- RHCA		RH401,RH436,RH423,RH442,RHS333			红帽认证架构师
- RHCSS		RedHat Certified Security Specialist	红帽认证安全专家
- RHCDCS	RedHat Certified Datacenter Specialist	红帽认证数据中心专家
- RHVA		RedHat Certified Virtualization Administrator	红帽认证虚拟化管理

- RH033 	基础
- RH133 	操作系统管理
- RH253 	服务管理
- RH401
- RH423 (ldap)
- RH442
- RH436 集群和存储
- RHS333

## Linux运维工程师
- 运维工程师在国内又称为运维开发工程师(Devops)，在国外称为 SRE（Site Reliability Engineering）。
负责维护并确保整个服务的高可用性，同时不断优化系统架构、提升部署效率、优化资源利用率提高整体的ROI. return on investment(投资回报率) 
运维工程师面对的最大挑战是大规模集群的管理问题，如何管理好几十万台服务器上的服务，同时保障服务的高可用性
规模较大的公司(比如：Google、FaceBook、百度、阿里、腾讯等)，运维工程师和系统管理员是有一定的区别：

- 系统管理员：主要负责机房网络、服务器等硬件基础设施的运行和维护。
- 运维工程师：主要负责管理并维护在运行在海量服务器上的软件服务。


## 上课环境
- 172.16.0.0/16
- Windows: 172.16.250.[1-254]
- Linux: 172.16.249.[1-254]
- 网管：172.16.0.1
- DNS: 172.16.0.1
- Server: 172.16.0.1, 192.168.0.254, 192.168.1.254 允许核心转发
	+ DNCP 服务
	+ ftp://172.16.0.1
	+ http://192.168.0.254
	+ cobbler 服务
- 学生：172.16.Y.1-254, 172.16.100+Y.1-254

## VMware Workstation
- 现代计算机组织体系-5大部件
	+ 运算器、控制器、存储器、输入设备、输出设备
		* CPU
		* bus: 总线（控制总线、数据总线、地址总线[寻址]）	 
		* memory: 编制存储设备
	+ IO：对外部部件交互
		* 硬盘
		* 网卡