# 压缩工具
> 压缩及解压：不能压缩目录及默认删除原文件

- compress/uncompress: .Z
- gzip/gunzip: .gz
- bzip/bunzip: .bz
- xz/unxz: .xz
- Lzma/unlzma:
- zip/unzip
- tar, cpio

## 归档
- zip/unzip
- Tar
- cpio

## gzip/gunzip/zcat 压缩并删除原文件
- gzip FILE 
	+ -d：解压缩，相当于gunzip
	+ -[1-9]：指定压缩比，默认是6，数字越大压缩比越大
	+ -c：将压缩结果输出至标准输出，并保留源文件

`#  gzip -c FILE > FIEL.gz`
> file.sign 指纹验证信息（验证码）
`# gunzip FILE 解压并删除压缩文件`
`# zcat FILE.gz 查看压缩文件内容(临时解压查看文件内容)`

##　bzip2/bunzip2/bzcat
- bzip FILE
	+　-d：uncompress, bunzip file.bz2
	+ -#: compress percent
	+ -k: keep, 保留原文件

## xz/xunz/xzcat 删除原文件
- xz [OPTION]... FILE... 
	+ -d：解压缩
	+ -[1-9]：压缩比
	+ -k：keep, 保留原文件

## lzma/unlzma

### 归档
> 多个文件和目录打包成一个文件

## tar命令
- tar [OPITON]... FILE...
	- f:必须跟在[cxt]选项后面，指明归档文件，选项可以不用-

### 1.创建归档：-c
`$ tar cf file.tar *.log`

### 2.展开归档：-x
`$ tar xf file.tar -C 展开位置`

### 3.查看归档文件中的文件列表：-t

### 4.归档并压缩
- -z:gzip2
	+ 归档压缩：-zcfv file.tar.gz FILE...
	+ 展开压缩：-[z]xf file.tar.gz

- -j:bzip2
	+ 归档压缩：-jcfv file.tar.bz2 FILE...
	+ 展开压缩：-[j]xf file.tar.bz2
-J:xz
	+ 归档压缩：-Jcfv file.tar.xz FILE...
	+ 展开压缩：-[J]xf file.tar.xz

##　zip:压缩归档
> zip/unzip：.zip

# rsync
> Rsync(Remote Synchronize) 远程资料同步工具
通过LAN/WAN快速同步多台主机
使用"Rsync"算法来使本地主机和远程主机之间达到同步

## Rsync特点
1. 镜像保存整个目录树和文件系统
2. 容易做到保持文件的许可权、时间、软链接
3. 无需特使许可权即可安装
4. 拥有优化的流程，文件传输效率高
5. 使用Rsh,ssh等协议传输文件，可以直接通过Socket连接
6. 支持匿名传输

## rsync服务安装

### 关闭防火墙
`# servie iptables stop && chkconfig iptables off`
`# setenforce 0`
`# yum -y install rsync`

## 创建配置文件/etc/rsync.conf，系统不会自动创建
- uid = nobody 	进行备份的用户，nobody为任何用户
- gid = nobody	进行备份的组，nobody为任意组
- user chroot = no 	
	+ true: rsync在传输文件以前首先chroot到path参数所指定的目录下，这样做的原因是实现额外的安全防护，但是缺点是需要以root权限，并且不能备份指向外部的符号连接所指向的目录文件。默认情况下chroot值为true，但是这个一般不需要
- max connections = 200 	最大连接数
- timeouit = 600     		覆盖客户指定的IP超时时间
- pid file = /var/run/rsyncd.pid    
- lock file = /var/run/rsyncd.lock
- log file = /var/log/rsyncd.log

- [backup]   	认证模块名
- path=/backup/  	同步的目录 
- ignore erros		忽略一些无关的IO错误
- read only = no  	允许可读可写
- list = no  		不允许列表清单
- hosts allow = 172.16.0.0/255.255.0.0
	+ 只允许172.16.0.0/16网段进行同步
- auth users = test  认证用户名
- secrets file = /etc/rsyncd.password
	+ 密码文件存放地址


`# cd / && mkdir backup && chmod -R 777 /bakcup`
`# echo "test:test" > /etc/rsyncd.password`
`# chmod 600 /etc/rsync.password`


## 启动配置
`# vim /etc/xinetd.d/rsync`

- 配置 rsync servervi /etc/xinetd.d/rsync
将disable=yes 该为no

`# service xinetd start`
`# yum -y install xinetd`

## rsync服务端启动的两种方法
- 启动rsync服务器 (独立启动)
`# /usr/bin/rsync --daemon on`

- 启动rsync服务（xinetd超级进程启东）
`# /etc/init.d/xinetd reload`

## 配置rsync自动启动
`# chkconfig rsync on`
`# chkconfig rsync --list`

`# vim /etc/rc.local`
> rsync --daemon加载进去


## 客户端配置
`# echo "test" > /etc/rsyncd.password`
仅仅需要密码，不需要用户，免得要同步时还有手动互动

`# chmod 600 /etc/rsync.password`

## 测试
`# rsync -vzrtop --delete /home/ce test@172.16.7.0::backup --password-file=/etc/rsyncd.password`

- 从服务器上下载文件
`# rsync -avz --password-file=/etc/rsyncd.password test@172.16.7.0::backup /home/`

- 从本地上传到服务器
`rsync -avz --password-file=/etc/rsyncd.password /home test@172.16.7.0::backup`