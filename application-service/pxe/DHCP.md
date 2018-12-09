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

## DHCP: 动态主机配置协议

- arp: address resolving protocol
  - ip -> mac
- rarp: reverse arp
  - mac -> ip

- 监听的端口：
  - Server: 67/UDP
  - client: 68/UDP

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