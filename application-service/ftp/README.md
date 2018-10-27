# ftp

> File Transfer Protocol C/S架构的文件传输协议，应用层；明文协议：认证及数据传输；21/tcp, 20/tcp

## 服务端实现

- vsftpd(very secure ftp daemon)
- pureftpd
- proftpd
- Filezilla Server

## 客户端实现

- Linux: ftp, lftp
- Windows: cureftp, Filezilla, Flushfxp

## ftp连接类型

- 命令连接：**传输指令，21/tcp**
  - 客户端发出请求，服务端响应
  - 刚开始打开连接

- 数据连接：**传输数据, 20/tcp**， 与命令连接关联
  - 数据连接必然是通过某个命令连接发起
  - ls,get,mget,put等命令

## 数据连接， 站在服务器的角度

- 主动模式(**PORT**)：服务器向客户端发起数据传输请求
  - 服务器端口：固定20
  - 客户端端口：随机
  - 3333+1(占用)<------- 20
  - 3333+1-------> 20
  - 3333+2(可用)<------- 20
  - 3333+2-------> 20
  - Client：注意有防火墙(连接追踪功能)
  - 很难实现
- 被动模式(**PASV**)：客户端向服务器端发起数据传输请求
  - 服务器端口：半随机
  - 命令连接服务器端响应给200，323两个数
  - 4442/256 = 商+余数（200,323两个数）

- 数据传输格式
  - ansi 文本格式
  - binary 二进制格式

  - 示例：911数字
    - 911=>24bits(ANSI): 文本
    - 911=>16bits(binary): 图片

## 用户：资源位于用户的家目录下 -

- 匿名用户(映射至某一固定的系统用户)：ftp,vsftp,/var/ftp/
- 本地用户(系统用户)：注意明文协议，root及系统用户(0-999)
- 虚拟用户：借助于其他系统
  - **nsswitch**: name service switch 名称服务转换(名称解析)
  - **PAM**：Plugable Authentication Modules（插件式认证模块）
    - ssh,vsftpd
- ldap: light dir access protocol 轻量级目录访问协议

## vsftpd

> Very Secure FTP Deamon

- 软件报名：`vsftpd-VERSION`
- 程序：`/usr/sbin/vsftpd`
- 配置文件: `/etc/vsftpd/vsftpd.conf`

- CentOS 6

``` shell
# vim /etc/rc.d/init.d/vsftd
# chkconfig vsftpd on
```

- CentOS 7

``` shell
# rpm -ql vsftpd
# vim /usr/lib/systemd/system/vsftpd.service
# systemctl enable vsftpd.service

# sytemctl start vsftpd.service
# ss -tnlp

# lftp -u username,passwd host
  --> lcd /etc
  --> put fstab

关闭selinux
# getenforce
```

## 配置文件

`/etc/vsftpd/vsftpd.conf`

指令格式 `directive=value`

``` shell
查看所有配置指令
# man vsftpd.conf

# 全局权限
write_enable=no 所有用户都不能上传
listen_port=21 命令连接的监听端口
max_clients=2000 最近连接并发数(0:表示无限制)
max_per_ip 每个IP所允许发起的最大连接数

ftpd_banner=Welcome to ftp.lingyima.com Server !

# 用户可登录设置
userlist_enable 服务启用时加载一个由userlist_file指令指定的用户列表文件；
  此文件中的用户是否能够访问vsftpd服务,
  取决于userlist_deny指令
  no:默认
userlist_file=/etc/vsftpd/user_list 用户列表文件
userlist_deny=YES default 此列表文件为黑名单，不需要输入密码
userlist_deny=NO 此列表为白名单

/etc/vsftpd/ftpuser 输入密码

# 文本传输，影响效率（二进制文件？）
#ascii_upload_enable=YES
#ascii_download_enable=YES

# 目录消息
dirmessage_enable=YES 用户第一次切换进入目录时，
vsftpd会查看.message文件的内容显示给用户
message_file=.message 指定dirmessage_enable命令的查看的文件路径，
而不使用默认的.message

# vim /var/ftp/upload/.message
  anonymous login succesful
  hello world
# ftp IP
ftp> cd upload
  250-anonymous login succesful
  250-hello world
  250 Directory successfully changed.

# 数据传输日志
xferlog_enable=YES 是否开启传输日志文件
xferlog_file=/var/log/xferlog 传输日志文件
xferlog_std_format=YES 是否使用标准传输日志格式

# 数据传输模式
connect_from_port_20=NO 是否启用PORT模式

# 会话超时时长
idle_session_timeout=300 空闲会话超时时长(second)
connect_timeout=60 PORT模式下，服务器连接客户端的超时时长
data_connection_timeout=200 数据传输的超时时长

# 匿名用户默认配置
anonymous_enable=NO 是否使用匿名用户登录(默认yes，注意也是yes)
anon_upload_enable=NO 匿名用户(ftp用户)的上传操作
生效依赖于write_enable=yes
上传的文件映谢于ftp用户权限
anon_mkdir_write_enable=YES 匿名用户创建目录权限
anon_other_write_enable=YES 匿名用户删除及重命名操作权限

# 匿名用户上传文件的属主
chown_uploads=NO 修改匿名用户上传文件的属主
chown_username=root 启用chown_uploads指令时，
将文件属主修改为指令指定的用户；默认为root
chown_upload_mode=0600 设定匿名用户上传的文件的权限；默认为600
anon_max_rate 匿名用户的最大传输速率

# 本地用户默认配置
local_enable=NO 所有的非匿名的生效，都依赖于此指令
是否使用本地用户登录
开放匿名用户：NO
开放本地用户和虚拟用户：YES

local_umask=022 本地用户上传文件的权限掩码(文件666：644,目录777：775)
其它用户umask为077
local_max_rate=0 本地用户的传输速率，单位是字节；默认是0表示无限制

# 禁锢用户设置
chroot_local_user=YES	禁锢所有本地用户在其家目录下
注意：2.3.5之后，vsftpd增强了安全检查，要求用户不能对家目录有写权限 chmod a-w /home/username
或者：allow_writeable_chroot=YES

chroot_list_enable=YES 禁锢指定用户于家目录中，列表文件中的用户都被禁锢,，其他用户没有被禁锢
chroot_list_file=/etc/vsftpd/chroot_list 指定禁锢用户文件路径


1. 所有用户都被禁锢
chroot_local_user=YES
#chroot_list_enable=YES

2. chroot_list 禁锢黑名单
chroot_local_user=YES
chroot_list_enable=YES
只有chroot_list 文件的用户没被禁锢

3. chroot_list 禁锢白名单
chroot_local_user=NO 或 #chroot_local_user=NO
chroot_list_enable=YES
只有chroot_list 文件的用户被禁锢
```

