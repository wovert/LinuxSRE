# OpenSSH

## 服务进程有两种类型

- 独立守护进程（自我管理）：httpd
- 瞬时守护进程：平常不会启动，有超级守护进程管理唤醒telent进程，该进程处理完成之后响应给客户端并继续睡眠，有超级守护进程监听服务
  - CentOS 5/6: 服务托管给超级守护进程，**xinetd**
    - 配置文件：`/etc/xinetd.conf, /etc/xinetd.d/*`
      - 启用某瞬时守护进程的方式
        - `# vim /etc/xinetd.conf`
        - `disable = no` 不禁用
        - chkconfig命令
          - `# chkconfig NAME on|off`
      - 重启超级守护进程
    - `# service xinetd start|stop|status|reload|restart`

## telnet

> C/S结构, `23/tcp`
> 明文协议:认证等均为非加密

- Linux发行版默认禁用telnet服务
- Linux：禁止管理员直接登录
  - 支持su切换

## CentOS 6

- Server: **telnet-server**
- Client: **telent**

## CentOS 7

- Server: `# yum -y install telnet-server`
  - 服务程序： `/usr/sbin/in.telnetd`
  - systemd 用户监听端口 `/usr/lib/systemd/system/telnet.socket`

  - `# systemctl start telnet.socket`
  - `# ss -tln` 23端口， systemd用户

- Client: telnet(账号和密码都是明文传送的)
  - 使用普通用户登录，不能使用管理员登录
  - `# telnet [host [port]]`

- 抓包操作：`tcpdump`

## ssh：Secure SHell

- C/S：`22/tcp`，安全地远程登录
- 协议
  - `ssh v1`：中间人攻击(man-in-middle)
  - `ssh v2`：使用此版本

- ssh 是持久连接类型：会话机制，空闲超时会退出（设置）
- 非对称加密，传送数据很慢
  - 解决：使用定期对称密钥传送数据

- 主机认证：需要用到主机认证密钥；由服务器端维护和提供
- 用户远程登录：两种方式
  - 1.基于口令的认证；passsword
  - 2.基于密钥的认证；signature
    - 用户提供一对儿密钥，私钥保留在客户端，公钥保留于远程服务器端的某用户家目录的特定文件中

## OpenSSH：ssh协议的开源实现

- Linux发行版默认使用

- sshd服务程序: `ssh daemon`
  - 配置文件：`/etc/ssh/sshd_config`

- ssh客户端工具: `ssh client`
  - 配置文件：`/etc/ssh/ssh_config`
  - 工具：scp, sftp

- `# rpm -qa | grep -i ssh`

- 公共库：`openssh,libssh,ksshaskpass`

## 客户端程序

``` shell
# rpm -ql | grep -i ssh
# rpm -ql openssh-clients
```

- `openssh-clients-VERSION`
- `ssh [options] [user@]host ['COMMAND']`
- `ssh [opitons] -l user host ['COMMAND']` 不同登录直接执行command

- 省略用户名：使用本地用户名作为远程登录的用户名

``` shell
# ssh 172.10.100.67
# ssh 172.18.100.67 'ifconfig'
```

### 常用选项

``` shell
-1 : ssh v1
-2 : ssh v2
-4 : ipv4
-6 : ipv6

-l login_name：以指定的用户的身份进行远程登录
-p port：远程服务器的端口
-o option：覆盖远程服务器sshd服务配置选项
  `StrictHostKeyChecking` 严格检查主机密钥(第一次要不要接受提示信息)
  `ForwardX11`
-X：支持X11转发（把本地服务当作图形服务器（图形转发））
  xshell:
-Y：支持授信任的X11转发
-b bind_address：本地的源地址（本地有多个接口地址时指定连接地址）
-i identity_file：基于密钥的认证执行认证操作时使用的本地密钥文件
~/.ssh/{identity(v1), id_dsa,id_ecdsa, id_ed25519, id_rsa（v2）}其中某一个文件
```

