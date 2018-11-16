# HA

> High Availability

- Linux Cluster: LB, HA, HP

- LB: lvs
  - Directory: HA
  - RS: 健康状态监测方式

- 前段调度器高可用

## RS：健康状态检测方式

- a.网络层：`icmp ping`
- b.传输层：`tcp ping`
- c.应用层：对相应服务下的关键点发起请求

- 检测超时限定：**timeout** (限定范围内超时时间)
- 检测次数限定：**times** (限定范围内次数限制)
  - soft failure(第一次失败) -> soft failure(第二次失败) -> hard failure(真失败)
  - OK -> problem: 3+检测
  - Problem -> OK: 1+检测
- 各检测之间的时间间隔：**duration** (限定范围内时间间隔)

- **Avalability=MTBF/(MTBF+MTTR)**
  - MTBF：平均无故障时间
  - MTTR：平均修复时间
    - 减低MTTR: 冗余(redundant)技术

  - 拉锯战：A正常，发送B, C正常，B,C收不到A发送的信息
    - 切断电源(brain split, network partition)
    - B，C的总票数大于总票数的一半，B，C为主
      - width quorun = total/2
    - A自己放弃

  - 仅有A，B独特的集群

  - 建议：奇数节点集群（3,5,7）

- HA Cluster的实现方案
  - 1.vrrp协议的实现
    - keepalived
  - 2.AIS 家族(补刀、应用程序心跳)：完备HA集群
    - hearbear
    - corosync
    - cman(早期)

## VRRP协议

> Virtual Redundant Routing Protocol，虚拟冗余路由协议

### VRRP 协议术语

- 虚拟路由器：由一个Master路由器和多个Backup路由器组成。主机将虚拟路由器当作默认网关。
- VRID：0-255，虚拟路由器的标识。有相同VRID一组路由器构成一个虚拟路由器。
- Master(Active)：虚拟路由器中承担报文转发任务的路由器
- Backup(Passive)：Master路由器出现故障时，能够代替Master路由器的路由器
- 虚拟IP地址，虚拟路由器的IP地址，一个虚拟路由器可以拥有一个或多个IP地址
- IP地址拥有者：接口IP地址与虚拟IP地址相同的路由器被称为IP地址拥有者
- 虚拟MAC地址：一个虚拟罗尤其拥有一个虚拟MAC地址。格式是00-00-5E-00-01-{VRID}。虚拟路由器回应ARP请求使用的虚拟MAC地址，只有虚拟路由器做特殊配置的时候，才回应接口的真实MAC地址。
- 优先级：VRRP根据优先级来确定虚拟路由器中路由器的地位

- 工作方式
  - 抢占式
  - 非抢占式
- 工作模式
  - 主备
  - 主/主：配置多个路由器（主备）

- 认证方式：
  - 无认证
  - 简单字符串认证：与共享密钥
  - md5认证

- gracious arp: 免费的arp

## keepalived架构

> 是vrrp协议的实现，原生设计目的为高可用ipvs服务；keepalived能够配置文件中定义生成ipvs规则，并能够对各RS的将健康状态进行检测

