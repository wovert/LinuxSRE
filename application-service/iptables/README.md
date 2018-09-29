# iptables服务

## Firewall(防火墙):隔离工具

- 网络防火墙(类似网关)
- 主机防火墙（本机的防火墙）

- 工作于网络或主机边缘（通信报文的进出口），对于进出本网络或主机的报文根据事先定义的检查规则作匹配检测，对于能够被规则匹配到的报文做出相应处理(有条件的访问、拒绝等)

## 防火墙

- 硬件：硬件和软件逻辑，NetScreen, CheckPoint, ...
- 软件：软件逻辑

- 本机：ip,port,protocol
- 网关：本机接受，网络转发

- 资源子网（用户空间）、应用程序(httpd)
- 通信子网（内核空间）

- 流入缓冲区，流出缓冲区
- 转发：接口进来，另外一个接口发送，不会到本机

## iptables历史演变

- ipfw --> ipchains -> iptables

## iptables/netfilter

- iptables/netfilter
  - netfilter：报文流向 kernel（钩子），编译内核服务安装
    - hook function(钩子)，报文流经的卡点（prerouting, input,output,）
  - iptables可以向每个钩子写上rules（规则）
    - rules utility 规则效应
- `iptables`: cli interface 命令行客户端程序
  - 规则（链->列，表）, IPv4支持， 客户端程序，rpm包,cli接口

## netfilter(内核里叫法)

- prerouting：刚到本机网卡->prerouting->内核缓冲队列中->路由之前
- input：路由到达之后到本机内部->input->输入队列
- forward：到本机，没有到达本机内部而转发队列
- output：有本机内部发出的，输出队列
- postrouting：即将离开的网卡上（缓冲队列中->路由后->postrouting->网络接口）

## 报文流向

- 流入本机：prerouting -> input ==> 用户空间进程
- 流出本机：用户空间进程 -> output -> postrouting
- 转发：prerouting->forward->postrouting

## iptables里叫chains

1. 网络数据报文到达网卡接口，通过内核数据报文保存到内存中（缓冲区）
2. 从内存中读取一个报文拆包处理，并分析报文的目标IP，拆首部，查看端口号到底是哪个进程执行

## 功能：table

- raw：关闭在nat表启用的**连接追踪机制**
  - 管哪种协议，此前会话某一个报文请求方向和响应方向有关联关系)，
  - 保安：出入证，第一次临时令牌，第二次直接查看令牌不用检查。依次类推...
- mangle：拆解报文，按需修改（**不包括修改IP地址**）
- nat：network address translation，网络地址转换（**修改IP层地址，传输层port地址**）
- filter：过滤，防火墙
- 注意：每个netfilter对应一个表，每个表都有不同的

## iptables

- 内置链：默认，不能删除，内置链与钩子意义对应
  - PREROUTING
  - INPUT
  - FORWARD
  - OUTPUT
  - POSTROUTING

- 自定义链
  - 手动添加
  - 附加在钩子上才有效果

## 功能 表<==>链 位置

- filter：INPUT, FORWARD, OUTPUT
- mangle：PREROUTING, INPUT, FORWARD, OUTPUT, POSTROUTING (ALL)
- nat：PREROUTING, INPUT(CentOS 7), OUPTUT, POSTROUTING
- raw：PREROUTING, OUTPUT

## 同一个链上的不同的表的规则的应用优先级（高-->低）：

RoMNiF

- raw 令牌(连接追踪，之前请求报文与之后请求报文有没有关联关系)
- mangle 修改报文
- nat 修改IP:port
- filter 过滤

- PREROUTING: raw, mangle, nat
- INPUT: mangle, nat(CentOS 7), filter
- FORWARD: mangle, filter
- OUTPUT: raw, mangle, nat, filter  (ALL)
- POSTROUTING: mangle, nat

## 数据包过滤匹配流程

路由功能发生的时刻：

1. 报文进入本机后：判断目标主机是否为本机？；是：INPUT；否：FORWARD
2. 报文离开本机之前：判断经由哪一个接口送往下一跳？**所有添加规则都在运行中的内核（内存），系统关机之后不存在** 解决：脚本文件启动所有规则