``` shell
连接远程并打开远程firefox
# ssh -X root@172.10.100.67
# firefox

```

### ssh客户端配置文件

``` SHELL
# /etc/ssh/ssh_config
  HOST host1.wovert.com
  HOST host2.wovert.com
  HOST *.lingyima.com
  HOST * 连接任意主机
  
  特殊的放在前面

  Host * # 默认配置
    option value
    ...

  Host PATTERN # 匹配模式
    option value
    ...

  Host host1.lingyima.com # 指定唯一主机模式
    StrictHostKeyChecking no
    ...
```

``` shell
# vim /etc/ssh/ssh_config
  Host 172.18.100.67
    StrictHostKeyChecking no
```

### Windows的客户端程序

- secrecrt, xmanager(xshell), sshsecureshellclient,putty

### 基于密钥的认证

> 只能单项登录

- 远程主机：172.18.100.67
- 本地主机：172.18.100.68

1. 生成一个密钥对儿; 非对称密钥

``` SHELL
# ssh-keygen [-b bits] [-t type] [-f output_keyfile] [-N new_passphrase]
  -t type
    rsa: 默认算法，密钥默认长度为2048bits
    dsa: 密钥长度固定位1024),
    ecdsa: 椭圆曲线算法,密钥长度256/384/521bits
    ed255519

  -b bits 密钥长度 (RSA: 最短768)， 默认2048 bits

  -f out_keyfile 指明私钥文件保存位置
  -N new_passphrase 私钥加密
```

``` SHELL
[172.18.100.68~]# ssh-keygen -t rsa -b 2048
  ~/.ssh/id_rsa: 私钥文件路径
  passphrase: 私钥加密密令
  [RSA 2048] 二维码
  id_rsa.pub 公钥文件
[172.18.100.68~]# rm -rf ~/.ssh
[172.18.100.68~]# ssh-key -t rsa -f ~/.ssh/id_rsa -N ''
  id_rsa文件必须是600权限

[172.18.100.68~]# ls ~/.ssh
  id_rsa
  id_rsa.pub
```

2. 将生成的密钥对儿中的公钥`rd_rsa.pub`的内容复制到远程主机用户的家目录下`.ssh`目录下的文件`authorized_keys`（644）文件当中追加

``` SHELL
# ssh-copy-id [-i [identity_file]] [-p port] [user@host]
  -p port: 远程主机的监听的端口号
  user@host: 远程主机的用户名主机号

可以使用不同的用户名登陆
[172.18.100.68~]# ssh-copy-id -i .ssh/id_rsa.pub root@172.18.100.67
[172.18.100.68~]# ssh-copy-id -i .ssh/id_rsa.pub centos@172.18.100.67
```

3. 测试

``` shell
[172.18.100.68]# ssh user@hostname
[172.18.100.67]# cat .ssh/id_rsa.pub
```

## scp命令

> secure cp，跨主机进行安全文件的传输工具

``` SHELL
scp [options] SRC... DEST/
scp [options] SRC DEST
```

### 存在两种使用方式

#### 1. PUSH 推送(src to dest)

``` shell
# scp [options] /path/from/somefile ... [user@hostname]:/path/to/somewhere
```

本地文件（一个或多个）复制到远程主机的目录下

#### 2. PULL 拉取(from dest to src)

``` shell
# scp [options] [user@hostname]:/path/from/somefile ... /path/to/somewhere
```

远程主机的目录下复制文件到本地的目录下

``` 常用选项
  -r : recursive
  -p : 保存源文件的权限及从属关系
  -q : 静默模式
  -p PORT: 指明远程主机ssh协议监听的端口
```

### 缺点

- 不够灵活

### sftp子系统

> OpenSSH 服务自带

- sftp：C/S架构
- S: 由sshd服务进程实现，是ssh的一个子系统；在CentOS上默认启用
- C: sftp命令

- 客户端命令

