# HA Cluster

- 故障场景：
	+ 硬件故障：
		* 设计缺陷
		* 使用过久不可避免的损坏
		* 人为故障
	+ 软件故障
		* 设计缺陷
		* bug
		* 人为误操作

- Availability=MTBF/(MTBF+MTTR)
	+ MTBF: mean time between failure，多次故障之间时间
	+ MTTR: mean time to require，平均修复时长
		* HA Cluster通过减小MTTR实现可用性提升
	+ 0<A<1: 百分比，90%,95%,99%,99.9%,99.99%,99.999%(支付宝)

- 提供冗余系统：
	+ HA Cluster: 为提升系统调用性，组合多台主机构建成为集群
	+ split
		* 两个主机上同一个文件写操作会破坏文件系统
		* 两个进程操作同一文件写操作会锁
		
		* 解决：补刀，必须杀掉

- 条件：
	ip地址: 在活动主机的别名上作为辅助地址使用
		在备用主机上配置辅助地址使用并删除原活动主机上的IP地址
	ipvs：配置并生成即可

	主机可用性：
		备用主机每个一段时间探测活动主机状态
		每个一秒钟发送报文是否响应报文
	网线可用性
	交换机可用性
	电源可用性

- heartbeat，心跳	
	每个一秒钟发送报文是否响应报文
	
	网络延迟
	CPU负载

	多次探测


- vote system: 投票系统
	HA中的各节点无法探测彼此的心跳信息；必须无法协调工作；此种状态为partitioned cluster;

	少数服务从多数的原则：quorun (法定票数)
		为什么奇数？奇数原则，否则仲裁设备判定
		with quorun > total/2
		without quorun <= total/2

	仲裁设备：偶数节点
		quorun disk=qdisk
		ping node


	fail over：失效转义，故障转移
	fail back：失效转回，故障转回

- 资源类型
	HA-aware: 资源自身可直接调用HA集群底层的HA功能
	非HA-ware: 必须借助于CRM完成在HA集群上实现HA功能

CRM：Cluster Recourse Managment，集群资源管理器
message layer（向特定的地址或发送信号）
[node1] [node2] [node3]
——————————多播————————————


## 实现高可用集群方案：
> 集群中应该有奇数的节点，如果有偶数的引入仲裁设备。
在多个节点上它们彼此之间心跳信息的传递来向别人通告自己的健康状态，而不是我去探测别人。也就意味着每个主机都要运行应用程序，这些应用程序固定在固定的IP地址和端口工作。由于它们是一对多的关系，因此，以基于多播的方式，向特定的多播域内多播端口上发送集群信息和集群心跳信息。每一个节点都不断的周期性的每隔一秒按固定频率向多播域发心跳。其他主机看到此心跳就知道那个主机时在线的。因此，每个主机都是主动向别人通告心跳信息，从而使得集群内个各节点是否存活，能够被集群中的每个节点所得知。这些功能实现的层次称之为message layer，不仅能传送心跳还能传送事务信息（集群发生分裂，某一时刻两个分裂节点，票数少的节点切断电源等补刀操作，这机事务叫做集群事务信息，也都需要message layer来完成）。其对应决策结果消息传递的

任何服务要能够真正成为高可用的，它自己得调用message layer提供的能够基于多播模式传递心跳信息和集群事务信息的能力完成集群事务内部的资源运行位置的决策，但是，不是所有服务都有这个能力。因此，就有人开发了通用层次，集群资源管理器的层，有集群资源管理器层负责承上启下，承上为各本身不具备高可用能力的服务，提供高可用性，让其能够利用message layer完成高可用，其次，他有利用底层message layer所传递过来的各个节点的心跳和集群事务信息形成一个大的决策图景。从而，全貌决策都有对应的CRM来实现，它调用message layer功能来做出整个集群内部事务决策

集群启动并配置集群上的资源应该运行在哪个节点上？
在资源管理器接口上配置
1. 资源更倾向于配置在哪个资源上
2. 这个资源更倾向于哪个资源运行在一起
	ip,进程,网页在同一个节点上
	资源排列关系：资源在一起的倾向性
3. 运行在一起，有先后次序关系
	配置IP地址->服务集成->资源
	先启动后关闭