## 规则

- 组成部分：根据规则**匹配条件**阐释匹配报文，对匹配成功的报文根据规则定义的**处理动作**做出处理；

### 匹配条件：`&, |, !`

- 基本匹配
- 扩展匹配

### 处理动作(target)

- 基本处理动作
- 扩展处理动作
- 自定义处理动作

## 链

- 内置链：对应于一个钩子函数
- 自定义链：用于对内置链进行补充或扩展，可实现更灵活的规则组织管理机制

## 添加规则时的考量

1. 要实现何种**功能**：判断添加规则至哪个表上
2. 报文流经的**位置**：判断添加规则至哪个链上

## 链：链上的规则次序，即为检查的次序；因此，隐含一定的应用法则：

1. 同类规则（访问同一应用），匹配范围小的放上面
2. 不同类的规则（访问不同应用），匹配到报文频率较大的放在上面
3. 将那些可由一条规则描述的多个规则合并起来
4. 设置默认策略

## IP Header, MTU: 1500 bytes

- 第一行：
  - IP Version(4 bits)
  - Header Length(4 bits [x4])
  - Type of Server(TOS：服务类型, 8 bits)
  - Total Length(16 bits [65535-60=65475]，包括Data)
- 第二行：
  - Identification (Fragmen ID, 16 bits)
  - R(return) DF(Don't fragment) MF(More fragment)    3 bits
  - Fragment Offset （13 bits，片偏移量）
- 第三行：
  - Time-To-Live(TTL), 8 bits (下一跳减掉1)， 0时丢包
  - Protocol, 8 bits （TCP：6， UDP：17）
  - Header Checksum (首部校验码 16 bits)
- 第四行: Soure IP Address (32bits)
- 第五行: Destination IP Address (32bits)
- 第六行: Options
  - if any, variable length, paddded with 0, 40 bytes max length)

## TCP Header

- 第一行：
  - Source Port Number (16 bits)
  - Destination Port Number (16 bits)
- 第二行：
  - Sequence Number (32 bits)
- 第三行：
  - Acknowledgement Number (32 bits)
- 第四行：
  - Header Lenght(4 bits)
  - Reserverd (6 bits)
  - URG ACK PSH RST SYN FIN
  - Window Size (16 bits)
- 第四行：
  - TCP Checksum (16 bits)
  - Urgent Pointer (16 bits)
- 第四行：
  - Options: if any, variable length, padded with O's)
- 第四行：
  - Data (if any)
  - Acknowledgement Number (32 bits)

## CentOS 7: firewalld

``` shell
# systemctl stop firewalld.service
# systemctl disable firewalld.service
```

## CentOS 6: firewalld

``` shell
# service iptables stop
# chkconfig iptables off

命令格式：iptables [-t table] SUBCOMMAND chain [matches...] [target]
iptables [-t table] {-A|-C|-D} chain rule-specification
iptables [-t table] -I chain [rulenum] rule-specification
iptables [-t table] -R chain rulenum rule-specification
iptables [-t table] -D chain rulenum
iptables [-t table] -S [chain [rulenum]]
iptables [-t table] {-F|-L|-Z} [chain [rulenum]] [options...]
iptables [-t table] -N chain
iptables [-t table] -X  [chain]
iptables [-t table] -P chain target
iptables [-t table] -E old-chain-name new-chain-name
rule-specification = [matches...]  [target]
match = -m matchname [per-match-options]
target = -j targetname [per-target-options]
```

## iptable 命令格式

`iptables [-t table] SUBCOMMAND chain [-m matchname [per-match-options]] -j targetname [per-target-options]`

### -t table

- raw, mangle, nat, 默认filter

### SUBCOMMAND：

- 链管理：
  - `-N`：new，新增一条自定义链
  - `-X`：delete，删除自定义的空链
  - `-P`：policy，设置链的默认策略
    - `ACCEPT`：接受
    - `DROP`：丢弃（建议使用丢弃，不使用reject）
    - `REJECT`：拒绝（有反馈，占用带宽）
  - `-E`：rename，重命名自定义的未被引用（引用计数为0）的chain
  - `-F`：清空规则

