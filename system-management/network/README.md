# 计算机网络
- TCP/IP协议栈
- ISO:Internatianal Standardization Organization，国际标准化组织
  - OSI:Open System Interconnect Reference Model，开放式系统互联参考模型
- 资源子网：application
- 通信子网：transform, network, data link

- MAC: Media Access Control，物理地址
  - 附加在网卡上的全球唯一编号，进行互联网通信物理地址
  - 48bits: 6bytes
  - ICANN：24bits, 2^24
    - 地址块：2^24
  - 网桥（bridge）：MAC地址表，解决冲突域
    - 静态指定
    - 动态学习：根据原地址学习
- 交换机(switch)：多扣网桥

- IP(Internet Protocol)地址：网络号+主机号，逻辑地址
- IPv4:32bits, 4bytes
  - 8bits.8btis.8bits.8bits
  - 0.0.0.0-255.255.255.255
- IPv6:128bit, 16bytes
  - 16bits.16btis.16bits.16bits.16bits.16btis.16bits.16bits
  - 0.0.0.0-255.255.255.255
  - ABCD:EF01:2345:6789:ABCD:EF01:2345:6789
    - 2001:0DB8:0000:0023:0008:0800:200C:417A
    - 2001:DB8:0:23:8:800:200C:417A
  - FF01:0:0:0:0:0:0:1101 → FF01::1101
    - 0:0:0:0:0:0:0:1 → ::1
    - 0:0:0:0:0:0:0:0 → ::

# IP地址分类

## A类
- 第一段为网络号，后三段为主机号
- 网络号：
  - 0 000 0000 - 0 111 1111：0-127
  - 网络数量：126(0: 外网地址，127：本地回环地址)
  - 每个网络中的主机数量：2^24-2(全0:网络地址,全1:广播地址)
  - 默认子网掩码：255.0.0.0，/8
    - 用于与IP地址按位进行“与”运算，从而取出其网络地址；
    - 1.3.2.1/255.0.0.0 = 1.0.0.0
    - 1.3.2.1/255.255.0.0= 1.3.0.0	
  - 私网地址：10.0.0.0/255.0.0.0

## B类
- 前两段为网络号，后两段为主机号
- 网络号：
  - 10 00 0000 - 10 11 1111：128-191
  - 网络数：2^14
  - 每个网络中的主机数量：2^16-2
  - 默认子网掩码：255.255.0.0，/16
  - 私网地址：172.16.0.0-172.31.0.0

## C类：
- 前三段为网络号，最后一段为主机号
- 网络号：
  - 110 0 0000 - 110 1 1111：192-223
  - 网络数：2^21
  - 每个网络中的主机数量：2^8-2
  - 默认子网掩码：255.255.255.0,  /24

## D类：组播
- 1110 0000 - 1110 1111：224-239

## E类：科研
- 240-255

# 路由器：router
## 路由表：
- 静态指定
- 动态学习：rip2, ospf

## 路由条目：
- 目标地址  下一跳(nexthop)，也可以叫网关，跨互联网通信
- 目标地址的类别：
  - 主机：主机路由
  - 网络：网络路由
  - 0.0.0.0/0.0.0.0：默认路由	

- 三个路由同时满足的时候优先级顺序：主机路由 < 网络路由 < 默认路由

## 发送分组数据流程：
1. 在本地查找/etc/hosts本地应解析服务器; 设置DNS IP地址
2. 通过互联网获取域名对应的IP地址; 通过DNS获取IP地址
3. 本地网络广播方式获取目标地址MAC（ARP地址解析协议发送broadcast）
4. 目标地址主机回应请求MAC地址
5. 响应目标MAC地址收到之后封装数据帧

同时缓存目标MAC地址，有可能目标MAC地址改变，因此缓存MAC地址设置TTL(Time To Live) 生命周期时间

每个主机广播ARP通告，其他主机更新缓存

1.发送分组数据包