- 资源的约束关系
	location：位置约束，定义资源对节点的倾向性；用数值来表示; -oo(负无穷),+oo
	colocation：排列约束，定义资源彼此间**在一起**倾向性; -00,+00
		分组：亦能实现将多个资源绑定在一起
	order: 顺序约束，定义资源在同一个节点上启动时的先后顺序

- 资源类型：根据不同的工作模式
	primitive: 主资源，只能运行与集群内某**单个节点**；（也称作native）
	group: 组资源，容器，包含一个或多个资源，这些资源可通过“组”这个资源统一进行调度
	clone: 克隆资源，可以在同一个集群内的多个节点运行多份克隆
	master/slave: 主从资源，在同一集群内部于两个节点运行两份资源，其中一个主，一个为从

- 资源隔离：
	+ 界别：
		* 节点：STONITH(Shoting The Other Node In The Head)
			power switch
		* 资源：fencing
			FC SAN switch

## 解决方案
- Messaging Layer: 消息层
	+ hearbeat
		v1,v2,v3
	+ corosync
	+ cman(RedHat, RHCS)
	+ keepalived(完全不同于上述三种)

- CRM：资源管理器
	+ heartbeat v1 haresources
		* 配置接口：配置文件、文件名为haresources
	+ heartbeat v2 crm
		* 在各节点运行于一个crmd进程，配置接口；
		* 命令行客户端程序crmsh,GUI客户端；hb_gui
	+ heartbeat v3 
		* pacemaker可以以插件或独立方式进行
		* 配置接口，CLI接口：crmsh, pcs
		* GUI接口：hawk(webgui), LCMC, pacemaker-mgmt
	+ rgmanager (配置接口)
		* CLI: clustat,cman_tool
		* GUI: Conga(luci组件、ricci组件)

- 组合方式
	+ heartbeat v1
	+ heartbeat v2
	+ heartbeat v3 + pacemaker
	+ corosync + pacemaker
	+ cman + rgmanager (RHCS)
	+ cman + pacemaker

- LRM: Local Resource Manager, 由CRM通过子程序提供（激活脚本）
- RA: Resource Agent，资源代理（脚本）
	+ heartbeat legacy: heartbeat传统类型的RA，
		* 通常位于/etc/ha.d/haresources.d/目录下
	+ LSB：Linux Standard Base, 
		* /etc/rc.d/init.d/目录下的脚本
		* 至少接受4个参数：{start|stop|restart|status}
	+ OCS: Open Cluster Framework，开发集群框架
		* 子类别：provider

	+ STONITH: 专用于实现调用STONITH设备功能的资源；通常为clone类型

# Heartbeat：心跳信息传递机制
- serial cable: 作用范围有限，不建议使用
- ethernet cable:
	+ UDP Unicast 单播
	+ UDP Multicast 多播（使用）
	+ UDP Broadcast 广播

- 组播地址：用于表示一个IP组播域；
	+ IANA(Internet Assigned Number Authority) 把D类地址空间分配给IP组播使用，其范围是：224.0.0.0-239.255.255.255;

	+ 永久组播地址：224.0.0.0 - 224.0.0.255
	+ 临时组播地址：224.0.1.0 - 238.255.255.255
		* 高可用集群使用
	+ 本地组播地址：239.0.0.1 - 239.255.255.255
		* 仅在特定本地范围内有效


## HA案例：ha web services
- 资源有三个：ip, httpd, filesystem
	+ fip: floating ip 流动IP
		* 172.16.100.17
	+ daemon: httpd

- 约束关系：使用“组”资源，或通过排列约束让资源运行于同一节点
	+ 顺序约束：有次序的启动资源
- 程序选型：
	+ heartbeat v2 + haresources
	+ heartbeat v2 + crm(hb_gui)
	+ crosync + pacemaker

## 配置HA集群的前提
1. 节点间时间必须同步：使用ntp协议实现
2. 节点间需要通过主机名互相通信，必须解析主机至IP地址
	a) 建议名称解析功能使用hosts文件来实现
	b) 通信中使用的名字与节点名字必须保持一致：`uname -n`或`hostname`显示出的名字保持一致
3. 考虑仲裁设备是否会用到
4. 建立各节点之间的root用户能够基于密钥认证