``` shell
# sftp root@远程主机` 密钥认证不需要输入密码
# sftp root@172.18.100.67
sftp> help
sftp> get destfile srcfile 下载文件destfile到本地重命名为srcfile
```

[Linux设置SFTP服务用户目录权限](http://www.cnblogs.com/luyucheng/p/6094729.html)

[基于vsftpd+pam+mysql架设ftp并实现虚拟用户登录](http://littershare.blog.51cto.com/6188016/1192609/)

## ftp协议

> file transfer proctocol

- 明文协议
- 安全传输机制：
  - ftps: ftp over ssl
  - sftp: ftp over ssh

- ftp协议不适应现在，而是使用云存储

## sshd 服务器端程序

- 程序包文件：`openssh-server-VERSION`
- 配置文件：`/etc/ssh/sshd_config`
- 格式：`directive value`

常用指令

``` shell
Port 22
AddressFamily any|ipv4|ipv6  any两者都有
# ListenAddress 0.0.0.0 监听的地址，0.0.0.0本机的所有有效地址
  私网地址：建议使用私网地址
  公网地址：不建议使用

  解决方案：
    1. 建立vpn主机（跳板机），vpn分配给私网地址，然后通过私网连接sshd服务。
    2. 使用公网地址，密钥认证保存在U盘上，使用时插入电脑。密钥文件一定要加密，防止丢失U盘。并且保留手写密钥数据。
# Protocol 1 协议版本
# HostKey /etc/ssh/ssh_host_key 主机密钥（私钥），对应的公钥在ssh_host_key.pub
  客户端连接时发给主机发给客户端公钥，如果客户端有公钥不用发送，而且主机认证直接通过，不同yes|no提示

Protocol 2
HostKey /etc/ssh/ssh_host_rsa_key
# HostKey /etc/ssh/ssh_host_dsa_key 禁用dsa算法，因为不安全
HostKey /etc/ssh/ssh_host_ecdsa_key
HostKey /etc/ssh/ssh_host_ed25519_key

## version 1
# KeyRegenerationInterval 1h  v1 每隔一个小时换密钥
# ServerKeyBit 1024 密钥长度

## loging
#SyslogFacility AUTH
SyslogFacility AUTHPRIV   日志记录方式，AUTHPRIV表示日志记录与/var/log/secure 登录信息（成功，失败等）

**运维技巧**：分析/var/log/secure日志文件，并且定期执行。发送给邮件，第二日查看邮件

# LogLevel INFO 日志事件级别（事件重要程度）

## Authentication 认证相关
# LoginGraceTime 2m 登录宽限期
  登录远程主机
  # ssh 172.15.100.56 一直不填账号和密码的宽限期
  每一个连接多需要子进程运行，2m之后登录断开

PermitRootLogin no  是否允许管理员直接登录
StrictModes yes 是否使用严格模式
MaxAuthTries 6 最大尝试认证次数（6次输入密码错误)
**运维技巧**：尝试次数达到很多次，在一定时间禁止访问主机（iptables防火墙过滤）
MaxSessions 10 最大并发连接数
RSAAuthentication yes 是否支持rsa加密方式完成密钥认证
PubkeyAuthentication yes 基于公钥认证方式
AuthorizedKeysFile .ssh/authorized_keys 密钥存放路径文件

#AuthorizedPrincipalsFile none 定义密钥规则文件

PasswordAuthentication yes 基于是否口令认证
PermitEmptyPasswords no 是否空密码认证
ChallengeResponseAuthentication no 是否挑战式响应认证方式，不安全

## Kerberos options. 集中式认证，kerberos协议

多个服务都有各自的用户和密码
解决方案：集中认证
  多个服务器
  一个kerberos认证服务器
    多个服务器各自认证时不再本机认证，而是到kerberos主机认证
  用户名认证、密码认证都在kerboros主机认证

- NIS： 账号集中存储，明文发送