- ARP广播方式获取目标MAC地址，动态学习
- 可以手动设置目标MAC地址

# OS：多用户，多任务
- 多任务：多进程
  - chrome：
  - QQ

- 通信时，进程的数字标识：
  - 16bits： 0-65535：1-65535
    - 1-1023：固定分配，而且只有管理员有权限启用
    - 1024-4W：半固定
    - 4W+：临时

- 进程地址：IP:PORT => socket
- 进程是靠套接字(socket)实现的

## 常用端口
- 25(发送mail)
- 22(ssh)
- 80(http)
- 443(https)
- 21(ftp连接)
- 20(ftp传输数据)
- 110(pop3邮件)
- 421(TCP Wrappers)
- 3306(mysql)

- 用户空间(资源子网)：应用程序的进程
- 内核空间(通信子网)：进程管理、内存管理、驱动管理、网络协议栈

- MAC：本地通信；范围：本地局域网
- IP：界定通信主机，源和目标；范围：互联网
- Port：界定进程；范围：主机
- 网关：网络关口，本地网络的默认路由，数据转发到其他网络

## 将Linux主机接入到网络中
1. IP/NETMASK：本地通信
2. 路由（网关）：跨网络通信
3. DNS服务器地址：基于主机名的通信

主DNS服务器地址

备用DNS服务器地址，主DNS服务器宕机时使用

第三备份DNS服务器地址, 备用DNS服务器宕机时使用	

## 配置方式
- 动态分配
- 静态指定

###　动态分配：依赖于本地网络中有DHCP服务
- DHCP：Dynamic Host Configure Procotol
- IP/NETMASK,GATEWAY,DNS
- DHCP没有响应时候，169.254.X.Y自动分配，可以再本地联网

### 静态分配：
1. 配置文件：不会立即生效，重启生效(启动时配置文件)
2. 使用命令：立即生效，写入内核，重启失效

#### 使用命令：
- ifcfg家族：net-tools 包
  - ifconfig：配置IP，NETMASK
  - route：路由
  - netstat：状态及统计数据查看

- iproute2家族：ip-route 包
  - ip OBJECT
    - addr：地址和掩码
    - link：接口
    - route：路由
  - ss：状态及统计数据查看

- nm家族:Network Manager
  - nmcli：命令行工具 NetworkManager包
  - nmtui：text window 工具 NetworkManager-tui包

- DNS服务器配置
  - 配置文件：`/etc/resolv.conf`

- 本地主机名配置:标识本地主机
  - 临时生效：`# hostname` 
  - 配置文件：`/etc/sysconfig/network`
    - CentOS 7：`# hostnamectl`

#### 配置文件
- RedHat及相关发行版 `/etc/sysconfig/network-scripts/ifcfg-NETCARD_NAME`

### 网络接口命名方式
#### 传统命名
- 以太网：ethX, [0,oo)，例如eth0, eth1, ...
- PPP网络：pppX, [0,...], 例如，ppp0, ppp1, ...

#### 可预测命名方案（CentOS）： 支持多种不同的命名机制：

Fireware(固件,硬件方式)命名, 拓扑结构命名
  
如果Firmware或BIOS为主板上集成的设备提供的索引信息(三块网卡，每个网卡都有唯一的标识)可用，则根据此索引进行命名，如eno1, eno2, ...

如果Firmware或BIOS为PCI-E扩展槽所提供的索引信息可用，且可预测，则根据此索引进行命名，如ens1, ens2, ...

如果硬件接口的物理位置信息可用，则根据此信息命名，如enp2s0, ...

如果用户显式定义，也可根据MAC地址命名，例如enx122161ab2e10, ...

述均不可用，则仍使用传统方式命名

- 命名格式的组成：
  - en：ethernet
  - wl：wlan(无线局域网)
  - ww：wwan(无线广域网)

