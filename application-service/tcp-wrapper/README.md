# tcp wrapper：tcp包管理器

- 访问控制：
1. tcp协议之上服务
2. 仅一部分基于tcp传输的应用层服务可接受其控制

## 用户空间：库

- **libwrap.so** 链接至此库文件的服务程序

1. 动态链接
`ldd`命令对其应用的执行结果中包含了`libwrap.so`即可
`# ldd $(which COMMAND)`

2. 静态链接
`strings`命令对其应用程序的执行结果中包含了

```shell
# /etc/hosts.allow
# /etc/hosts.deny
# strings $(which COMMAND)
```

## telnet-server

``` shell
# rpm -ql telnet
# ldd $(which in.telnetd)
```

注意：CentOS 6系统上的超级守护进程xinetd链接到了libwrap.so

## 服务基于libwrap完成访问控制的流程

1. 先行检查`/etc/hosts.allow`文件，如果有显示的授权规则，则允许
2. 否则，则检查`/etc/hosts.deny`文件，如果有显示的拒绝规则，则拒绝访问
3. 否则，默认策略为允许

## 配置文件语法

`daemon_list: client_list [:options]`

``` shell
vsftpd: ALL
vsftpd: 192.168.1.71
```

### daemon_list

1. 单个应用程序文件的文件名，而非服务名；例如vsftpd
2. 以逗号分隔的应用程序文件名列: vsftpd, sshd

3. ALL，所有接受`tcp wrapper`控制的服务程序

### client_list

1. 单个主机：IP地址或主机名；
2. 网络地址（网络范围内的地址）

- 或使用完整的掩码格式：`172.18.0.0/255.255.0.0`
- 或使用简短网络地址表示法：`172.18.`

3. ALL：所有主机
4. KNOWN, UNKNOWN, PARANOID

- kNOWN：正反向主机解析对应
- UNKNOWN：根据地址无法反解主机名
- PARANOID: 正反向解析不对应

- EXCEPT：除了

vsftpd: `182.18. EXCEPT 172.18.100.0/255.255.255.0 EXCEPT 172.18.100.68`
双重否定：172.18.100.68可以访问

``` shell
[:options]
deny：拒绝，主要用于在/etc/hosts.allow
  vsftpd: 172.18.100.68 :deny 
  vsftpd: 172.18. :deny 

allow：允许，主要用于在/etc/hosts.deny
  sshd: 172.18. :allow

spawn：启动一个外部程序完成执行的操作
  /etc/hosts.allow
  sshd: ALL :spawn /bin/echo $(date) login attemp from %c to %s, %d >> /var/log/sshd.log
```

- 可使用的扩展

``` shell
# man hosts.allow
# man hosts.deny
```

``` shell
%c : Client information :user@host, user@address, a host name, or just an address
%s：Server information: daemon@host, daemon@address, or just a daemon name, depending on how much information
%d：The daemon process name （args[0] value）
%p：The daemon process id
```

- 帮助手册：`# man hosts_access`

``` shell
/etc/hosts.allow 为空
/etc/hsots.deny
vsftpd: ALL :spawn /bin/echo $(date) login attemp from %c to %s, %d >> /var/log/vsftpd.log
```

## 练习：sshd服务仅允许172.18网段中的主机访问，当不包括172.18.X.0/24子网，X为学号，同时，有放行172.18.x.y; 余下的所有对sshd访问视图均拒绝且记录于/var/log/tcpwrapper.log日志文件中

## 练习：INPUT和OUPT默认策略为DROP，请使用规则iptables规则放行本机的samba服务