- 注意：定义成为集群服务中的资源，一定不能开机自动启动；
因为他们将由crm管理


## 安装部署
- node1 : 172.16.100.6
- node2 : 172.16.100.7

- node1, node2
	+ 同步时间
		* 172.16.0.1网关设置时间服务器
	+ `# ntpmdate 172.16.0.1` 强制同步
	+ `# crontab -e`
		`*/3 * * * * /usr/sbin/nptdate 172.16.0.1 &> /dev/null`

`# date; ssh 172.16.100.7 'date'`

- node1
	`# uname -n`
	`# hostname`
	`# vim /etc/hosts`
		172.16.100.6 node1.lingyima.com node1 (简写形式)
		172.16.100.7 node2.lingyima.com node2
		172.16.100.8 node3.lingyima.com node3
		172.16.100.9 node4.lingyima.com node4

- node2
	`# uname -n`
	`# hostname`
	`# vim /etc/hosts`
		172.16.100.6 node1.lingyima.com node1 (简写形式)
		172.16.100.7 node2.lingyima.com node2
		172.16.100.8 node3.lingyima.com node3
		172.16.100.9 node4.lingyima.com node4

- node1
`# ssh-keygen -t rsa -P ''`
`# ssh-copy-id -i ~/.ssh/id_rsa.pub root@172.16.100.7`
`# ssh node2.lingyima.com 'ifconfig'`

- node2
`# ssh node1.lingyima.com 'ifconfig'`

### node1
`# lftps`
`/pub> cd Sources/6.x86_64/`
`/pub/Sources/6.x86_64> mirror heartbeat2/`
`# ls && cd heartbeat2/`
`# rpm -qpi heartbeat-2.1.4-12.el6.x86_64.rpm`
- 解决依赖关系
`# yum -y install net-snmp-libs libnet PyXML`
- heartbeat-VERSION 主程序包
- heartbeat-gui-VERSION: hb GUI包
- heartbeat-stonith-VERSION: 节点隔离包
- heartbeat-ldirectord-VERSION: ipvs检查健康状态工具 
- heartbeat-pills-VERSION: 库
- heartbeat-devel-VERSION: 
- heartbeat-debuginfo-VERSION: 
- heartbeat-devel-VERSION: 

`# rpm ivh heartbeat-VERSION heartbeat-pills-VERSION heartbeat-stonith-VERSION `

- 配置文件
`# ls -l /etc/ha.d/`目录下
	ha.cf：主配置文件，定义各节点上的heartbeat HA集群的基本属性
		`/usr/share/beartbeat-2.1.4/ha.cf`

	authkeys：集群内节点间彼此传递消息时使用的加密算法及密钥；指纹算法（单向加密）
	haresources: 为heartbeat v1提供的资源管理器配置接口；v1版本专用的配置接口


- 复制安装包到node2节点上
`# scp -r heartbeat2/ node2:/root`

### node2安装heartbeat包
`# rpm ivh heartbeat-VERSION heartbeat-pills-VERSION heartbeat-stonith-VERSION` 

### node1
`# cd /etc/ha.d/`

- 资源代理
`# ld /etc/ha.d/resources.d`

- 服务脚本
`# ld /etc/rc.d/init.d`

- 复制配置文件
`# cp /usr/share/doc/heartbeat-2.1.4/{ha.cf,haresources,authkeys} /etc/ha.d/`
`# chmod 600 authkeys`

- 配置authkeys
	`# vim authkeys`
		auth 2
			启动第二项
		2 sha1 密钥

	`# openssl rand -base64 16`
	复制到 2 sha1 => 密钥