- 名称类型：
  - o<index>：集成设备的设备索引号
  - s<slot>：扩展槽的索引号
  - x<MAC>：基于MAC地址的命名
  - p<bus>s<slot>：基于总线及槽的拓扑结构进行命名

# ifcfg命令家族：ifconfig, route, netstat

## ifconfig命令：接口及地址查看和管理
- ifconfig  [INTERFACE]
- ifconfig interface [aftype] options | address ...

``` shell
# ifconfig -a` show all interfaces and interface of inactive
# ifconfig <interface> IP/MASK  [up|down]
# ifconfig <interface> IP netmask NETMASK gateway GATEWAY
# ifconfig <interface> 0 去掉IP地址
```

- add<地址> 设置网络设备IPv6的IP地址

`# ifconfig <interface> add IPV6/prefixlen`

- del<地址> 删除网络设备IPv6的IP地址

`# ifconfig <interface> del IPV6/prefixlen`

down 关闭指定的网络设备。

<hw<网络设备类型><硬件地址> 设置网络设备的类型与硬件地址。

io_addr<I/O地址> 设置网络设备的I/O地址。

irq<IRQ地址> 设置网络设备的IRQ

中断请求（Interrupt Request）

media<网络媒介类型> 设置网络设备的媒介类型。

mem_start<内存地址> 设置网络设备在主内存所占用的起始地址。

metric<数目> 指定在计算数据包的转送次数时，所要加上的数目。

mtu<字节> 设置网络设备的MTU。

netmask<子网掩码> 设置网络设备的子网掩码。

tunnel<地址> 建立IPv4与IPv6之间的隧道通信地址。

up 启动指定的网络设备。

-broadcast<地址> 将要送往指定地址的数据包当成广播数据包来处理。

-pointopoint<地址> 与指定地址的网络设备建立直接连线，此模式具有保密功能。

-promisc 关闭或启动指定网络设备的promiscuous模式。

[IP地址] 指定网络设备的IP地址。

[网络设备] 指定网络设备的名称。

### options
- [-]arp
- [-]promisc 混杂模式
- [-]allmulti 启动组播或多播

`# ifconfig eth1 promisc` 启用
`# ifconfig eth1 -promisc` 禁用

- **注意**：立即送往内核中的TCP/IP协议栈并生效
```
Link encap:Ethernet  HWaddr 00:0C:29:BA:8B:52  
inet addr:192.168.1.61  Bcast:192.168.1.255  Mask:255.255.255.0
        inet6 addr: fe80::20c:29ff:feba:8b52/64 Scope:Link
        UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
        RX packets:31343 errors:0 dropped:0 overruns:0 frame:0
        TX packets:16014 errors:0 dropped:0 overruns:0 carrier:0
        collisions:0 txqueuelen:1000 
        RX bytes:9314883 (8.8 MiB)  TX bytes:2086007 (1.9 MiB)
```

CentOS 7:
```
eno16777736: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
inet 192.168.1.71  netmask 255.255.255.0  broadcast 192.168.1.255
    inet6 fe80::20c:29ff:fe4e:2155  prefixlen 64  scopeid 0x20<link>
    ether 00:0c:29:4e:21:55  txqueuelen 1000  (Ethernet)
    RX packets 55022  bytes 48564958 (46.3 MiB)
    RX errors 0  dropped 0  overruns 0  frame 0
    TX packets 25451  bytes 2699801 (2.5 MiB)
    TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
```

flags：标志位（用以表明储存数据特征的）

UP（代表网卡开启状态）

RUNNING（代表网卡的网线被接上）

MULTICAST（支持组播）

BROADCAST（支持广播）

MTU: 最大传输单元（maximum transmission unit）

Inet:IPv4 netmask 子网掩码 broadcast 广播地址

Ether 以太网地址 txqueuelen 1000 (Ethernet)

RX表示接收数据包的情况

RX packets 55022  bytes 48564958 (46.3 MiB)

分组包数量，总大小字节(MiB)

TX表示发送数据包的情况

errors: 错误个数