- 查看：
  - `-L`：列出规则
    - `-n`：numeric，以数字格式显示地址和端口
    - `-v`：verbose，详细信息；-vv, -vvv
    - `-x`：exactly，显示计数器的精确值而非单位换算后的结果;报文个数/报文体积大小
    - `--line-numbers`：显示链上的规则的编号（编号用于删除和修改）
  - `-nvL`：固定顺序，L不能放在第一个

### 新建自定义链

``` shell
# iptables -N testchain
# iptables -nL
  Chain testchain (0 **references**) 引用计数
  target prot opt source			destination
```

### 重命名，references必须是0

``` shell
# iptables -E testchain mychain
```

### 删除空链

``` shell
# iptables -X mychain
```

### forward链转发丢弃

``` shell
# iptables -t filter -P INPUT DROP
# iptables -t filter -P OUTPUT DROP
# iptables -t filter -P FORWARD DROP
定时任务：清空所有链，重新配置
```

### 规则管理

``` shell
-A: append，追加，默认为最后一个
-I：insert, 插入，默认为第一个
-D：delete, 删除
(1) rule specification
(2) rule number
  --line-numbers

-R：replace，替换
(1) rule specification
(2) rule number
  --line-numbers

-F：flush，清洗
-L：list
-Z：zero，置0

iptables的每条规则都有两个计数器：
(1)有本规则匹配到的所有的packets
(2)有本规则匹配到的所有的bytes；
-S：selected, 以iptables-save命令的格式显示链上的规则，显示指定chain上的所有规则
```

### 命令行格式显示：命令格式导出链上的规则

``` shell
# iptables-save 保存输出重定向命令
```

``` shell
# iptables -nL INPUT
# iptables -vnxL --line-numbers
  X packest, X bytes
  num pkts byts target prot opt in out source destination
# iptables -S INPUT
  -P INPUT DROP
```

### 匹配条件

#### 基本匹配：netfilter自带的匹配规则

``` shell
# rpm -ql iptables
小写.so => matches匹配条件扩展
大写.so => target匹配条件扩展

[!] -s, --source address[/mask][,...]：源地址匹配[非]
[!] -d, --destination address[/mask][,...]：目标地址匹配[非]
[!] -i, --in-interface name：限制数据报文流入的接口
**只能用于PREROUTING,INPUT,FORWARD**
[!] -o, --out-interface name：限制数据报文流处的接口
**只能用于OUTPUT,FORWARD,POSTROUTING**

# iptables -A INPUT -s 192.168.0.0/16 -j ACCEPT
# iptables -A OUPUT -d 192.168.0.0./16 -j ACCEPT
# iptables -nvL

测试ping
# iptables -A INPUT -s 172.168.200.2 -d 172.18.100.6 -j ACCEPT
# iptables -A OUTPUT -d 172.168.200.2 -s 172.18.100.6 -j ACCEPT
# iptables -A INPUT ! -s 172.168.200.2 -d 172.18.100.6 -j ACCEPT

# rpm -ql iptables
# man iptables-extension

三次握手:
  C->S : syn=1,act=0,fin=0,rst=0
  S->C : syn=1,act=1,fin=0,rst=0
  C->S : syn=0,act=1,fin=0,rst=0

四次断开：
  C->S : syn=0,act=1,fin=1,rst=0
  S->C : syn=0,act=1,fin=0,rst=0
  S->C : syn=0,act=0,fin=1,rst=0
  C->S : syn=0,act=1,fin=0,rst=0
```

#### 扩展匹配：经由扩展模块引入的匹配机制，-m matchname

