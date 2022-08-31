# 学习环境

- VNC: Virtual Network Computing 协议
  - TigerNVC, RealVNC
  - vncviewer: client
  - vncserver: server
    - options - Display(Scale to window size)
- 内网网络地址：172.16.0.0/16
- Windows: 172.16.250.[1-254]
- Linux: 172.16.249.[1-254]
- 网关：172.16.0.1
- DNS: 172.16.0.1
- 桌面共享：172.16.100.1, 172.16.0.1

- Server: 172.16.0.1, 192.168.0.254, 192.168.1.254 允许核心转发
  - ftp服务：ftp://172.16.0.1
  - http服务: http://172.16.0.1
    - /cobbler
    - /centos
  - DNCP服务:
    - Windows: 172.16.250.X
    - Linux: 172.16.249.X
  - 学员地址：172.16.X.1-254, 172.16.100+X.1-254
    - X: 学号

## 两周以后留存率

- 主动学习
  - 动手实践：40%
  - 讲给别人：70%
    - **写博客**：5w1h
      - 5w: what, why, when, where, who
      - 1h: how
- 被顶学习
  - 听课：10%
  - 笔记：20%