dropped: 丢包个数

overruns: 溢出

collisions：网络讯号碰撞的情况说明

	txqueuelen：传输队列长度大小

carrier: CSMA的C是载波。它的值很高表示出错很多，导致网络性能下降。通常是物理层的错误造成的，比如电缆问题、强电干扰、等等
 传输的 IO 大于 kernel 能够处理的 IO 导致的，而 Ring Buffer 则是指在发起 IRQ 请求之前的那块 buffer。很明显，overruns 的增大意味着数据包没到 Ring Buffer 就被网卡物理层给丢弃了，而 CPU 无法即使的处理中断是造成 Ring Buffer 满的原因之一，上面那台有问题的机器就是因为 interruprs 分布的不均匀(都压在 core0)，没有做 affinity 而造成的丢包。 

### 管理IPv6地址：
- add addr/prefixlen
- del addr/prefixlen

## route命令：路由查看及管理

### 路由条目类型：
- 主机路由：目标地址为单个IP
- 网络路由：目标地址为IP网络
- 默认路由：目标为任意网络，0.0.0.0/0.0.0.0

### 查看
`# route  -n`
> n: numerical

主机名显示方式

有大量反解路由条目时，指向单机，泛解消耗时间。

不建议使用名称方式显示路由条目

### 添加：route add [-net|-host] target [netmask Nm] [gw GW] [[dev] If]
```
# route add -net 0.0.0.0/0.0.0.0 gw 172.16.1.1  
# route add default gw 172.16.1.1
```

目标地址     下一跳网关    目标地址掩码
```
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
0.0.0.0         192.168.1.1     0.0.0.0         UG    100    0      0 		eno16777736
0.0.0.0         192.168.1.1     0.0.0.0         UG    101    0      0 		eno33554984
0.0.0.0   默认网关		

172.16.0.0      0.0.0.0         255.255.0.0     U     100    0        0 eno33554984
本地主机网络地址 本地主机无需网关(本地所在网络，所以不需要网关地址)

192.168.1.0     0.0.0.0         255.255.255.0   U     100    0        0 eno16777736
192.168.1.1     0.0.0.0         255.255.255.255 UH    100    0        0 eno33554984
```

- Flags:路由条目标志
- U：up启用状态
- G：网关
- Metric：要经过的开销
- Iface：

#### 添加示例：
- CentOS 6(Hostid: 192.168.1.61/24)
- CentOS 7(Hostid: 192.168.1.71/24， 172.16.7.1/16)

#### CentOS 6
`# route add -net 172.16.0.0/16 gw 192.168.1.71 dev eth0`
`# ping 172.16.7.1`

#### CentOS 6：
```
Destination     Gateway         Genmask         Flags Metric Ref    Use 	Iface
192.168.1.0     0.0.0.0         255.255.255.0   U     0      0      0 		eth0
192.168.1.0     0.0.0.0         255.255.255.0   U     1      0      0 		eth1
172.16.0.0      192.168.1.71    255.255.0.0     UG    0      0      0 		eth0
169.254.0.0     0.0.0.0         255.255.0.0     U     1002   0      0 		eth0
0.0.0.0         192.168.1.1     0.0.0.0         UG    0      0      0 		eth0
```

### 删除：
```
# route del [-net|-host] target [gw Gw] [netmask Nm] [[dev] If]
# route del -net 10.0.0.0/8 gw 192.168.10.1
# route del default
```

## netstat命令：
> Print network connections, routing tables, interface statistics, masquerade(伪装) connections, and multicast  memberships（组员关系)

### 显示路由表：netstat  -rn
- -r：routing，显示内核路由表
- -n：numerical, 不要反解