- 配置ha.cf配置文件
	#logfacility local0 由syslog进行日志管理
		# vim /etc/rsyslog.conf
			local0.* 		/var/log/heartbeat.log
		# service rsyslog restart
	logfile /var/log/ha-log
	
	#keepalive 2
		多长时间发一次心跳，默认2s

	#deadtime 30
		多长时间没有收到信息挂掉节点，秒

	#varntime 10
		多长时间警告对方的心跳信息延迟了
		一般小于deadtime,大于keepalive	
		10秒钟探测5次了，都没有收到对方心跳，对方可能故障问题，所以在日志中记录对方节点有可能故障

	#initdead 120
		初始开始dead time，因为有可能有多个节点，只在第一个节点运行，其他节点正常，但由于第一节点问题而收不到其他节点心跳信息

	#udpport 694 
		iana

	#baud 19200
		串行速度，字节
	#serial /dev/ssyS0
		串行线缆
	
	#bcast eth0
		广播

	mcast eth0 225.23.190.1 694 1 0
		1: ttl,只允许一次
		0: 不允许循环传递
		使用多播

		网卡支持多播：UP MULTICAST
		- 启用多播
			`# ip link set eth0 multicast on`
		- 关闭多播
			`# ip link set eth0 multicast off`
	
	auto_failback on
		故障修复之后，资源是否被重新failback

	node node1.lingyima.com
	node node2.lingyima.com
		node节点，不许uname -n必须一致
	
	ping 172.16.0.1
		仲裁设备
	
	# ping_group group1 10.10.10.254
		ping不够时使用ping_group

	compression bz2
		节点是否压缩

	compression_threshold 2
		最少压缩大小2kb 

- haresoures
	#just.linux-ha.org 135.9.26.110 http
		主节点的名字 有多少个资源(ip) 每个资源代理的名字

	#just.linux-ha.org 135.9.216.3/28/eth0/135.9.216.12 httpd
		135.9.216.12 广播地址
	
	node1.lingyima.com 172.16.100.17/16/eth0/172.16.255.255 httpd


`# scp -p authkeys ha.cf haresources node2:/etc/ha.d/`
`# service heartbeat start`
`# yum -y install httpd`
`# vim /var/www/html/index.html`
	node1.lingyima.com
`# service httpd start`
`# curl 172.16.100.6`
`# service httpd stop`
`# chkconfig httpd off`


### node2
`# service heartbeat start`
`# yum -y install httpd`
`# vim /var/www/html/index.html`
	node2.lingyima.com
`# service httpd start`
`# curl 172.16.100.7`
`# service httpd stop`
`# chkconfig httpd off`

### node1
`# ss -tunl` 
`# tail /var/log/heartbeat.log`
`# service heartbeat start; ssl node2.lingyima.com 'service heartbeat start'`
`# ss -tunl`
`# ifconfig`
访问网页: node1.lingyima.com

- node1故障
`# service heartbeat stop`
访问网页为node2.lingyima.com

### node2
`# ss -tunl`
`# ifconfig`

### node1
`# service heartbeat start`
访问网页: node1.lingyima.com
`# ss -tunl`
`# ifconfig`

### node2
`# ss -tunl`
`# ifconfig`


## HA Web Services
- fip,httpd(nginx),filesystem
- 通过资源转义，保证其可用性

- HA Cluster
	+ Messaging Layer: Infrastructure 实现心跳信息传递、集群事务消息传递
		* heartbeat,corosync,cman,keepalived
	+ CRM: Cluster Resoucres Manager 集群资源管理器
		* haresources,crm,pacemaker,rgmanager
	+ LRM：Local Resources Manager 本地资源管理器

	+ RA：Resource Agent
		* heartbeat legacy,lsb,ocf(provider),stonith

- partitioned cluster
	+ vote system
		* with quorum
		* without quorum
	+ fencing
		* 节点：stonith
		* 资源：fencing

- 资源的约束
	+ location: -oo,+00
	+ colocation
	+ order

- 资源的类型
	+ primitive,group,clone,master/slave

- HA Cluster
	heartbeat v2(v1 crm)
	heartbeat v2(v2 crm)
	corosync + pacemaker
	cman + rgmanger

- partitioned
	with quorum
	without quorum
		stopped
		ignore
		freeze
		suicide


- HA Cluster的工作模型
	+ A/P: 两节点集群，active,passive；工作于主备模型
		* HA Service通过只有一个，HA Resources可能会有多个

	+ A/A：两节点集群，active/active;
		* 工作于双方模型
	+ N-M：N个节点，M个服务，通常N>M
	+ N-N：N个节点，M个服务

- 资源运行的倾向性
	+ rgmanager 
		* failover domain, node priority

	+ pacemaker
		* 资源黏性：运行于当前节点的倾向性
		* 资源约束：
			位置约束：资源对运行于其节点的倾向性
				inf: 正无穷
				-inf: 负无穷
	40:00























