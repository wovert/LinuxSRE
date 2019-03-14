# Linux 运维架构-[零壹码博客](https://lingyima.com)

## [计算机入门](./introduction-to-computers/)

- [计算机概论](./introduction-to-computers/computer-concepts/)
- [操作系统](./introduction-to-computers/operating-system/)
- [计算机网络](./introduction-to-computers/computer-network/)
- [程序设计语言](./introduction-to-computers/programming-language/)

## [Linux 基础系统](./linux-basic-system/)

- [Linux 安装与配置](./linux-basic-system/setup-setting/)
- [Linux 基础入门](./linux-basic-system/linux-basic/)
- [文件系统](./linux-basic-system/file-system/)
- [文件操作工具](./linux-basic-system/file-operations/)
- [bash 特性](./linux-basic-system/bash/)
- [文本处理工具及正则表达式](./linux-basic-system/text-manipulation-regular-expression/)
- [用户管理工具](./linux-basic-system/user-manager/)
- [Linux 编辑器](./linux-basic-system/editor/)
- [压缩打包工具](./linux-basic-system/compression-packing/)

## [Linux 系统管理](./system-management/)

- [磁盘分区及文件系统管理工具](./system-management/disk-partition/)
- [selinux安全](./system-management/selinux/)
- [程序包管理](./system-management/package/)
- [RAID](./system-management/raid/)
- [LVM](./system-management/lvm/)
- [网络管理](./system-management/network/)
- [进程管理](./system-management/process/)
- [系统启动流程](./system-management/startup/)
- [内核管理](./system-management/kernel-module/)
- [安装系统](./system-management/setup-system/)
- [系统服务](./system-management/system-service/)
  - [crontab](./system-management/system-service/crontab/)
  - [selinux](./system-management/system-service/selinux/)  
- [systemd](./system-management/systemd/)

## 应用服务管理

- [OpenSSL](./application-service/openssl/)
- [http](./application-service/http/)
- [httpd](./application-service/httpd/)
- [Nginx](./application-service/nginx/)
- [DNS](./application-service/dns/)
- [OpenSSH](./application-service/openssh/)
- [IPTABLES](./application-service/iptables/)
- [tcp wrapper](./application-service/tcp-wrapper/)
- [nss and pam](./application-service/nss-pam/)
- [FTP](./application-service/ftp/)
- [NFS](./application-service/nfs/)
- [SAMBA](./application-service/samba/)
- [Web Service](./application-service/webservice/)
  - [LAMP](./application-service/lamp/)
  - [LNMP](./application-service/lnmps/)
  - [Mariadb](./application-service/mariadb/)
  - Cache
    - [Memecache](./application-service/memcached/)
    - [varnish(./application-service/vanish/)
  - NoSQL(Cache)
    - Redis(./application-service/redis/)
    - MongoDB(./application-service/mongodb/)
    - HBase(./application-service/hbase/)
  - tomcat(./application-service/tomcat/)
  - session replication cluster(./application-service/dns/)

## Cluster(集群)

- LB Cluster(负载均衡)
  - LVS
  - Nginx
  - haproxy
- HA Cluster(高可用集群)
  - keepalived
  - Corosync+Pacemaker
  - pcc/crmsh
- MySQL Cluster
  - HA Cluster
  - MHA
  - Read-Write splitting

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
  - ElasticSearch(搜索引擎)
  - Logstash(日志收集)
  - Kibana(前段展示工具)

## 系统优化

## 人工智能

## 区块链

## 学习环境

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
      - 5w: what, why, shen, where, who
      - 1h: how
- 被顶学习
  - 听课：10%
  - 笔记：20%

## VMware Workstation

- 现代计算机组织体系-5大部件
  - 运算器、控制器、存储器、输入设备、输出设备
    - CPU
    - bus: 总线（控制总线、数据总线、地址总线[寻址]）
    - memory: 编制存储设备
  - IO：对外部部件交互
    - 硬盘
    - 网卡