### 显示网络连接选项：
- [--all|-a] 所有状态连接TCP/UDP/SCTP/RAW
- [--tcp|-t] TCP协议的相关连接
- [--udp|-u] UDP相关的连接
- [--udplite|-U]  
- [--sctp|-S] 
- [--raw|-w] raw cocket相关的连接
- [--listening|-l]  监听状态的连接
- [--numeric|-n] [--numeric-hosts] [--numeric-ports] ][--numeric-program] 数字格式显示IP和PORT
- [--extend|-e[--extend|-e]] 扩展格式，多现实字段(User[谁启动此进程], Inode)

[--program|-p] 显示相关的进程和PID

State: ESTABLISHED状态

FSM（Finate State Machine）

State: LISTEN状态

#### tcp：
- 面向连接的协议；
- 通信开始之前，要建立一个虚链路；
- 通信完成后还要拆除连接；

#### udp：
- 无连接的协议；直接发送数据报文

```
# netstat -t
Active Internet connections (w/o servers)
Proto Recv-Q Send-Q Local Address               Foreign Address             State
tcp        0     64 192.168.1.61:ssh            192.168.1.104:foliocorp     ESTABLISHED

# netstat -tn
Active Internet connections (w/o servers)
Proto Recv-Q Send-Q Local Address               Foreign Address             State
tcp        0      0 192.168.1.61:22             192.168.1.104:2242          ESTABLISHED

协议 接受队列(等待请求的个数) 传送队列 本地地址 远程地址 状态 进程/
Proto Recv-Q Send-Q Local Address Foreign Address State PID/Program name tcp  0 52 192.168.1.71:22 192.168.1.104:5041 ESTABLISHED 4696/sshd: root@pts
```

### 常用组合

- -tan：所有TCP所有状态数字格式现实
- -tn: 只显示当前处于连接的TCP 
- -tnl: 所有TCP所有状态数字格式现实 
- -uan：所有UDP数字格式现实
- -unl：所有UDP监听数字格式现实
- -tunlp：所有TCP和UDP监听进程数字格式现实

### 显示接口的统计数据：

```
# netstat {--interfaces|-I|-i} [iface]
[--all|-a] [--extend|-e]
[--verbose|-v] [--program|-p] [--numeric|-n]
```

- 所有接口：`# netstat -i`
- 指定接口：`# netstat -I<IFace>`

## ifup/ifdown命令

> 通过配置文件/etc/sysconfig/network-scripts/ifcfg-IFACE来识别接口并完成配置

`# ifup/ifdown <interface>`

## 配置主机名

- hostname命令：
  - 查看：`hostname`
  - 配置：`hostname HOSTNAME`
  - 当前系统有效，重启后无效

- hostnamectl命令（CentOS 7）：
  - `hostnamectl  status`：显示当前主机名信息
  - `hostnamectl  set-hostname`：设定主机名，永久有效

- 配置文件：`/etc/sysconfig/network`
  - `HOSTNAME=<HOSTNAME>`
  - 设置不会立即生效； 但以后会一直有效；

## 配置DNS服务器指向：

> 先主机域名解析配置，如果没有再查找DNS服务器配置

### 本地域名解析配置：

`/etc/hosts`
`172.16.7.1 lingyima.com www.lingyima.com`

### DNS服务器配置

- 配置文件：/etc/resolv.conf
- nameserver DNS_SERVER_IP
- 最多可以设置3个

## 如何 DNS 测试 (host/nslookup/dig)：能不能解析（不测试本地/etc/hosts）
- FQDN = DOMAIN
- 包命：**bind-utils(dig)**
```
# dig -t A FQDN
>A: Address,主机名解析成IP
FQDN -> IP
# dig  -x  IP
>IP -> FQDN 反向解析
```

# iproute家族

- 包名：**iproute2**,与内核版本相应 `uname -r`

## ip命令：show / manipulate routing, devices, policy routing and tunnels

`ip [ OPTIONS ] OBJECT { COMMAND | help }`

- OBJECT := { link | addr | route | netns  }			
- 注意： OBJECT可简写，各OBJECT的子命令也可简写

### ip link：network device configuration

#### ip link show/list  - display device attributes

