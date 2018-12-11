# DHCP

- 把一个主机接入TCP/IP网络，要为配置哪些网络参数
  - IP/mask
  - Gateway
  - DNS Server
  - Wins Server, NTP Server
  - 参数配置方式
    - 静态指定
    - 动态分配
      - 早期：bottp: boot protocol
      - 后来：dhcp， 引入了“租约”的bootp；也可以实现为特定主机保留某固定地址

## DHCP: 动态主机配置协议 Dynamic Host Configuration Protocol

- 为局域网主机动态配置IP地址协议，是局域网的网络协议

- 使用 DHCP 协议工作，主要有两个用途：
  - 1.给内部网络或网络服务供应商自动分配IP地址，主机名，DNS服务器，域名
  - 2.配合其他服务，实现集成化管理功能。如：无人值守安装服务器

- arp: address resolving protocol
  - ip -> mac
- rarp: reverse arp
  - mac -> ip

- 监听的端口：
  - Server: 67/UDP
  - client: 68/UDP

## DHCP Features

- **C/S** 模式
- **自动分配**IP地址
- 不会同时**租借**相同的IP地址给两台主机
- DHCP管理员可以**约束**特定的计算机使用特定的IP地址
- 可以为每个DHCP**作用域**设置很多选项
- 客户机在不同**子网间移动时不需要重新设置IP地址。每次都自动获取 IP 地址就可以了
  - 在商城多层楼之间的局域网自动切换，WiFi不会覆盖那么多。

## DHCP 的去缺点

- 当网络上存在多服务器时，一个DHCP服务器不能查出已被其他服务器租出去的IP地址
- DHCP服务器不能跨路由器与客户机通信，除非路由器允许 BOOTP 协议转发
  - 不能跨路由器，DHCP中继可以跨路由器与其他局域网通信

- 两台DHCP服务器
  - Node1: 192.168.100-200
  - Node2: 192.168.1.160-180
  - 有冲突范围

  - 一台PC通过Node1获取IP 192.168.1.170
    - Node2不知道客户机从Node1获得了IP
  - 另一台PC通过 Node2 获取 IP 192.168.1.170
    - IP地址冲突

## DHCP 端口号

``` sh
# vim /etc/services
  bootps      BOOTP server: 68/tcp 68/udp
  bootpc      BOOTP client: 68/tcp 68/udp

```
DHCP 协议由 bootp 协议发展而来，是 BOOTP 的**增强版本**，**bootps** 代表服务端端口，**bootpc**代表客户端端口。

## bootp 协议

> 引导程序（BOOTP），它可以让误判工作站从一个中心服务器上获得IP地址，为局域网中无盘工作站分配动态IP地址，并不需要每个用户去设置静态IP地址。

- BOOTP缺点：在设定前须实现获得客户端的硬件地址，而且，**MAC 地址与IP的对应是静态的**。换而言之，BOOTP 非常缺乏“动态性”，若在有限的IP资源环境中，BOOTP的一对对应会造成非常可观的浪费。
  - 大型商场无线网覆盖，逛街时连接无线WiFi并获取动态IP地址，但是你在商场待多久（待几个小时）。你离开了，但是你的设备MAC地址与WiFi无线IP地址绑定且不能给其他用户使用。

- DHCP 是 BOOTP 的**增强版本**，它分为两个部分：一个是服务器端，而另一个客户端。**所有的IP网络设定数据都由 DHCP 服务器集中管理**，并**负责处理客户端的 DHCP 要求**；而客户端则会使用从服务器分配下来的IP环境数据。比较 BOOTP, DHCP 透过“**租约**”的概念，有效且动态的分配客户端的 TCP/IP设定，而且，作为兼容考虑，DHCP也完全照顾了 BOOTP Client 的需求。

## DHCP 工作原理

- DHCP 服务运行原理
  - DHCP 客户端向服务端请求过程

![DHCP 工作原理](./images/dhcp-flow.png)

![DHCP 工作原理](./images/dhcp-flow2.png)

注意：客户端执行 DHCP DISCOVER 后，如果没有 DHCP 服务器响应客户端的请求，客户端会使用 169.254.0.0/16 网段中的一个IP 地址配置本机地址。

169.254.0.0/16 是 Windows 的自动专有IP寻址范围，也就是在无法通过、DHCP获取IP地址时，由系统自动分配的 IP 地址段。

``` sh
# route -n
```

## 工作流程

1. client: dhcp discover
2. Server: dhcp offer(IP/mask, gw, ...) lease time(租约期限)
3. Client: dhcp request
4. Server: dhcp ack

- 续租(50%)：整个租约一般的时候续租
  - 单播给服务器:
    - dhcp request
    - dhcp ack

    - dhcp request
    - dhcp nak(不给租了，服务器地址列表可能改了)

    - dhcp discover(找其他房子)：广播

## CentOS

- dhcp(ISC, named)
- dnsmasq: dhcp & dns

- dhcp:
  - dhcpd: dhcp 服务
  - dhcrelay: 中间服务

- 192.18.100.6

``` sh
# yum info dhcp
# yum -y install dhcp
# rpm -ql dhcp
  /usr/sbin/dhcpd
  /usr/sbin/dhcrelay

启动服务
# vim /etc/dhcp/dhcpd.conf
# cp /usr/share/doc/dhcp-4.2.5/dhcpd.conf.example ./dhcpd.conf -f
# vim dpchd.conf
  域名
  option domain-name "wovert.com";

  网管配置
  option routers 182.18.100.6;

  dns 服务器
  option domain-name-servers 172.18.0.1;
  
  默认租约期限
  default-lease-time 43200; 单位：秒

  最大租约期限
  max-lease-time 86400;

  subnet 172.18.0.0 netmask 255.255.0.0 {
    range 172.18.100.101 172.18.100.120;
  };

  动态分配地址

# systemctl start dhcpd.service
# ss -unl

```

- 虚拟主机更改网络连接位 hostonly

``` sh
RS1主机
# ss -tunl
 *:68
# dhclient -h

 运行前台
# dhclient -d
# dhclient -d

```

``` sh
# vim /etc/dhcp/dpchd.conf
  range 172.18.100.121 172.18.100.138
# systemctl restart dhcpd.service
```

``` sh
RS1主机
# dhclient -d
# dhclient -d
# route -n
# nmtui
 删除IP，网管
# systemctl restart network.service

```

## 实验环境

- 服务端: server.cn IP: 192.168.1.63
- 客户单：client.cn IP: 192.168.1.64