``` shell
显示扩展：需要加载扩展模块，必须由-m加载相应模块
隐式扩展：可以不用使用-m选项加载相应模块；前提是要使用-p选项匹配协议

protocol：tcp, udp, icmp, icmpv6, esp, ah, sctp, mh or "all"
tcp: 隐含指明了-m加载模块，"-m tcp"，有专用选项

[!]-p, --protocol PROTOCOL PROTOCOL {tcp|udp|icmp}：限制协议
[!] --source-port, --sport port[:port]：匹配报文中的tcp首部的源端口；可以是端口范围
[!] --destination-port, --dport port[:port]：匹配报文中的tcp首部的目标端口；可以是端口范围；

[!] --tcp-flags mask comp：检查报文中mask指明的tcp标志位,而要这些标志位comp中必须为1
--tcp-flags syn,fin,ack,rst syn (syn为1，其他的都0)
--tcp-flags syn,fin,ack,rst ack,fin (ask，fin为1，其他的都0)

[!] --syn: 相当于"--tcp-flags syn,fin,ack,rst syn"；tcp三次握手的第一次

udp: 隐含指明了-m加载模块，"-m udp"，有专用选项
  [!] --source-port, --sport port[:port]：匹配报文中的udp首部的源端口；可以是端口范围；
  [!] --destination-port, --dport port[:port]：匹配报文中的udp首部的目标端口；可以是端口范围；

icmp: 隐含指明了-m加载模块，"-m icmp"，有专用选项
  [!] --icmp-type {type[/code]|typename}

  type/code
    0/0：echo reply，回显应答
    8/0：echo request, 请求显应

# yum -y install httpd telnet-socket
# systemctl start httpd.service
# vim /var/www/html/index.html
# systemctl start telnet.socket
# ss -tnl

己ping别人可以，别人不能ping我
# iptables -A OUTPUT -s 本机IP -d 0/0 -p icmp -icmp-type 8 -j ACCEPT
# iptables -A INPUT -d 本机IP -s 0/0 -p icmp -icmp-type 0 -j ACCEPT

[root@Test ~]# iptables -t filter -A INPUT -s 0/0 -d 172.16.0.3 -p icmp --icmp-type 8 -j ACCEPT
[root@Test ~]# iptables -t filter -A OUTPUT -d 0/0 -s 172.16.0.3 -p icmp --icmp-type 0 -j ACCEPT

[root@Test ~]# iptables -t filter -A INPUT -s 0/0 -d 172.16.0.3 -p icmp --icmp-type 8 -j ACCEPT
[root@Test ~]# iptables -t filter -A OUTPUT -d 0/0 -s 172.16.0.3 -p icmp --icmp-type 0 -j ACCEPT

Chain INPUT (policy DROP 0 packets, 0 bytes)
num      pkts      bytes target     prot opt in     out     source               destination
1        2874   218050 ACCEPT     tcp  --  *      *       0.0.0.0/0            172.16.0.3           tcp dpt:22
2          30     2107 ACCEPT     tcp  --  *      *       0.0.0.0/0            172.16.0.3           tcp dpt:80
3           8      672 ACCEPT     icmp --  *      *       0.0.0.0/0            172.16.0.3           icmptype 0
4           0        0 ACCEPT     icmp --  *      *       0.0.0.0/0            172.16.0.3           icmptype 8

Chain OUTPUT (policy DROP 3 packets, 180 bytes)
num      pkts      bytes target     prot opt in     out     source               destination
1        1881   198418 ACCEPT     tcp  --  *      *       172.16.0.3           0.0.0.0/0            tcp spt:22
2          13     1483 ACCEPT     tcp  --  *      *       172.16.0.3           0.0.0.0/0            tcp spt:80
3          10      840 ACCEPT     icmp --  *      *       172.16.0.3           0.0.0.0/0            icmptype 8
4           0        0 ACCEPT     icmp --  *      *       172.16.0.3           0.0.0.0/0            icmptype 0


# iptables -A INPUT -s 192.168.0.61 -d 192.168.0.71 -p tcp -j ACCEPT
# iptables -A OUTPUT -d 192.168.0.61 -s 192.168.0.71 -p tcp -j ACCEPT

# yum -y install httpd vsftpd telent-server samba
# iptables -A INPUT -s 0/0 -d 192.168.0.71 -p tcp --dport 22 -j ACCEPT
# iptables -nvL | less
# iptables -A OUTPUT -s 192.168.0.71 -d 0/0 -p tcp --sport 22 -j ACCEPT
# iptables -nvL | less
# iptables -P INPUT DROP
# iptables -P OUTPUT DROP
访问
主机：192.168.0.71
客户端：192.168.0.61
协议：ssh
```

