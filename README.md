# Linux 运维架构-[零壹码博客](https://lingyima.com)

## Linux SRE 行业前景

- 流程化、标准化的工作越来越依赖于信息系统，是各企业发展的必然趋势，信息系统开发和运维也会创造越来越多的工作岗位
- **机器化、自动化、智能化**是人类科技发展趋势，也越来越要求人们对信息系统有更深入的管控能力
- Linux系统已经几乎无处不在
  - **Android** 手机底层的系统
  - 基于Android 的各种**VR设备**
  - 各大型互联网公司**IDC主机的操作系统**
  - 各种**智能设备**，如**智能监控**等

[www.netcraft.com](https://www.netcraft.com)

[www.top500.org](https://www.top500.org)

## Linux 运维工作岗位

- 系统运维工程师
- 应用运维工程师
- 运维开发工程师
- 系统运维架构师
- 云计算运维工程师
- 大数据运维工程师

## Linux 知识技能进化路径

- 系统管理/服务管理/脚本管理(系统运维工程师)
- 系统扩展/系统冗余/数据存储(应用运维工程师、云计算运维工程师、大数据运维工程师)
- 系统监控/运维工具/性能优化
- 系统架构(系统运维架构师)

## 站点系统架构演变

- 单机(one box)
  - httpd -> php module -> php app -> mysql
  - httpd -> tomcat -> jsp app -> mysql
- 多机
  - httpd(server1) -> (fcgi server: php app -> mysql)(server2)
  - httpd->fcgi server: php app(server1) -> mysql(server2)
  - httpd(server1)->fcgi server: php app(server2) -> mysql(server3)
  - 评估、测试、上线
- 缓存
  - page cache
    - httpd
      - fcgi server: php app
        - data cache
        - mysql
- 大数据系统：商业智能决策
- 容器：docker

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