## Client Command

``` SHELL
  bi 使用binary传输模式
  ha 显示hash进度
  rm -[rw]
    -r recurseive
    -f work quietly
  mv old new
```

## 配置

- `anonymous_enable=YES`
- `write_enable=YES`
- `anon_upload_enable=YES`
- 命令：lftp> put file 上传文件失败
- 错误：put: Access failed: 553 Could not create file. (fstab)
- 问题：匿名用户删除上传文件，用户默认映射为ftp用户，且/var/ftp目录权限是root权限，所有不能上传文件。
- 解决：

``` SHELL
# mkdir /var/ftp/upload
# chown ftp /var/ftp/upload
```

- 命令：lftp> mkdir 01 创建文件失败
- 配置：anon_mkdir_write_enable=YES 匿名用户创建文件开启
- 命令：lftp> rm fstab 删除文件失败
- 配置：anon_other_write_enable=YES 匿名用户删文件文件或重命名文件

``` FTP
lftp> rm fstab
lftp> rm -rf dir
lftp> mv file renamefile
```

- 匿名登录或用户登录

``` SHELL
# yum -y install ftp
# ftp IP
ftp> anonymous 匿名登录
```

## 虚拟用户

### 1. 基于db文件

``` SHELL
# vim /etc/vsftpd/vusers.txt文件
  奇数行：用户名
  偶数行：密码
```

### 2. 基于mysql服务: pam-mysql

- pam不支持mysql
- pam: `# ls -l /lib64/security/`
- pam-mysql-0.7RC1.tar.gz

#### CentOS 7：编译安装 MariaDB

``` shell
# yum -y groupinstall "Development Tools" "Server Platform Developemnt"
# yum -y install mariadb-server mariadb-devel openssl openssl-devel pam-devel
# systemctl start mariadb.service
# sytemctl enable mariadb.service
# mysql
```

#### 下载 [pam-mysql-0.7RC1.tar.gz](http://prdownloads.sourceforge.net/pam-mysql/pam_mysql-0.7RC1.tar.gz)

#### 安装 pam-mysql(http://pam-mysql.sourceforge.net/)

``` shell
# ./configure --with-mysql=/usr \
--with-openssl=/usr \
--with-pam=/usr \
--with-pam-mods-dir=/lib64/security
# make && make install
# ls -l /lib64/security/pam_mysql.so
```

#### 创建MySQL用户表账号和密码

``` sql
create database vsftpd;
CREATE TABLE users(
  id int AUTO_INCREMENT NOT NUL PRIMARY,
  name char(30) NOT NULL,
  password char(48) binary NOT NULL; --bainary区分字符大小写
);
INSERT INTO users(name,password) VALUES ('tom',password('tom'));
INSERT INTO users(name,password) VALUES ('jerry',password('jerry'));
GRANT select ON vsftpd.* TO vsftpd@localhost IDENTIFIED BY 'vsftpd';
GRANT select ON vsftpd.* TO vsftpd@'127.0.0.1' IDENTIFIED BY 'vsftpd';
flush privileges;
```

#### 配置vsftpd

``` shell
# vim /etc/vsftpd/vsftpd.conf
  pam_service_name=vsftpd vsftpd使用哪个pam配置文件
# man vsftpd.conf
  pam_service_name ...
# less /etc/pam.d/vsftpd
```