## 处理动作

``` shell
-j targetname [per-target-options]`
  ACCEPT, DROP, REJECT
  RETURN：返回调用的链
  REDIRECT：端口重定向
  LOG：日志
  MARK：防火墙标记
  DNAT：目标地址转换
  SNAT：源地址转换
  MASQERADE：地址伪装
```

## 显示扩展

``` shell

multiport：多端口匹配(max:15, tcp, dup,udplite,dccp, sctp等)
以离散方式定义多端口匹配，最多可以指定**15个端口(离散值)**
  [!] --source-ports, --sports port[,port | , port:port] ...
  [!] --destination-ports, --dports port[,port | , port:port] ... 
  [!] --ports port[,port|,port:port]...

# iptables -I INPUT -s 0/0 -d IP -p tcp -m multiport --dports 22,80 -j ACCEPT
# iptables -I OUTPUT -d 0/0 -s IP -p tcp -m multiport --sports 22,80 -j ACCEPT
# iptables -D INPUT 2
# iptables -D INPUT 2

iprange: 指明一段连续的IP地址范围作为源地址或目标地址
  [!] --src-range from[-to]：源地址范围
  [!] --dst-range from[-to]：目标地址范围

# iptables -A INPUT -d 192.168.0.71 -p tcp --dport 23 -m iprange --src-range 192.168.0.30-192.168.0.60 -j ACCEPT
# iptables -A OUTPUT -s 192.168.0.71 -p tcp --sport 23 -m iprange --dst-range 192.168.0.30-192.168.0.60 -j ACCEPT

string: 对报文中的应用层数据做字符串匹配检测：Linux kernel 2.6.14 >=
  --algo {bm|kmp}
    Boyer-Moore, Knuth-Pratt-Morris
  [!] --string pattern：给定要检查的字符串模式
  [!] --hex-string pattern：(16进制)给定要检查的字符串模式(文本编码成16进制格式)
  --from offset 指定位置开始匹配
  --to offset 指定位置开始匹配

# iptables -I OUTPUT -s 192.168.1.71 -d 0/0 -p tcp --sport 80 -m string --algo bm --string "old" -j REJECT

time: 根据收到报文的时间/日期与指定的时间/日期范围进行匹配
  --datestart YYYY[-MM[-DD[Thh[:mm[:ss]]]]]：起始日期时间
  --datestop YYYY[-MM[-DD[Thh[:mm[:ss]]]]]：结束日期时间

  --timestart hh:mm[:ss] 起始时间
  --timestop hh:mm[:ss] 结束时间

  [!] --monthdays day[,day...] 匹配一个月中的哪些天
  [!] --weekdays day[,day...]：匹配一周中的哪些天

telnet非工作期间不能访问
# iptables -R INPUT 4 -d 192.168.1.71 -p tcp -dport 23 -m iprange --src-range 192.168.1.50-192.168.1.62 -m time --timestart 09:00:00 --timestop 18:00:00 --weekdays 1,2,3,4,5 -j ACCEPT

connlimit: 根据每客户端主机连接服务器并发连接数限制，即每客户端最多可以发起的连接数量
  --connlimit-upto n：连接数量小于等于n则匹配 ACCEPT
  --connlimit-above n：连接数量大于n则匹配 REJECT

# iptables -A INPUT -s 0/0 -d 192.168.1.71 -p tcp --dport 23 -m connlimit --connlimit-utp 2 -j ACCEPT