UsePM yes 可插入式认证模块
X11Forwarding yes 是否支持x11转发
useDNS no 是否反解IP地址

Subsystem stp /usr/libexec/openssh/sftp-server ssh子系统

## 限制可登陆的用户
AllowUsers user user2 user3 允许使用ssh服务的用户白名单
AllowGroups group1 grup2 允许使用ssh服务的用户组白名单
DenyUsers user user2 拒绝使用ssh服务的用户黑名单
DenyGroups group1 grup2 拒绝使用ssh服务的用户组白名单

**运维技巧**: AllowUsers与DenyUsers不能同时使用，建议使用AllowUsers
```

- CentOS 6: `/etc/rc.d/init.d/sshd`
- CentOS 7: `/usr/lib/systemd/system/sshd.service`

``` shell
# rpm -ql openssh-server
  sshd.service
  sshd.socket 访问时启动，systemd来监听启动sshd服务
```

## 手册页

- 服务器

``` shell
# man sshd_config
# man sshd
```

- 客户端

``` shell
# man ssh_config
# man ssh
```

### 最佳实践

1. 不要使用默认端口，设置成随机端口 `Port 22022`
2. 不要使用第一版协议 `Protocol 2`
3. 限制可登陆的用户
  - `AllowUsers usr1 use2 ...`
  - `AllowGroups grp1 grp2 ...`
4. 设定空闲会话超时时长 `ClientAliveCountMax 2m`
5. 利用防火墙设定ssh的远程访问策略; 仅允许来自于指定网络中的主机访问
6. 仅监听与指定的IP地址 `ListenAddress ipv4|ipv6|any(default)`
7. 基于口令认证时，使用强密码策略

``` shell
# openssl rand -base64 30
# tr -dc A-Za-z0-9_ < /dev/urandom | head -c 30 | xargs
```

密码管理工具：一定要加密

8. 基于密钥的认证
9. 禁止使用空密码
10. 禁止管理员直接登录
11. 限制ssh的访问频度和并发在线
12. 做好日志分析(保存于远程服务器)

## dropbear

### what: ssh协议的轻量实现

### where: 用于嵌入式环境

### How: fedora epel源

`# yum -y install dropbear`

- 实现目标：busybox + dropbear + nginx
- 服务器端程序：dropbear
- 客户端程序：dbclient
- 密钥管理工具：dropbearkey

### 服务启动的方法：

1. 生成密钥：手动生成密钥

``` shell
# dropbearkey -t dss -f /etc/dropbear/dropbear_dss_host_key`
dss:Digest Signature Standard, -s 1024 bit固定长度

# dropbearkey -t rsa -s 2048 -f /etc/dropbear/dropbear_rsa_host_key
  -s 是8的整数倍

# dropbearkey -t ecdsa -s 384 -f /etc/dropbear/dropbear_ecdsa_host_key
  -s 256|384|521

运行服务：
# dropbear -h`
```

2. 手动启动（前台）

``` shell
# dropbear -F -E -p 22022

守护进程
# systemctl start dropbear.service

-E：error,将日志发往标注错误输出，而非syslog
-F：front,让进程运行于前台
-p：port,指明监听的地址和端口
-w : 进制root登录
```

3. 测试登录

``` shell
# ssh -p 22022 username@host
```

4. 将其运行为守护进程

``` shell
CentOS 7: systemd unit file的环境配置文件
# vim /usr/lib/systemd/sytem/dropbear.service
  [Service]
  EnvironmentFile=-/etc/systemconfig/dropbear
  ExecStart=/usr/sbin/dropbear -E -F $OPTIONS

# vim /etc/sysconfig/dropbear
  OPTIONS="-p 23332"

# systemctl start dropbear.service
```

### 客户端程序：dbclient

``` SHELL
# dbclient -h`

dbclient [options] [user @]host[/port] [command]`

选项：
  -l <username>
```

## 编译安装dropbear

- 提供scp功能, 与ssh的scp功能冲突