> pdisc(队列) pfifo_fast(队列类型，先进先出) qlen(队列长度)

link/ether，brd：都是不是IP地址

2成设备信息

```
# ip link show
# ip link list
# ip li li
```

#### ip link set - change device attributes

- dev NAME (default)：指明要管理的设备，dev关键字可省略
- up/down：# ip link set dev up/down 启用或禁用接口
- multicast on or multicast off：启用或禁用多播功能
- name NAME：重命名接口，先停止接口
- mtu NUMBER：设置MTU的大小，默认为1500
- netns PID：ns为namespace，用于将接口移动到指定的网络名称空间

```
# ip link set eth1 down
# ip link set eth1 netns mynet
```

#### ip link help - 显示简要使用帮助；

### ip netns：manage network namespaces.

- ip netns list：列出所有的netns
- ip netns add NAME：创建指定的netns
- ip netns del NAME：删除指定的netns
- ip netns exec NAME COMMAND：在指定的netns中运行命令

```
# ip netns add mynet
# ip link set eth1 netns mynet
# ip netns exec mynet ip link show
```

### ip address - protocol address management.

> ifconfig 可以查看，没有别名时不现实别名地址

- ip address show/list [IFACE] - 仅显示指定接口的地址
- ip address add IFADDR dev IFACE
  - [label NAME]：为额外添加的地址指明接口别名
  - [broadcast ADDRESS]：会根据IP和NETMASK自动计算得到
  - [scope SCOPE_VALUE]：
    - global：全局可用(与其他主机通信可以用)
    - link：接口可用(自己只能ping自己，不跟别人通信)
    - host：仅本机可用(外界不知道有这个接口地址)							
- ip address delete IFADDR dev IFACE 删除接口地址 
- ip address flush dev IFACE 清空接口的地址
`# ip address add 10.0.7.0/8 label eno33554984:1 dev eno33554984`

### ip route - routing table management

- ip route show TYPE PRFIX - list routes
- ip route get TYPE PREFIX - get a single route
- ip route add - add new route
- ip route change - change route
- ip route replace - change or add new one
- ip route delete - delete route
- ip route flush TYPE PREFIX - flush routing tables

`# ip route add TYPE PREFIX via GW [dev IFACE] [src SOURCE_IP]`

>via：nexthop

src: 一个接口中的多个地址当中选一个地址作为原地址

```
# ip route add 192.168.0.0/24 via 10.0.0.1 dev eth1 src  10.0.20.100
# ip route add default via GW
```

> 设置默认网关

```
# ip route delete 192.168.1.0/24
# ip route get 192.168.0.0/24
```

## ss命令

`ss [options] [ FILTER ]`

- Options：
  - -t：TCP协议的相关连接
  - -u：UDP相关的连接
  - -w：raw socket相关的连接
  - -l：监听状态的连接
  - -a：所有状态的连接
  - -n：数字格式
  - -p：相关的程序及其PID
  - -e：扩展格式信息
  - -m：内存用量
  - -o：计时器信息

- FILTER := [ state TCP-STATE ]  [ EXPRESSION ]

- TCP的常见状态：
  - TCP FSM：Finite State Machine，有限状态机
    - LISTEN：监听
    - ESTABLISEHD：建立的连接
    - SYN_SENT：
    - SYN_RECV：
    - FIN_WAIT_1：
    - FIN_WAIT_2：
    - CLOSED：

- EXPRESSION：
  - dport =
  - sport =

``` shell
# ss -tan '( dport = :22 or sport = :22  )'
# ss -tan state ESTABLISHED
```

dport: 客户端端口

sport: 服务器端端口

# 配置文件

> IP/NETMASK/GW/DNS等属性的配置文件：

## 路由的相关配置文件：

`/etc/sysconfig/networkj-scripts/route-IFACE`

## 接口配置文件：

`/etc/sysconfig/network-scripts/ifcfg-IFACE(接口名称)`