limit: 基于令牌桶算法对报文的速率做匹配（限时游戏，令牌统算）
  9个游戏机，每5分钟每台及其占用一人
  令牌库：9个令牌
  令牌桶算法是网络流量整形（Traffic Shaping）和速率限制（Rate Limiting）中最常使用的一种算法
  控制发送到网络上的数据的数目，并允许突发数据的发送
  --limit rate[/second|/minute|/hours|/day]
  --limit-burst n：第一次使用几个

192.168.1.71主机
# iptables -A INPUT -d 192.168.1.71 -p icmp --icmp-type 8 -m limit --limit 20/minute --limit-burst 3 -j ACCEPT
# iptables -A OUTPUT -s 192.168.1.71 -p icmp --icmp-type 0 -j ACCEPT

state: 是conntract模块的子集，用于对报文的状态连接追踪（与协议没有关系）
  [!] --state STATE
  INVALID：无法识别的连接（内容不一致），非法连接
  ESTABLISHED：连接追踪模版当中存在记录的连接，超时之前都此状态
  NEW：连接追踪模版当中不存在的连接请求,第一次请求
  RELATED：相关联的连接, ftp(21,20)
  UNTRACKED：未追踪的连接，追踪连接关掉,raw

防火墙默认不认识连接追踪机制

已经追踪到的并记录下来的连接：
# cat /proc/net/nf_contract
  nf: netfilter

连接追踪功能能够记录的最大连接数量（可调整）
# cat /pro/sys/net/nf_contract_max

修改连接追踪机制修改最大值: 
# sysctl -w net.nf_contract_max=300000
# echo 300000 > /proc/sys/net/nf_contract_max

conntract所能够追踪的连接数量的最大值取决于/proc/sys/net/nf_conntract_max的设定；已经追踪到的并记录下来的连接位于/proc/net/nf_conntract文件中，超时的连接将会被删除；当模版满载时，后续的新连接有可能会超时；
解决办法：

(1) 加大nf_conntract_max的值；
(2) 降低nf_conntract条目的超时时长；
不同协议的连接追踪超时时长：`/proc/sys/net/netfilter`
`nf_conntract_tcp_timeout_close`
`nf_conntract_tcp_timeout_close_wait`
`nf_conntract_tcp_timeout_established`

连接追踪：任何一个主机与本机通信，本机内核记录了src:port,dst:port使用什么协议什么时间连接并保存在内存缓冲区中。连接会话表（每条记录都有倒计时）=》追踪机制

什么情况不应该开启追踪功能？
**负载均衡（虽安全特性，不妥当）**

input,ouput => drop

# iptables -A INPUT -s 192.168.0.0/16 -d 192.168.1.71 -p tcp -m multiport --dports 22,23,80 -m state --state NEW,ESTABLISHED -j ACCEPT

# iptables -A OUTPUT -s 192.168.1.71 -d 192.168.0.0/16 -p tcp -m multiport --sports 22,23,80 -m state --state ESTABLISHED -j ACCEPT

# iptables -A INPUT -d 192.168.1.71 -p icmp --icmp-type 8 -m state --state NEW,ESTABLISEHD -j ACCEPT

# iptables -A OUTPUT -s 192.168.1.71 -p imcp -icmp-type 0 -m state --state ESTABLISHED -j ACCEPT

最早的匹配多的规则，尽可能放在前面
```

### 规则的检查次序：规则在链接上的次序即为其检查的生效次序；

因此，其优化使用有一定法则；
1. 同类规则（访问同一应用），匹配范围小的放前面；用于特殊处理；
2. 不同类的规则（访问不同应用），匹配范围大的放前面；http, ssh
3. 应将将那些可由一条规则描述的的多个规则合并为一；端口范围,地址范围
4. 设置默认策略

``` shell
# iptables -A INPUT -m state --state ESTABLISHED -j ACCEPT
# iptables -A INPUT -d 本机 -p tcp -m multiport --dports 22,23,80 -m state --state NEW -j ACCEPT
# iptables -A INPUT -d 本机 -p icmp --icmp-type 8 -m state --state NEW -j ACCEPT
# iptables -A OUTPUT -m state --state ESTABLISHED -j ACCEPT
# watch -n1 `iptables -vnL

