# NFS

> Network File System，网络文件系统, SUN公司研发，Unix-like，文件系统共享
> NFS 基于 RPC

- 内核级文件系统
- RPC: Remote Procedure Call，远程过程调用
  - PC: Procedure Call 过程调用(没有返回，有返回则称为函数)
  - RPC 是远程要运行的代码
- root_squash(降权), nfsnobody(guest)
- all_squash

- nfsv1 SUN公司内部内测
- nfsv2, nfsv3(CentOS 6), nfsv4(CentOS 7)

- **nfsd: tcp/2049端口**

## 1. RPC：Remote Procedure Call

1. rpc.mountd进程: 认证(验证用户身份)
2. rpc.lockd进程：锁机制（读占锁、共享锁）
3. rpc.statd进程：断开从新连接状态进程

返回给客户端
mountd, 固定端口，tcp/111

## 2. nfsd: tcp/2049端口(监听socket文件)

- 客户端请求，nfsd响应（携带令牌）给客户端

## 安装和使用NFS服务

``` shell
# yum -y install nfs-utils
# rpm -ql nfs-utils | less
# systemctl start nfs.service
# ss -tln
  内核监听2049
# vim /etc/exports.d/file.exports
```

## NFS共享目录

- 导出的文件系统的格式 `/path/to/somdir ip(export opt1, opt2) ip(opt1,opt2) ...`

- Machine Name Formats:
  - 单个主机：ipv4, ipv6, FQDN
  - IP networks：两种掩码格式均支持，例如172.18.0.0/255.255.0.0或者172.18.0.0/16
  - wildcards：主机名通配,例如*.lingyima.com
  - netgroups：NIS域内的主机组，@group_name
  - anonymous：表示使用*通配所有客户端

- General Options:
  - rw：读写
  - ro：默认，只读
  - root_squash：默认，压缩root用户权限
  - no_root_squash：不压缩root用户权限
  - all_squash：压缩所有用户
  - anonuid and anongid：映射至何用户

## 示例：服务器

``` SHELL
# mkdir /nfsdata
# cd /etc/exports.d/
# vim /etc/exports
  /nfsdata 172.18.0.0/16(rw)

禁止重启
# systemctl reload nfs.service

重新导出文件系统
# exportfs -r

# useradd -u 2000 user1
# setfacl -m u:user1:rwx /nfsdata
# ls -l /nfsdata/
```

## 客户端

客户端查看共享

``` shell
# showmount -e 172.16.0.3
# mkdir /web/html -p
# mount -t nfs 172.18.0.3:/nfsdata /web/html
# mount
# man showmount
# cp /etc/fstab /web/html

# useradd -u 2000 user1
# su - user1
$ cd /web/html/
$ touch a.txt
  /mydata/data 172.16.100.65/16(rw), *(ro,all_squash)
```

## 实践作业

1. nfs server导出/web/html，客户端以此目录为其httpd服务的某虚拟主机的根文档目录，并部署discuz做测试

2. nfs server导出/mydata/data目录，客户端一次目录为其mariadb服务的数据目录，要求mariadb server要能启动，并能管理数据（用户名ID）