## 配置文件/etc/sysconfig/network-scripts/ifcfg-IFACE通过大量参数来定义接口的属性，其可通过vim等文本编辑器直接修改，使用专用的命令的进行修改

## CentOS 6

> system-config-network（system-config-network-tui包名）

`# setup`

## CentOS 7

`# nmtui`

## ifcfg-IFACE配置文件参数：

- NAME：此配置文件对应的设备的名称（CentOS 7）
- DEVICE：此配置文件对应的设备的名称（与ifcfg-IFACE保持一致）
- ONBOOT：在系统引导过程中，是否激活此接口
- UUID：此设备的惟一标识

- BOOTPROTO：激活此接口时使用什么协议来配置接口属性
  - 常用的有dhcp、bootp、sta tic、none
- TYPE：接口类型，常见的有Ethernet, Bridge

- DNS1：第一DNS服务器指向
- DNS2：备用DNS服务器指向
- DOMAIN：DNS搜索域

- IPADDR： IP地址
- NETMASK：子网掩码
- PREFIX: CentOS 7支持使用PREFIX以长度方式指明子网掩码
- GATEWAY：默认网关
- HWADDR：设备的MAC地址

- USERCTL：是否允许普通用户控制此设备

- PEERDNS：如果BOOTPROTO的值为“dhcp”，是否允许dhcp server分配的dns服务器指向覆盖本地手动指定的DNS服务器指向；默认为YES

- NM_CONTROLLED：是否使用NetworkManager服务来控制接口（CentOS 6）
  - YES：各种高级功能不能使用
  - NO：只有NetworkManager服务关闭

- IPV6INIT：是否初始化IPv6

- 网络服务：
  - network（常用）
  - NetworkManager (CentOS 6 不完善， CentOS 7 完善)

  - CentOS 6: `service SERVICE  {start|stop|restart|status}`
  - CentOS 7：`systemctl {start|stop|restart|status} SERVICE[.service]`

- 配置文件修改之后，要生效需要重启网络服务
  - CentOS 6：`# service network restart`
  - CentOS 7：`# systemctl restart network.service`

## 非默认网关路由：`/etc/sysconfig/network-scripts/route-IFACE`

- 支持两种配置方式，但不可混用；

1. 每行一个路由条目：route-IFACE

``` shell
TARGET  via GW
10.0.0.0/8 via 192.168.1.71
```

2. 每三行一个路由条目

``` shell
ADDRESS[0-9]=TARGET
NETMASK[0-9]=MASK
GATEWAY[0-9]=NEXTHOP
```

## 给接口配置多个地址

> ip addr之外，ifconfig或配置文件都可以

1. `ifconfig  IFACE_LABEL  IPADDR/NETMASK`

 IFACE_LABEL：eth0:0, eth0:1, ...		

2. 为别名添加配置文件；

DEVICE=IFACE_LABEL

BOOTPROTO：网上别名不支持动态获取地址；

只支持static, none

# nmcli命令：`nmcli  [ OPTIONS ] OBJECT { COMMAND | help }`	

> CentOS 7 专有命令：device - show and manage network interfaces

- COMMAND := { status | show | connect | disconnect | delete | wifi | wimax }
- connection - start, stop, and manage network connections
- COMMAND := { show | up | down | add | edit | modify | delete | reload | load }
- modify [ id | uuid | path ] <ID> [+|-]<setting>.<property> <value>

## 如何修改IP地址等属性：

`# nmcli  conn  modify  IFACE  [+|-]setting.property  value`

- ipv4.address
- ipv4.gateway
- ipv4.dns1
- ipv4.method
- manual

## wget 命令

`wget [options]... [URL]...`

- options:
  - -q: 静默模式
  - -c: 续传
  - -O: 保存位置
  - --limit-rates: 指定传输速率

## 博客作业：上述所有内容

> ifcfg, ip/ss，配置文件 

## 课外作业：nmap, ncat, tcpdump命令