数据连接RELATED
```

### 如何放行被动模式的ftp服务？

1) 内核加载nf_conntrack_ftp模块，才能装载RELATED连接 

``` shell
# modprobe nf_conntrack_ftp`
```

2) 放行命令连接

``` shell
# iptables -A INPUT -d $sip -p tcp --dport 21 -m state --state NEW,ESTABLISHED -j ACCEPT`
# iptables -A OUTPUT -s $sip -p tcp --sport 21 -m state --state ESTABLISHED -j ACCEPT
```

3) 放行数据连接

``` shell
# iptables -A INPUT -d $sip -p tcp -m state --state RELATED,ESTABLISHED -j ACCEPT`
# iptables -A OUTPUT -s $sip -p tcp -m state --state ESTABLISHED -j ACCEPT

# modinfo nf_conntrack_ftp
# lsmod
# modprobe nf_conntrack_ftp` 装载nf_conntrack_ftp
# lsmod | grep ftp

# systemctl start vsftpd.service
# ss -tnl
# iptables -A INPUT -d 本机IP -m state --state RELATED,ESTABLISHED -j ACCEPT
# iptables -A INPUT -d 本机IP -p tcp -m multiport --dports 22,23,80.21 -m state --state NEW -j ACCEPT

# iptables -A OUTPUT -s 本机IP -m state --state ESTABLISHED -j ACCEPT
```

规则的有效期限：iptables命令添加的规则，手动删除之前，其生效期限为kernel的生命周期

## 保存规则：

### CentOS 6: 三种方法

``` shell
# service iptables save`
# iptables-save > /etc/sysconfig/iptables
# iptables-save > /PATH/TO/SOME_RULE_FILE
```

### CentOS 7: 两种方法

``` shell
# iptables -S > /PATH/TO/SOME_RULE_FILE
# iptables-save > /PATH/TO/SOME_RULE_FILE
```

重载预存的规则：`# iptables-restore < /PATH/FROM/SOME_RULE_FILE`

CentOS 6：`# service iptables restart`
会自动从`/etc/sysconfig/iptables`文件中重载规则

### 自动生效的规则文件中规则：

1. 把iptables命令放在脚本文件中，让脚本文件开机自动运行
`/etc/rc.local`
	/usr/bin/iptables.sh （都是命令）

2. 用规则文件保存规则，开机自动重载命令

``` shell
# vim /etc/rc.d/rc.local
iptables-restore < /PAHT/TO/SOME_FULE_FILE(都是规则)

# cd /etc/sysconfig/network-scripts/
# nmtui
```

练习：INPUT和OUTPUT默认均为DROP

- 网络防火墙：forward
- 主机防火墙：input, output
- fireworks: output限制

## nmtui

- Profile name
- IPv4 Manual
- Gateway
- srestart network
- route -n

10.0.1.20 -> (10.0.1.1, 172.18.100.6) -> 172.18.100.61

- 内网主机1：新增网卡vmnet2(Host-only)
  - IP：10.0.1.20/24
  - GATEWAY: 10.0.1.1
  -ping 10.0.1.1 【可以】
  -ping 192.168.1.71 【可以】因为本机网关指向的主机的所有地址都可以ping通，没有指向网关10.0.1.1，那就不能ping通
  -ping 192.168.1.61 （内网主机2启用ip_forword转发功就能ping通）

- 内网主机2（连接外网）: 新增网卡vmnet2(Host-only)
  - 内网地址：
  - IP/MASK：10.0.1.1/24

- 外网地址：192.168.1.71/24
- 查看ip_forward转发功能

``` shell
# cat /proc/sys/net/ipv4/ip_forward
# echo 1 > /proc/sys/net/ipv4/ip_forward 启用转发功能
# iptables -P FORWARD DROP
# iptables -A FORWARD -m state --state ESTABLISHED -j ACCEPT
# iptables -A FORWARD -s 10.0.1.0/24 -p icmp --icmp-type 8 -m state --state NEW -j ACCEPT
# iptables -A FORWARD -s 0/0 -d 10.0.1.0/24 -p icmp --icmp-type 0 -j ACCEPT
```

