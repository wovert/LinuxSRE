# web service

## IANA

0-1023: 众所周知，永久的分给给固定的应用使用，特权端口；

1024-41951：注册端口，要求不是特别严格，分配给程序注册为某应用使用；3306/tcp, 11211/tcp;

41952+: 客户端程序随机使用的端口，动态端口，或私有端口；其范围定义在 `/proc/sys/ipv4/ip_local_prot_range`

## BSD socket

> IPC 一种实现，允许位于不同主机（也可以是同一主机）上的进程之间进行通信

- Socket API(封装了内核中 socket 通信相关的系统调用)
  - SOCK_STREAM: tcp 套接字
  - SOCK_DGRAM: UDP 套接字
  - SOCK_RAW: raw 套接字

- 根据套接字所使用的地址格式, Socket Domain
  - **AF_INET**: Address Family, IPv4
  - **AF_INET6**: ipv6
  - **AF_UNIX**: **同一主机上的不同进程间**基于 socket 套接字通信使用的一种地址；`Unix_SOCK`

- TCP 协议的特性
  - 建立连接：三次握手
  - 将数据打包成段：校验和(CRC32)
  - 确认、重传及超时
  - 排序：数据报文排序
  - 流量控制：滑动窗口算法
  - 拥塞控制：慢启动和拥塞避免算法

- TCP FSM(tcp有限状态机)
  - CLOSED
  - LISTEN
  - SYN_SENT
  - SYN_RECV
  - ESTABLISHED
  - FIN_WAIT1
  - CLOSE_WAIT
  - FIN_WAIT2
  - LAST_ACK
  - TIMEWAIT
  - CLOSED