[Keepalived documentation](https://media.readthedocs.org/pdf/keepalived/stable/keepalived.pdf)

vrrp_script, vrrp_track;

- 组件：
  - 控制组件：配置文件分析器
  - 内存管理组件
  - IO复用组件
  - 核心组件
    - vrrp stack
    - checker
    - ipvs wrapper
    - watch dog

## HA Cluster配置的前提

1. 各节点时间同步；`ntp协议`，`chrony服务`(CentOS 7)
2. 确保`iptables及selinux不会阻碍`
3. 各节点之间可通过`主机名互相通信`（对ka并非必须）；名称解析服务的解析结果必须与`uname -n`命令的结果一致
4. 各节点之间的root用户可以`基于密钥认证的ssh通信`（对ka并非必须）

## 示例

- HA1: 172.18.100.6
- HA2: 172.18.100.5
- RS1: 172.18.100.11
- RS2: 172.18.100.12

1. 配置IP地址
2. HA1, HA2分配时间同步设置

``` sh
# ntpdate 172.16.0.1
# crontab -e
  */5 * * * * /sbin/ntpdate 172.18.0.1 &> /dev/null
# crontab -l
# ntpdate 172.18.0.1
# which ntpdate

# iptables -nL
# getenforce

```

3. HA1, HA2分别安装keepalived

- 安装keepalived
  - CentOS 6.4+,程序包已经在base源
  - CentOS 6.4- 程序包在epel源

``` sh
# yum -y install keepalived
# rpm -ql keepalived
```

- 主配置文件: `/etc/keepalived/keepalived.conf`
- Unit file: `/usr/lib/systemd/system/keepalived.service`
- 配置文件：`/etc/sysconfig/keepalived`

- 配置文件内容块

``` sh
# cd /etc/keepalived
# cp keepalived.conf{,.bak}
# vim keepalived.conf
# man keepalivcd.conf
  GLOBAL CONFIGURATIONS 全局配置
    global_defs {
      ...
    }

  VRRP CONFIGURATION
    vrrp_sync_group GRP_NAME {
      ...
    }

    vrrp_instance INST_NAME{
      ...
    }
  
  LVS CONFIGURATIONS
    virtual_server_group GRP_NAME {
      ...
    }

    virtual_server IP port | virtual_server fwmark int {
      protocol TCP
      ...
      real_server <IPADDR> <PORT> {
        ...
      }
      real_server <IPADDR> <PORT> {
        ...
      }
    }
  }
```

4. HA2配置

``` sh
# cd /etc/keepalived
# cp keepalived.conf{,.bak}
# man keepalived
# vim keepalived.conf
global_defs {
  notification_email { 接受通告邮件的地址
    root@localhost
  }
  notification_email_from kaadmin@wovert.com 发件人邮箱地址
  smtp_server 127.0.0.1 邮件服务器（163，126，qq smtp）
  smtp_connect_timeout 30 超时时长
  router_id node1 路由器设备的ID号(必须是主机名)
  vrrp_mcast_group4 224.0.100.18 ipv4多播地址
  vrrp_mcast_group6 ff02::12 ipv6多播地址
}

vrrp_instance VI_1 { 虚拟路由配置
  state MASTER 当前节点在此虚拟路由器中初始状态 MASTER|BACKUP
  interface eno16777736 哪个接口上配置，vrrp实例工作的网络接口
  virtual_route_id 171 当前虚拟路由器ID号，0-255之间
  priority 100 当前物理节点在此虚拟路由器中的优先级
  advert_int 1 广播通告的时间间隔(心跳时间间隔)，1秒
  authentication { 认证机制
    auth_type PASS|AH 默认PASS简单字符串认证，AH:IPSEC(验证头协议)
    auth_pass 12345678 默认8位，# openssl rand -base64 8
  }
  virtual_ipaddress { 定义虚拟IP，默认使用eno16777736
    172.18.100.66 别名
  }

  复制以上文件到：scp keepalived.conf 172.18.100.6:/etc/keepavlied/

  track_interface { 定义要监控的接口
    eth0
    eth1s
  }

  nopreempt: 非抢占模式
  Dreempt_delay 300 抢占延迟

  通告脚本定义
  notify_master <STRONG>|<QUOTED-STRING>
  notify_backup <STRONG>|<QUOTED-STRING>
  notify_fault <STRONG>|<QUOTED-STRING>
  notify <STRONG>|<QUOTED-STRING>
}
```

5. HA1

``` sh
state BACKUP
priority 98
```

6. HA2

``` sh
# systemctl start keepalived.service
# systemctl status keepalived.service
# ip addr show
  172.18.100.66/32
# tail /var/log/messages
```

7. HA1

``` sh
# systemctl start keepalived.service
# systemctl -l status keepalived.service
```

8. 下线HA2

``` sh
在另一个ssh查看
# tail -f /var/log/messages 
# systemctl stop keepalived.service
```

9. 查看HA1

``` sh
# tail -f /var/log/messages
# ip addr show
```

10. 启用HA2

``` sh
# systemctl start keepalived.service

在另一个ssh查看
# tail -f /var/log/messages
```

11. 查看HA1

``` sh
在另一个ssh查看
# tail -f /var/log/messages
  Received higher prio advert
  Enter BACKUP STATE
  ...
```

12. HA2

``` sh
vitual_ipaddress {
  172.18.100.66 dev eno16777736 label eno16777736:0
}
```

13. HA1

``` sh
vitual_ipaddress {
  172.18.100.66 dev eno16777736 label eno16777736:0
}
```

14. HA1停止并重启使用

``` sh
# systemctl stop keepalived.service
# systemctl start keepalived.service
在另一个ssh查看
# tail -f /var/log/messages
# ip addr show
```

15. 通告脚本定义-发送邮件

postfix - 本地发送邮件

``` sh
# vim /etc/vimrc
  set nohlsearch
# vim /etc/keepavlied/notify.sh
  #!/bin/bash
  contact='root@localhost'
  notify() {
    mailsubject="$(hostname) to be $1: vip floating"
    mailbody="$(date +'%F %T'): vrrp transition, $(hostname) change to be $1"
    echo $mailbody | mail -s "$mailsubject" $contact 
  }

  case $1
  master)
    notify master
    ;;
  backup)
    notify backup
    ;;
  fault)
    notify fault
    ;;
  *)
    echo "Usage: $(basename $) {master|backup|fault}"
    ;;
  esac
# chmod +x notify.sh
# ./notify.sh master
& 1
& exit
# scp notify.sh root@172.18.100.6:/etc/keepavlied/
# vim /etc/keepalived.conf
  virtual_ipaddress {}
  notify_master "/etc/keepalived/notify.sh master"
  notify_backup "/etc/keepalived/notify.sh backup"
  notify_fault "/etc/keepalived/notify.sh fault"
# systemctl stop keepalived.service

- 172.18.100.6 配置
# systemctl stop keepalived.service
# vim /etc/keepalived.conf
  notify_master "/etc/keepalived/notify.sh master"
  notify_backup "/etc/keepalived/notify.sh backup"
  notify_fault "/etc/keepalived/notify.sh fault"
# systemctl start keepalived.service
# tail -f /var/log/messages
# mail
& 1
& d 1
& exit
```

- .100.5停止服务，是否发送邮件到100.6

16. 配置虚拟服务器
- 100.5

``` sh
# vim /etc/keepalived.conf

virtual_server IP PORT |
virtual_server PWM # {
  lb_algo rr|wrr|lc|wlc|lblc|sh|dh
    调度方法
  deplay_loop <INT>
    服务轮询时间间隔
  lb_kind NAT|DR|TUN
    集群类型
  persistence_timeout <INT>
    持久连接时长
  protocol TCP
    服务协议
  sorry_server <IPADDR><PORT>
    所有RS均故障时，提胸say sorry的服务器

  real_server <IPADDR> <PORT> {
    weight <INT>
      权重
    notify_up <STRING>|<QUOTED-STRING>
      节点上线时调用通知脚本
    notify_down <STRING>|<QUOTED-STRING>
      节点离线时调用通知脚本
    HTTP_GET|SSL_GET|TCP_CHECK|SMTP_CHECK|MISC_CHECK
      支持的所有健康状态检测方式
    HTTP_GET|SSL_GET {
      url {
        path<STRING> 健康状态检测时请求的资源的URL
        digest <STRING> 基于获取的内容摘要码进行健康状态码判定
        status_code <STRING>
      }
      nb_get_retry <INT> 尝试的次数
      delay_before_retry <INT> 再次尝试之间的时间间隔
      connect_timeout <INTEGER> 连接的超时时长
      connect_ip <IP ADDRESS> 向此处指定的地址发测试请求
      connect_port <PORT> 向此处指定的PORT发测试请求
      bindto <IP ADDRESS> 指定测试请求报文的源IP
      bind_port <PORT> 指定测试请求报文的PORT
    }

    TCP_CHECK {
    }
  }
}

RS: 100.6,100.5

- 100.5
# yum -y install httpd
# vim /var/www/html/index.html
  sorry server 1
# systemct start httpd.service

- 100.6
# vim /var/www/html/index.html
  sorry server 2
# systemct start httpd.service


- 100.5
# vim /etc/keepalived/keepalived.conf
vrrp_instance VI_1 {
  ...
  virtual_ipaddress {
    172.18.100.7 dev eno16777736 label eno16777736:0
  }
}
virtual_server 172.18.100.7 80 {
  deplay_loop 6
  lb_algo rr
  lb_kind DR
  protocol TCP

  real_server 172.18.100.11 80 {
    weight 1
    HTTP_GET {
      url {
        path /
        status_code 200
      }
      connect_timeout 3
      nb_get_retry 3
      delay_before_retry 3
    }
  }
  real_server 172.18.100.12 80 {
    weight 2
    HTTP_GET {
      url {
        path /
        status_code 200
      }
      connect_timeout 3
      nb_get_retry 3
      delay_before_retry 3
    }
  }
}
# scp keepalived.conf 172.18.100.6:/etc/keepalived/
# systemctl stop keepalived.service

- 100.6
# vim /etc/keepalived/keepalived.conf
vrrp_instance VI_1 {
  state BACKUP
  priority 98
  ...

}
# systemctl stop keepalived.service

- 100.5
# systemctl start keepalived.service
# ifconfig
# yum -y install ipvsadm
# ipvsadm -Ln

- 100.6
# systemctl start keepalived.service
# yum -y install ipvsadm
# ipvsadm -Ln

# ifconfig

- 打开终端
# curl http://172.18.100.7

- RS1下线httpd
# systemctl stop httpd.service

- 打开终端
# curl http://172.18.100.7
# curl http://172.18.100.7
# curl http://172.18.100.7

- 100.5
# ipvsadm -Ln
仅有一个

- 100.6
# ipvsadm -Ln
仅有一个

- RS1上线httpd
# systemctl stop httpd.service


- 打开终端
# curl http://172.18.100.7
# curl http://172.18.100.7
# curl http://172.18.100.7

- 100.5
# ipvsadm -Ln
两个

- 100.6
# ipvsadm -Ln
两个


- RS1和RS2全部下线httpd
# systemctl stop httpd.service

- RS1,RS2
# vim /etc/keepalived/keepalived.conf
  protocol TCP
  sorry_server 127.0.0.1 80

- 100.5
# systemctl stop keepalived.service

- 100.6
# systemctl start keepalived.service
# ipvsadm -Ln
# ipvsadm -Ln

- 打开终端
# curl http://172.18.100.7
# curl http://172.18.100.7
# curl http://172.18.100.7

- 100.5
# systemctl start keepalived.service
# ipvsadm -Ln
# ipvsadm -Ln

- 打开终端
# curl http://172.18.100.7
# curl http://172.18.100.7
# curl http://172.18.100.7

- RS1启动httpd服务
# systemctl start httpd.service

- 100.5
# ipvsadm -Ln
# ipvsadm -Ln

- 打开终端
# curl http://172.18.100.7
# curl http://172.18.100.7
# curl http://172.18.100.7

```

- 博客作业：
  - keepalived高可用ipvs集群
  - ip集群提供PHP应用，例如phpwind