外网-内网ping连接响应？

外网主机3：

IP：192.168.1.61/24

``` shell
# tcpdump -i eth0 -nn icmp (监听icmp发包信息)
# route add -net 10.0.1.0/24 gw 192.168.1.71	添加路由
```

- http访问？

- CentOS 保存 iptables

``` shell
# service iptables save
# chkconfig iptables on
```

## 处理动作详解

- ACCEPT/DROP/REJECT/
- LOG
- RETURN
- REDIRECT
- MARK
- DNAT
- SNAT
- MASQUERADE

### LOG：报文日志功能，放置在第一行

--log-level {emerg|alert|crit|error|warning|notice|info|debug}
  默认级别4
--log-prefix PREFIX：最多不能超过29个字节

``` shell
# iptables -I FORWARD 2 -s 10.0.1.0/24 -p tcp -m multiport --dports 80,21,22,23 -m state --state NEW -j LOG --log-prefix "(new connections: )"
# cat /var/log/messages
```

### RETURN：返回调用者；默认

``` shell
# iptables -F

web自定义链
# iptables -N web
# iptables -A web -s 10.0.1.0/24 -p tcp --dport 80 -j ACCEPT
# iptables -I web 1 -m string --algo kmp --string "old" -j REJECT
# iptables -I web 2 -p tcp -m state --state ESTABLISHED -j ACCEPT
# iptables -L -n

# iptables -A FORWARD -p tcp -j web
# iptables -L -n
  1 references
# iptables -A web -j RETURN` 返回调用者，默认隐含返回调用者
```

### REDIRECT：端口重定向，端口映射

``` shell
--to-ports port
80 => 8080，必须在prerouting设置
ip: 192.168.1.61
# iptables -t nat -A PREROUTING -d 192.168.1.61 -p tcp --dport 80 -j REDIRECT --to-ports 8080
```

## NAT

> Network Address Translation, 网络地址转换

- 目的：安全
- 必须使用连接追踪机制

### SNAT：source NAT

- 修改IP报文中的源地址
- POSTROUTING

- 让本地网络中的主机可使用统一地址与外部通信，从而实现地址伪装。
  - 请求：有内网主机发起，修改源IP，如果修改则由管理员定义；
  - 响应：修改目标IP，由nat自动根据会话表中追踪机制实现响应修改；

``` shell
--to--source [ipaddr[-ipaddr]][:port[-port]]
--random 端口随机

# iptables -t filter -F
# iptables -t nat -A POSTROUTING -s 10.0.1.0/24 -j SNAT --to-source 192.168.1.71-192.168.1.80(随机选择源地址转换)
# iptables -t filter -A FORWARD -s 10.0.1.0/24 -p tcp --dport 22 -j REJECT
```

### DNAT：destination NAT

- 修改IP报文中的目标IP地址

- PREROUTING, OUTPUT

- 让本地网络中服务器使用统一的地址向外提供地址（发布服务），但隐藏了自己的真实地址；
  - 请求：由外网主机发起，修改其目标地址，有管理员定义
  - 响应：修改源地址，但由nat自动根据会话表中的追踪机制实现对应修改；

可以同时转换目标端口，REDIRECT

--to-destination [ipaddr[-ipaddr]][:port[-port]]

端口映射

``` shell
# iptbles -t nat -A PREROUTING -s 0/0 -p tcp -dport 80 -j DNAT --to-destination 10.0.1.1.20:8080
# tcpdump -i interface -nn tcp port 8080
```

### PNAT：port NAT，端口转换

- redirect，可以同时修改目标地址和目标端口

## MASQUERADE

- POSTROUTING

- 源地址转换为DHCP（动态IP地址）

`# iptables -t nat -A POSTROUTING -s 10.0.1.0/24 -j MASQUEARDE`

- recent模块：本机访问速率限制

## 第三方模块：

- layer7：识别大多数应用层协议，例如http、qq等协议；
- 博客作业：以上所有内容