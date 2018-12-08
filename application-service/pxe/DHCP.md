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

- DHCP: 动态主机配置协议
  - arp: address resolving protocol
    - ip -> mac
  - rarp: reverse arp
    - mac -> ip

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

21:58