#### 配置文件pam_mysql

``` shell
# less pam_mysql-0.7RC1/README
  auth: 认证
  account: 账号
  pam_mysql.so相对于/lib64/security目录
  required：必须认证
  user和passwd：mysql账号和密码
  usercolum：用户名的字段
  passwdcolum：密码字段
  crypt: (加密方式) 0:plain | 1:crypt(3) function | 2:mysql PASSWORD() |
  3:md5 | 4:sha1

# vim /etc/pam.d/vsftpd.mysql
auth required pam_mysql.so user=vsftpd passwd=vsftpd host=localhost db=vsftpd table=users usercolumn=name passwdcolumn=password crypt=2
account required pam_mysql.so user=vsftpd passwd=vsftpd host=localhost db=vsftpd table=users usercolumn=name passwdcolumn=password crypt=2
```

#### 创建虚拟用户：映射用户

``` shell
# useradd -s /sbin/nologin -d /ftproot vuser
# ls -ld /ftproot
# chmod go+rx /ftproot/
# chmod -w /ftproot/
# mkdir /ftproot/{pub,upload}
# vim /etc/vsftpd/vsftpd.conf
  anonymous_enable=YES
  local_enable=YES
  local_umask=022
  pam_service_name=vsftpd.mysql

  # 来宾账号映射为vuser
  guest_enable=YES
  guest_username=vuser
# systemctl start vsftpd.service
# chown vuser /ftproot/upload
# ls -ld /ftproot/upload 是否有写权限
# vim /etc/vsftpd/vsftpd.conf
  anon_upload_enable=YeS
# systemctl retart vsftpd.service
# ftp 172.18.100.67
: tom
ftp> ls
ftp>bye
# ftp 172.18.100.67
: jerry
ftp> ls
```

#### tom与jerry只能一个用户上传权限

``` shell
# vim /etc/vsfptd/vsftpd.conf
  anon_upload_enable=YES
# mkdir vusers.conf.d
# cd vusers.conf.d
# vim tom
  local_root=/ftproot/upload/tom
  write_enable=YES
  download_enable=YES
  anon_world_readable_only=NO
  anon_upload_enable=YES
  anon_mkdir_write_enable=YES
  anon_other_write_enable=YES
  local_umask=022
  anon_upload_enable=YES

# cp tom jerry
# vim jerry
  anon_upload_enable=NO
# vim vsftpd.conf
  user_config_dir=/etc/vsftpd/vusers.conf.d
# systemctl restart vsftpd.service
```

#### 测试：登录ftp，上传文件

### 基于vsftpd+pam+mysql架设ftp并实现虚拟用户登录

- 测试之前需要保证本机的SElinux是关闭的，否则会造成失败的！ 

``` shell
立即关闭 SElinux
# setenforce 0  

永久关闭 SElinux
# vim /etc/selinux/config

由于FTP服务的传输都是明文的，在网络上非常不安全，我们可以利用openssh来对ftp服务的传输进行加密，既是sftp服务。

1. 建立CA、自签证书

1.1 生成CA和CA的自签证书
# cd /etc/pki/CA
# mkdir certs newcerts crl
# touch index.txt serial
# echo 01 > serial

1.2 创建CA的私钥
# (umask 007;openssl genrsa –out priviate/cakey.pem 2048);`

1.3 生成自签证书
# openssl req -new -x509 -key private/cakey.pem -out cacert.pem -days 365

2. 为vsftp服务进行CA认证
# mkdir /etc/vsftpd/ssl
# cd /etc/vsftpd/ssl

生成私钥和认证的公钥
# (umask 077;openssl genrsa -out vsftpd.key 2048);
# openssl req -new -key vsftpd.key -out vsftpd.csr

修改CA目录，修改的话必须在特定的目录下才能签署证书
# vim /etc/pki/tls/openssl.cnf
  dir = /etc/pki/CA

签署证书
# openssl ca -in vsftpd.csr -out vsftpd.crt

3. ftp配置使用加密的认证方式
# vim /etc/vsftpd/vsftpd.conf
  ssl_enable=YES        开启ssl功能  
  ssl_tlsv1=YES         开启支持tlsv1
  ssl_sslv2=YES
  ssl_sslv3=YES
  allow_anon_ssl=NO     是否开启匿名用户利用ssl
  force_local_data_ssl=YES      开启系统用户数据传输利用ssl
  force_local_logins_ssl=YES    开启系统用户登录利用ssl
  rsa_cert_file=/etc/vsftpd/ssl/vsftpd.crt   指定证书位置
  rsa_private_key_file=/etc/vsftpd/ssl/vsftpd.key 指定私钥位置

4. 重启服务、验证
匿名用户访问正常
系统账号不允许登录，登入需要密码
```

## 总结

- ftp: 命令连接，数据连接(PORT,PASV)
- 用户类型
  - 匿名用户
  - 本地用户
    - 禁锢
    - 黑名单
    - 白名单
- 虚拟用户
  - 权限

## 博客：vsftpd的基于pam_mysql的虚拟用户机制