# 阿里云ECS裸机配置

## 账号配置

1. 修改root密码：云服务器ECS->实例->实例列表->实例->更多->密码/秘钥->重置实例密码->**重启实例**
2. 使用ssh协议root账号登录并创建普通登录账号和密码

```sh
登录
# ssh root@IP地址

创建普通登录用户
# useradd 用户名

修改普通登录用户密码
# passwd 用户名
```

3. 禁止root账号远程登录

```sh
# vim /etc/ssh/sshd_config
  PermitRootLogin no

重启 sshd 服务
# systemctl restart sshd
```

## Setup系统开发工具

```sh

# yum -y install lrzsz

安装系统开发工具包
# yum -y groupinstall "Development Tools" "Server Platform Development"

查看系统版本
# lsb_release -a

安装 git 源码构建
# git --version

安装编译依赖软件
# yum -y install curl-devel expat-devel gettext-devel openssl-devel zlib-devel asciidoc install gcc perl-ExtUtils-MakeMaker


yum install curl-devel  expat-devel -y

卸载老版本
# yum remove git

下载最新版本
# cd /usr/local/src/
# wget https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.34.0.tar.xz --no-check-certificate
# tar -vxf git-2.34.0.tar.xz 
# cd git-2.34.0

编译: 编译时发生错误，可能未安装依赖软件包
# make prefix=/usr/local/git all
# make prefix=/usr/local/git install

环境变量设置
[Root 用户添加环境变量]
# echo "export PATH=$PATH:/usr/local/git/bin" >> /etc/profile

生效环境变量
# source /etc/profile

或者
# vim /etc/profile.d/git.sh
  export PATH=$PATH:/usr/local/git/bin

生效环境变量
# source /etc/profile.d/git.sh

[其他用户:登录该用户, 配置该用户下的环境变量]

# su - username
$ echo "export PATH=$PATH:/usr/local/git/bin" >> ~/.bashrc
$ source ~/.bashrc

验证
# git --version
```


# 先检查是否安装了iptables
`service iptables status`

# 安装iptables
`yum install -y iptables`

# 升级iptables
`yum update iptables `

# 安装iptables-services
`yum install iptables-services`



### 禁用/停止自带的firewalld服务

# 停止firewalld服务
`systemctl stop firewalld`

# 禁用firewalld服务
`systemctl mask firewalld`

cd /etc/sysconfig 到这个目录下 vi iptables

增加一句

-A INPUT -m state --state NEW -m tcp -p tcp --dport 6379 -j ACCEPT

-A INPUT -m state --state NEW -m tcp -p tcp --dport 27017 -j ACCEPT

注：6379是redis默认端口，如果你修改了端口，请增加对应的


#查看iptables现有规则
iptables -L -n
#先允许所有,不然有可能会杯具
iptables -P INPUT ACCEPT
#清空所有默认规则
iptables -F
#清空所有自定义规则
iptables -X
#所有计数器归0
iptables -Z
#允许来自于lo接口的数据包(本地访问)
iptables -A INPUT -i lo -j ACCEPT
#开放22端口
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
#开放21端口(FTP)
iptables -A INPUT -p tcp --dport 21 -j ACCEPT
#开放80端口(HTTP)
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
#开放443端口(HTTPS)
iptables -A INPUT -p tcp --dport 443 -j ACCEPT
#允许ping
iptables -A INPUT -p icmp --icmp-type 8 -j ACCEPT
#允许接受本机请求之后的返回数据 RELATED,是为FTP设置的
iptables -A INPUT -m state --state  RELATED,ESTABLISHED -j ACCEPT
#其他入站一律丢弃
iptables -P INPUT DROP
#所有出站一律绿灯
iptables -P OUTPUT ACCEPT
#所有转发一律丢弃
iptables -P FORWARD DROP

#如果要添加内网ip信任（接受其所有TCP请求）
iptables -A INPUT -p tcp -s 45.96.174.68 -j ACCEPT
#过滤所有非以上规则的请求
iptables -P INPUT DROP
#要封停一个IP，使用下面这条命令：
iptables -I INPUT -s ***.***.***.*** -j DROP
#要解封一个IP，使用下面这条命令:
iptables -D INPUT -s ***.***.***.*** -j DROP

#保存上述规则
service iptables save

#注册iptables服务
#相当于以前的chkconfig iptables on
systemctl enable iptables.service
#开启服务
systemctl start iptables.service
#查看状态
systemctl status iptables.service

最后重启防火墙使配置生效
/etc/init.d/iptables restart 

1.首先在/etc/sysconfig/iptables-config中修改或者添加以下内容

#添加以下内容,注意顺序不能调换
IPTABLES_MODULES="ip_conntrack_ftp"
IPTABLES_MODULES="ip_nat_ftp"
2.重新设置iptables设置

iptables -A INPUT -m state --state  RELATED,ESTABLISHED -j ACCEPT

```sh
执行如下命令
# systemctl stop firewalld
# systemctl mask firewalld

安装iptables-service
# yum install iptables-services

设置开机启动
# systemctl enable iptables

保存设置
# service iptables save


1.清除所有规则：
iptables  -F

2.开放常用tcp端口：
iptables  -I  INPUT  -p  tcp  -m  multiport  --dports 20,21,22,3306,27017,6379,80,443,25,110,8000:9000  -j  ACCEPT
iptables  -I  OUTPUT  -p  tcp  -m  multiport  --sports 20,21,22,3306,6379,27017,80,443,25,110,8000:9000  -j  ACCEPT

3.开放常用udp端口：
iptables  -I  INPUT  -p  udp  -m  multiport  --dports  53  -j  ACCEPT
iptables  -I  OUTPUT  -p  udp  -m  multiport  --sports  53  -j  ACCEPT

4.开放特殊udp端口（如：dns）：
iptables  -I  INPUT  -p  udp  --sport  53  -j  ACCEPT
iptables  -I  OUTPUT  -p  udp  --dport  53  -j  ACCEPT

5.开放vrrp协议：
iptables  -I  INPUT  -p  vrrp  -j  ACCEPT

6.允许服务器互ping：
iptables  -A  OUTPUT  -p  icmp  -j  ACCEPT
iptables  -A  INPUT  -p  icmp  -j  ACCEPT

7.允许握手成功的数据通过：
iptables  -I  INPUT  -p  tcp  -m  state  --state  RELATED,ESTABLISHED  -j  ACCEPT
iptables  -I  OUTPUT  -p  tcp  -m  state  --state  RELATED,ESTABLISHED  -j  ACCEPT

8.设置默认关闭所有端口：
iptables  -P  FORWARD  DROP
iptables  -P  OUTPUT  ACCEPT
iptables  -P  INPUT  DROP

9.防syn***：
iptables  -N  syn-flood 
iptables  -A  INPUT  -p  tcp  --syn  -j  syn-flood 
iptables  -I  syn-flood  -p  tcp  -m  limit  --limit  3/s  --limit-burst  6  -j  RETURN 
iptables  -A  syn-flood  -j  REJECT

10.防ddos***：
iptables  -A  INPUT  -i  eth0  -p  tcp  --syn  -m  connlimit  --connlimit-above  15 -j  DROP 
iptables  -A  INPUT  -p  tcp  -m  state  --state  ESTABLISHED,RELATED  -j  ACCEPT
iptables  -A  INPUT  -p  tcp  --syn  -m  limit  --limit  12/s  --limit-burst  24  -j  ACCEPT
iptables  -A  FORWARD  -p  tcp  --syn  -m  limit  --limit  1/s  -j  ACCEPT

11.防cc***：
iptables  -I  INPUT  -p  tcp  --dport  80  -m  connlimit  --connlimit-above  50  -j  REJECT  # 允许单个IP的最大连接数为30
iptables  -A  INPUT  -p  tcp  --dport  80  -m  recent  --name  BAD_HTTP_ACCESS  --update  --seconds  60  --hitcount  30  -j  REJECT
iptables  -A  INPUT  -p  tcp --dport  80  -m  recent  --name  BAD_HTTP_ACCESS  --set  -j  ACCEPT
#单个IP在60秒内只允许最多新建30个连接


12.保存：
iptables-save  >  /etc/sysconfig/iptables



#!/bin/sh
iptables -P INPUT ACCEPT
iptables -F
iptables -X
iptables -Z
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -p tcp --dport 21 -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT
iptables -A INPUT -p icmp --icmp-type 8 -j ACCEPT
iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -P INPUT DROP
iptables -P OUTPUT ACCEPT
iptables -P FORWARD DROP
service iptables save
systemctl restart iptables.service
```



## Node开发工具

[Install NVM](https://github.com/nvm-sh/nvm)

```sh
# curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash


查看nvm版本
# nvm --version

查看都有哪些版本可以安装
# nvm ls-remote

安装版本
# nvm install v14.20.1

查看一下当前已经安装的版本
# nvm ls

切换版本
# nvm use v14.20.1

设置默认版本
# nvm alias default v14.20.1

# echo "用户名 ALL=(ALL) NOPASSWD:ALL">> /etc/sudoers
```

## 安装 MariaDB

- 系统：CentOS 7.5.1804
- 软件：MariaDB 10.3.16
- 依赖软件：Cmake、Ncurses、Bison 、Boost

### 创建MariaDB安装目录、数据库存放目录、建立用户和目录

> 先创建一个名为mysql且没有登录权限的用户和一个名为mysql的用户组，然后安装mysql所需的依赖库和依赖包，最后通过cmake进行安装的详细配置。

#### 创建mysql用户组

> 创建`mysql`用户组(`-r`选项是创建一个系统用户组的意思)

`# groupadd -r mysql`

#### 创建用户并加入到mysql系统用户组

`# useradd -r -g mysql -s /sbin/nologin -d /usr/local/mysql -M mysql`

### 创建数据库相关目录

```sh
# mkdir -pv /data/mysql
# chown -R mysql:mysql /data/mysql/
```

### 删除CentOS 默认数据库配置文件

```sh
# find -H /etc/ | grep my.c

/etc/my.cnf.d
/etc/my.cnf.d/mysql-clients.cnf
/etc/pki/tls/certs/make-dummy-cert
/etc/pki/tls/certs/renew-dummy-cert
/etc/my.cnf

# rm -rf /etc/my.cnf /etc/my.cnf.d/

# find -H /etc/ | grep my.c

/etc/pki/tls/certs/make-dummy-cert
/etc/pki/tls/certs/renew-dummy-cert
```

### 卸载系统自带mariadb-libs

```sh
查询
# rpm -qa | grep mariadb*
  mariadb-libs-5.5.65-1.el7_5.x86_64

卸载
# rpm -e mariadb-libs-5.5.60-1.el7_5.x86_64 --nodeps
```

### 安装相关包

```sh
# yum -y install libaio libaio-devel bison bison-devel zlib-devel openssl openssl-devel ncurses ncurses-devel libcurl-devel libarchive-devel boost boost-devel lsof wget gcc gcc-c++ make cmake perl kernel-headers kernel-devel pcre-devel
```

### 准备二进制程序

```sh
# cd /usr/local/src
# wget https://tw1.mirror.blendbyte.net/mariadb//mariadb-10.11.3/bintar-linux-systemd-x86_64/mariadb-10.11.3-linux-systemd-x86_64.tar.gz --no-check-certificate
# tar xvf mariadb-10.11.3-linux-systemd-x86_64.tar.gz -C /usr/local
# cd /usr/local
# ln -sv mariadb-10.5.16  mysql
# cd /usr/local/mysql
# chown -R root:mysql ./*
```

### 准备配置文件

```sh
# cd /usr/local/mysql/support-files
# mkdir /etc/mysql/
# cp wsrep.cnf /etc/mysql/my.cnf
# vim  /etc/mysql/my.cnf
  [mysqld]

  # 数据库的数据存放存目
  datadir = /data/mysql

  # 数据库中有很多表，加上这一行就可以使每个表单独生成一个文件
  innodb_file_per_table = on

  # 为了加速访问速度，忽略名字的反向解析
  skip_name_resolve = on  

  character-set-server = utf8mb4  
  collation-server = utf8mb4_unicode_ci  
  init_connect='SET NAMES utf8mb4'  
  skip-character-set-client-handshake = true  
  [client]  
  default-character-set=utf8mb4  
  
  [mysql]  
  default-character-set = utf8mb4
```

```sql
mysql> alter database db_herbal_medicine charset=utf8mb4 collate=utf8mb4_general_ci;
mysql> show variables like'character%';
mysql> show variables like'collation%';
```

### 创建数据库文件

```sh
# cd /usr/local/mysql/
# ./scripts/mysql_install_db  --user=mysql --datadir=/data/mysql
# ls /data/mysql
```

### 准备日志文件

```sh
# mkdir /var/log/mysql  
# chown mysql /var/log/mysql/  
```

### 启动服务

```sh
# cp support-files/mysql.server  /etc/init.d/mysqld
# chkconfig --add mysqld
# service mysqld start
# chkconfig mysqld on
# ss -nutl | grep 3306
```

### 添加PATH变量，以方便来运行mysql程序

```sh
# vim  /etc/profile.d/mysql.sh
  export PATH=$PATH:/usr/local/mysql/bin

# source /etc/profile.d/mysql.sh
```

### 运行mysql安全脚本

```sh
# cd /usr/local/mysql/bin
# ./mysql_secure_installation
```

### 测试链接数据库

```sh
# mysql -u root -p
```

### 创建账号

```sql
create database test;
grant all privileges on test.* to  test@'%' identified  BY '密码';


GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, RELOAD, SHUTDOWN, PROCESS, FILE,
REFERENCES, INDEX, ALTER, SHOW DATABASES, SUPER, CREATE TEMPORARY TABLES,
 LOCK TABLES, EXECUTE, REPLICATION SLAVE, REPLICATION CLIENT  ON *.* TO 'shsadmin'@'%'
IDENTIFIED BY '' WITH GRANT OPTION;

flush privileges;
```

### 删除用户

```sql
> mysql -u root -p
> DELETE FROM user WHERE User="admin" and Host="localhost";
> flush privileges;
```

### 修改指定用户密码

```sql
> mysql -u root -p
> update mysql.user set password=password('新密码') where User="admin" and Host='%';
> flush privileges
```

### 管理员设置密码

```sh
# ./bin/mysqladmin -u root password 'new-password'
# ./bin/mysqladmin -u root -h iZ2ze3hmvt6cdm95w7xouhZ password 'new-password'
```

### You can start the MariaDB daemon with:

`cd '.' ; ./bin/mysqld_safe --datadir='/data/mysql'`

## 码云配置

```sh
# git config --global user.name "yourusername"
# git config --global user.email "youremail"

冲突merge使用版本 git config --global merge.tool "kdiff3" (没装kdiff3忽略本行)
让Git不要管Windows/Unix换行符转换的事

# git config --global core.autocrlf false

避免git gui中的中文乱码
# git config --global gui.encoding utf-8

避免git status显示的中文名乱码
# git config --global core.quotepath off

git ssh key pair配置 码云配置 生成 ssh key pair
# ssh-keygen -t rsa -C "xxxx@xx.com"

# ssh-add ~/.ssh/id_rsa
如果出现 Could not open a connection to your authentiacation agent 执行 eval `ssh-agent`

# ssh-add ~/.ssh/rsa
# ssh-add l

查看
# cat ~/.ssh/id_rsa.pub

将公钥复制出来

gitlib右上角个人资料，进入SSH公钥配置 复制的东西加进去提交

# git remote add origin git@gitee.com:wovert/nuxt-bnhcp.git
# git push origin master
# git remote show origin

永久保存密码
# git config --global credential.helper store
```

## nginx下载安装

### 安装相关的依赖包

```sh
yum -y install lrzsz gcc gcc-c++ autoconf automake make pcre pcre-devel zlib zlib-devel openssl openssl-devel
```
scp files.tar.gz root@154.38.119.14:/usr/local/src
### 下载nginx包

```sh
wget http://nginx.org/download/nginx-1.16.0.tar.gz
tar -zxvf nginx-1.16.0.tar.gz
cd nginx-1.16.0
```

### 编译安装

```sh
useradd -r www

./configure \
--prefix=/usr/local/nginx \
--pid-path=/var/run/nginx/nginx.pid \
--lock-path=/var/lock/nginx.lock \
--conf-path=/etc/nginx/nginx.conf \
--error-log-path=/var/log/nginx/error.log \
--http-log-path=/var/log/nginx/access.log \
--user=www \
--group=www \
--http-client-body-temp-path=/var/tmp/nginx/client \
--http-proxy-temp-path=/var/tmp/nginx/proxy \
--http-fastcgi-temp-path=/var/tmp/nginx/fastcgi \
--http-uwsgi-temp-path=/var/tmp/nginx/uwsgi \
--http-scgi-temp-path=/var/cache/nginx/scgi \
--with-http_ssl_module \
--with-http_stub_status_module \
--with-http_gzip_static_module \
--with-http_flv_module \
--with-http_mp4_module \
--with-http_geoip_module

make && make install

cd /etc/nginx/ && cp nginx.conf{,.bak}
```

### 环境变量配置

```sh
# vim  /etc/profile.d/nginx.sh
  export PATH=$PATH:/usr/local/nginx/sbin

# source /etc/profile.d/nginx.sh

# mkdir -pv /var/tmp/nginx/client
# mkdir -pv /var/cache/nginx/scgi
```

### 相关服务

- 启动服务: `# cd /usr/local/nginx/sbin && ./nginx`
- 重读配置文件: `# nginx -HUB PID`
- 关闭服务-PID(主进程号): `# kill -QUIT pid`
- kill -signal : `# cat /usr/local/nginx/log/nginx.pid`


### Nginx设置成服务并开机自动启动

在/etc/init.d下创建文件nginx

`[root@localhost ~]# vim /etc/init.d/nginx`
其内容参考nginx官方文档

需要注意的配置：
`
nginx="/usr/local/nginx/sbin/nginx" # 修改成nginx执行程序的路径
NGINX_CONF_FILE="/etc/nginx/nginx.conf" # 修改成nginx.conf文件的路径
`
 
保存后设置文件的执行权限

`[root@localhost ~]# chmod a+x /etc/init.d/nginx`
至此就可以通过下面指令控制启动停止

```
/etc/init.d/nginx start
/etc/init.d/nginx stop
```

上面的方法完成了用脚本管理nginx服务的功能，但是还是不太方便。

先将nginx服务加入chkconfig管理列表：

[root@localhost ~]# chkconfig --add /etc/init.d/nginx
加完这个之后，就可以使用service对nginx进行启动，重启等操作了。

```
service nginx start
service nginx stop
service nginx restart
```
最后设置开机自动启动

`[root@localhost ~]# chkconfig nginx on`



```sh
# vim /usr/lib/systemd/system/nginx.service

[Unit]
Description=nginx-The High-performance HTTP Server		 // 描述服务
After=network.target remote-fs.target nss-lookup.target		// 描述服务类别

[Service]
Type=forking		// 后台运行的形式
PIDFile=/var/run/nginx/nginx.pid		// PID文件的路径
ExecStartPre=/usr/local/nginx/sbin/nginx -t -c /etc/nginx/nginx.conf		// 启动准备
ExecStart=/usr/local/nginx/sbin/nginx -c /etc/nginx/nginx.conf		//启动命令
ExecReload=/usr/local/nginx/sbin/nginx -s reload		// 重启命令
ExecStop=/usr/local/nginx/sbin/nginx -s stop		    // 停止命令
ExecQuit=/usr/local/nginx/sbin/nginx -s quit		    // 快速停止
PrivateTmp=true		// 给服务分配临时空间

[Install]
WantedBy=multi-user.target		// 服务用户的模式

# chmod +x nginx.service		// 赋予该文件执行权限
# systemctl daemon-reload		// 在启动服务之前，需要先重载systemctl命令
# systemctl start nginx		    // 启动nginx服务
# netstat -ntulp |grep nginx
```



## redis 安装配置

```sh
# yum install gcc gcc-c++

# wget [redis-7.0.1](http://download.redis.io/releases/redis-7.0.1.tar.gz)
# tar -xzvf redis-7.0.1.tar.gz
# cd redis-7.0.1
# make && make install PREFIX=/usr/local/redis
# mkdir /usr/local/redis/etc
# cp redis.conf /usr/local/redis/etc/


不推荐直接在前台运行Redis，如果用 ctrl+z 将 redis 切换到后台后，此时 redis 将被挂起，不能被连接。所以推荐以下方式运行Redis。不仅可以后台运行，加载自己的配置文件，还可以输入日志到 redis.log 中。



创建用户
# useradd -r -s /sbin/nologin redis

更改目录属主属组
# chown -R redis.redis /usr/local/redis/

创建文件目录
# mkdir /apps/redis/{etc,run,data,logs}

创建命令软链接
# ln -sv /apps/redis/bin/redis-* /usr/sbin/

添加systemctl服务
# vim /lib/systemd/system/redis.service
[Unit]
Description=Redis
After=network.target

[Service]
PIDFile=/var/run/redis_6379.pid
ExecStart=/usr/local/redis/bin/redis-server /usr/local/redis/etc/redis.conf --supervised systemd
ExecReload=/bin/kill -s HUP $MAINPID
ExecStop=/bin/kill -s QUIT $MAINPID
Type=notify
User=redis
Group=redis
RuntimeDirectory=redis
RuntimeDirectoryMode=0755

[Install]
WantedBy=multi-user.target


创建软连接#系统初始化时自动启动服务
# ln -s /lib/systemd/system/redis.service /etc/systemd/system/multi-user.target.wants/redis.service

查看软连接是否成功
# ll /etc/systemd/system/multi-user.target.wants/

重载系统服务
# systemctl daemon-reload

启动redis
# systemctl start redis
# systemctl status redis

设置开机启动
# systemctl enable redis
```

查看运行的redus：

`# ps -ef | grep redis`

强制关闭

`# kill -9 pid`

Redis5 允许远程连接

redis 默认只允许自己的电脑（127.0.0.1）连接。如果想要其他电脑进行远程连接，将 配置文件 redis.conf 中的 bind 127.0.0.1 后添加自己的ip即可。然后重新运行redis服务。

```sh
# vim redis.conf
  bind 127.0.0.1 10.10.10.10 123.123.123.123
  protected-mode no
```

Redis5 增加密码

redis 增加密码需要修改 redis.conf 配置文件，将 requirepass 的注释解除掉，在后面加上自己的密码。然后重新运行 redis 服务。

1. 初始化Redis密码：requirepass test123（需重启Redis才能生效）redis的查询速度是非常快的，外部用户一秒内可以尝试多大150K个密码；所以密码要尽量长（对于DBA 没有必要必须记住密码）；

2. 不重启Redis设置密码：`redis 127.0.0.1:6379> config set requirepass test123`

查询密码：
```sh
redis 127.0.0.1:6379> config get requirepass
(error) ERR operation not permitted

密码验证：

redis 127.0.0.1:6379> auth test123
OK

再次查询：

redis 127.0.0.1:6379> config get requirepass
1) "requirepass"
2) "test123"
```

如果配置文件中没添加密码 那么redis重启后，密码失效

在登录的时候的时候输入密码：`redis-cli -p 6379 -a test123`

先登陆后验证：

```sh
# redis-cli -p 6379`
redis 127.0.0.1:6379> auth test123
```

AUTH命令跟其他redis命令一样，是没有加密的；阻止不了攻击者在网络上窃取你的密码；

认证层的目标是提供多一层的保护。如果防火墙或者用来保护redis的系统防御外部攻击失败的话，外部用户如果没有通过密码认证还是无法访问redis的

### NERDTree

```sh
# wget http://www.vim.org/scripts/download_script.php?src_id=17123 -O nerdtree.zip
# unzip nerdtree.zip
# mkdir -p ~/.vim/{plugin,doc}
# cp plugin/NERD_tree.vim ~/.vim/plugin/
# cp doc/NERD_tree.txt ~/.vim/doc/

安装好后，命令行中输入vim，打开vim后，在vim中输入`:NERDTree`，你就可以看到NERDTree的效果了。

使用说明
  1、在linux命令行界面，输入vim
  2、输入  :NERDTree ，回车
  3、进入当前目录的树形界面，通过小键盘上下键，能移动选中的目录或文件
  4、目录前面有+或者>号，摁Enter会展开目录，文件前面是-号，摁Enter会在右侧窗口展现该文件的内容，光标自动移到右侧文件窗口。
  5、ctr+w+h  光标移到左侧树形目录，ctrl+w+l 光标移到右侧文件显示窗口。多次摁 ctrl+w，光标自动在左右侧窗口切换
  6、光标focus左侧树形窗口，摁? 弹出NERDTree的帮助，再次摁？关闭帮助显示
  7、输入:q回车，关闭光标所在窗口

进阶用法
  o 打开关闭文件或者目录
  t 在标签页中打开
  T 在后台标签页中打开
  ! 执行此文件
  p 到上层目录
  P 到根目录
  K 到第一个节点
  J 到最后一个节点
  u 打开上层目录
  m 显示文件系统菜单（添加、删除、移动操作）
 ? 帮助
 q 关闭
```

## php7 安装

``` sh
# cd /usr/local/src && wget https://www.php.net/distributions/php-7.4.29.tar.gz
# tar -xzxvf php-7.4.29.tar.gz


yum -y install libxml2 

yum -y install libxml2-devel 

yum -y install openssl 

yum -y install openssl-devel 

yum -y install curl-devel 

yum -y install libjpeg-devel 

yum -y install libpng-devel 

yum -y install freetype-devel 

yum -y install bzip2-devel 

yum -y install libmcrypt libmcrypt-devel 

yum -y install postgresql-devel 

yum -y install aspell-devel 

yum -y install readline-devel 

yum -y install libxslt-devel 

yum -y install net-snmp-devel 


yum -y install unixODBC-devel 

yum -y install libicu-devel 

yum -y install libc-client-devel 

yum -y install libXpm-devel 

yum -y install libvpx-devel 

yum -y install enchant-devel 

yum -y install openldap 

yum -y install openldap-devel 

yum -y install db4-devel 

yum -y install gmp-devel 

yum -y install sqlite-devel 

yum -y install mysql-devel


# yum install -y gcc gcc-c++  make zlib zlib-devel pcre pcre-devel  libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel libxml2 libxml2-devel glibc glibc-devel glib2 glib2-devel bzip2 bzip2-devel ncurses ncurses-devel curl curl-devel e2fsprogs e2fsprogs-devel krb5 krb5-devel openssl openssl-devel openldap openldap-devel nss_ldap openldap-clients openldap-servers libXpm-devel postgresql-devel  libxslt-devel  icu libicu libicu-devel

./configure \
--prefix=/usr/local/php \
--with-config-file-path=/usr/local/php/etc/ \
--enable-ftp \
--enable-zip \
--enable-fpm \
--enable-xml \
--enable-cli \
--enable-soap \
--enable-exif \
--enable-pcntl \
--enable-posix \
--enable-bcmath \
--enable-session \
--enable-sockets \
--enable-opcache \
--enable-sysvsem \
--enable-sysvshm \
--enable-mbregex \
--enable-mbstring \
--enable-calendar \
--enable-tokenizer \
--enable-gd \
--with-external-gd \
--with-avif \
--with-webp \
--with-jpeg \
--with-png \
--with-xpm \
--with-freetype \
--enable-gd-jis-conv \
--with-gettext \
--with-libxml \
--with-xsl \
--with-bz2 \
--with-curl \
--with-pear \
--with-zlib \
--with-iconv \
--with-pgsql \
--with-mhash \
--with-xmlrpc \
--with-openssl \
--with-gettext \
--with-zlib-dir \
--with-pdo-pgsql \
--with-pcre-regex \
--with-fpm-user=www \
--with-fpm-group=www \
--with-mysqli=mysqlnd \
--with-libxml-dir=/usr \
--with-pdo-mysql=mysqlnd \
--with-libdir=/lib/x86_64-linux-gnu/ \
--disable-rpath \
--enable-inline-optimization \
--with-iconv=/usr/local/bin/ \
--enable-zip

make ZEND_EXTRA_LIBS='-liconv'
make install


手动编译 gd

https://github.com/libgd/libgd/releases/download/gd-2.3.3/libgd-2.3.3.tar.gz


安装php8.1 编译时提示configure: error: iconv does not support errno

wget https://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.17.tar.gz

tar -xzvf libiconv-1.17.tar.gz
cd libiconv-1.17
./configure --prefix=/usr/local/libiconv

. 编辑 /etc/ld.so.conf这个文件，最后面添加以下内容
`/usr/local/lib
接着执行下面的命令立即生效

`# ldconfig -f`




No package 'oniguruma' found解决
安装PHP7.4找不到 No package 'oniguruma' found

一、oniguruma是什么？
oniguruma是一个处理正则表达式的库，我们之所以需要安装它，
是因为在安装php7.4的过程中，mbstring的正则表达式处理功能对这个包有依赖性，
所以我们要先安装这个库

```sh
wget https://github.com/kkos/oniguruma/archive/v6.9.4.tar.gz -O oniguruma-6.9.4.tar.gz 
tar -zxvf oniguruma-6.9.4.tar.gz
cd oniguruma-6.9.4/
./autogen.sh
./configure
make
sudo make install
```

# php --ini

configure: error: off_t undefined; check your library configuration
# vim /etc/ld.so.conf
/usr/local/lib64
/usr/local/lib
/usr/lib
/usr/lib64
# ldconfig -v


configure: error: Please reinstall the libzip distribution
1. 移除旧的 libzip：
# yum remove libzip

2. 安装新版本
# curl -O https://libzip.org/download/libzip-1.5.1.tar.gz
# tar -zxvf libzip-1.5.1.tar.gz
# cd libzip-1.5.1
# mkdir build
# cd build
# cmake ..
# make && make install

注意：如果提示cmake版本过低，需新版本，则需要重新安装cmake
注意：低版本的可能不需要cmake，例如1.2版本：

# curl -O https://nih.at/libzip/libzip-1.2.0.tar.gz
# tar -zxvf libzip-1.2.0.tar.gz
# cd libzip-1.2.0
# ./configure
# make && make install

configure: error: Please reinstall the BZip2 distribution
# yum install bzip2-devel.x86_64 -y
# wget http://ftp.gnu.org/gnu/bison/bison-2.4.1.tar.gz
# tar -zxvf bison-2.4.1.tar.gz
# cd bison-2.4.1/
# ./configure

configure: error: GNU M4 1.4 is required
# yum install m4
# make clean && make install

centos7 安装php7.3.3 解决报错 /usr/local/include/zip.h:59:21: fatal error: zipconf.h: No such file or 
#解决方法：手动复制过去
cp /usr/local/lib/libzip/include/zipconf.h /usr/local/include/zipconf.h

安装完成后切入php目录
继续配置checking发现错误：configure: WARNING: unrecognized options: --with-mcrypt, --enable-gd-native-ttf

这个是由于php7.2是 17年11月份发行的，在php7.1时，官方就开始建议用openssl_*系列函数代替Mcrypt_*系列的函数。所以我们删除这两项即可。

configure: WARNING: You will need re2c 0.13.4 or later if you want to regenerate PHP parsers.

# wget https://sourceforge.net/projects/re2c/files/0.16/re2c-0.16.tar.gz
# tar zxf re2c-0.16.tar.gz && cd re2c-0.16
# ./configure
# make && make install


configure: error: C++ compiler cannot create executables
就是gcc扩展没装全。
# yum install gcc gcc-c++ gcc-g77

No targets specified and no makefile found.  Stop.
# wget http://ftp.gnu.org/pub/gnu/ncurses/ncurses-5.6.tar.gz
# tar zxvf ncurses-5.6.tar.gz
# ./configure -prefix=/usr/src/php-7.3.8
# make && make install

# cd /usr/local/src/php7.3.8 && make && make install。
```

### php相关配置

安装完成后，我们要把源码包中的配置文件复制到PHP安装目录下，源码包中有两个配置  php.ini-development  php.ini-production

php配置文件

```sh
# cp php.ini-production /usr/local/php/etc/php.ini
# vim /usr/local/php/etc/php.ini
  display_errors=On
```

配置PHP-fpm

```sh
# cp /usr/local/php/etc/php-fpm.conf.default /usr/local/php/etc/php-fpm.conf
# cp /usr/local/php/etc/php-fpm.d/www.conf.default /usr/local/php/etc/php-fpm.d/www.conf
# ln -s /usr/local/php/sbin/php-fpm /usr/local/bin

# vim /usr/local/php/etc/php-fpm.d/www.conf
[www]

listen = 127.0.0.1:9080
listen.mode = 0666
user = www
group = www
pm = dynamic
pm.max_children = 128
pm.start_servers = 20
pm.min_spare_servers = 5
pm.max_spare_servers = 35
pm.max_requests = 10000
rlimit_files = 1024
slowlog = log/$pool.log.slow

# vim /usr/local/php/etc/php-fpm.conf
  pid = run/php-fpm.pid

# cp /usr/src/php-7.3.8/sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm
# chkconfig --add php-fpm
# service php-fpm start
# chkconfig php-fpm on
# chmod +x /etc/init.d/php-fpm
```

systemtl 服务

```sh
# cd php-7.3.8/sapi/fpm
# cp php-fpm.service /usr/lib/systemd/system/
# systemctl start php-fpm
```

设置环境变量

```sh
# vim /etc/profile.d/php.sh
  PATH=$PATH:/usr/local/php/bin
# source /etc/profile
# php -v
```

查看是否已经成功启动PHP

```sh
# ps -ef | grep php 或者 ps -A | grep -i php
```

## 升级cmake

`wget https://cmake.org/files/v3.10/cmake-3.10.2-Linux-x86_64.tar.gz`

- 如果原有cmake环境就是使用cmake的二进制包制作的，那么直接修改环境变量文件即可
- 如果原有环境是使用yum等工具安装，那么，我们先卸载已有的cmake：`yum remove cmake`

```sh
# tar zxvf cmake-3.10.2-Linux-x86_64.tar.gz
# vim /etc/profile.d/cmake.sh
  export CMAKE_HOME=/opt/cmake-3.10.2-Linux-x86_64
  export PATH=$PATH:$CMAKE_HOME/bin
# source /etc/profile
# cmake -version
```

## Linux PHP7 的 openssl扩展安装

Linux环境下使用PHPmailer发送邮件时，出现如下错误：

SMTP -> ERROR: Failed to connect to server: Unable to find the socket transport "ssl" - did you forget to enable it when you configured PHP? (32690)
出现这个问题的原因是当初编译安装PHP缺少了ssl库。

可以重新再次编译PHP，加上--enable-openssl参数即可。

但是如果只为了安装这一个扩展就去重新编译，未免有点麻烦，其实可以简单一点，只要安装openssl.so扩展就可以了。

1. 找到之前编译安装PHP的安装包，或者从php的官网下载php7（本例使用php7，其他版本的PHP类似）
2. 解压并进入文件夹 `cd php7.0/ext/openssl`
3. 运行 phpize: `/usr/local/php/bin/phpize`

备注，如果出现如下错误：Cannot find config.m4.

Make sure that you run '/usr/local/php/bin/phpize' in the top level source directory of the module

解决办法: `cp ./config0.m4 ./config.m4`

4. 编译和安装

```sh
# ./configure --with-openssl --with-php-config=/usr/local/php/bin/php-config
# make && make install
```

5. 然后进入最后提示的目录将 openssl.so 复制到PHP的扩展目录下: `cp openssl.so /usr/local/php/include/php/ext`

6. 找到php.ini，在最后面添加如下内容：`extension=openssl.so`

7. 重启 php-fpm 和 nginx/apache，查看`phpinfo()`

### 安装 swoole擴展

```sh
# cd /usr/local/src
# wget https://github.com/swoole/swoole-src/archive/master.tar.gz
# cd swoole-src && \
# phpize && \
# ./configure \
--enable-coroutine \
--enable-openssl  \
--enable-http2  \
--enable-async-redis \
--enable-sockets \
--enable-mysqlnd && \
# make clean && make && make install
# vim /usr/local/php/lib/php.ini
  extension=swoole.so
  
是否安装成功
# php -m

是否支持异步 redis
# php --ri swoole
```

## Yii框架部署

### 使用 Composer 安装 Yii

```sh
# curl -sS https://getcomposer.org/installer | php
# mv composer.phar /usr/local/bin/composer

Packagist 镜像使用方法
$ composer config -g repo.packagist composer https://packagist.phpcomposer.com

解除镜象
$ composer config -g --unset repos.packagist
```

### 安装Yii应用程序模板

```sh
$ cd /application
$ composer create-project --prefer-dist yiisoft/yii2-app-basic appName

$ wget https://github.com/yiisoft/yii2/releases/download/2.0.25/yii-basic-app-2.0.25.tgz

$ cd appName
$ php requirements.php
```

### nginx 配置

推荐使用的 Nginx 配置 ¶
为了使用 Nginx，你应该已经将 PHP 安装为 FPM SAPI 了。 你可以使用如下 Nginx 配置，将 path/to/basic/web 替换为实际的 basic/web 目录， mysite.local 替换为实际的主机名以提供服务。

server {
    charset utf-8;
    client_max_body_size 128M;

    listen 80; ## listen for ipv4
    #listen [::]:80 default_server ipv6only=on; ## listen for ipv6

    server_name mysite.test;
    root        /path/to/basic/web;
    index       index.php;

    access_log  /path/to/basic/log/access.log;
    error_log   /path/to/basic/log/error.log;

    location / {
        # Redirect everything that isn't a real file to index.php
        try_files $uri $uri/ /index.php$is_args$args;
    }

    # uncomment to avoid processing of calls to non-existing static files by Yii
    #location ~ \.(js|css|png|jpg|gif|swf|ico|pdf|mov|fla|zip|rar)$ {
    #    try_files $uri =404;
    #}
    #error_page 404 /404.html;

    # deny accessing php files for the /assets directory
    location ~ ^/assets/.*\.php$ {
        deny all;
    }
    
    location ~ \.php$ {
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_pass 127.0.0.1:9000;
        #fastcgi_pass unix:/var/run/php5-fpm.sock;
        try_files $uri =404;
    }

    location ~* /\. {
        deny all;
    }
}
使用该配置时，你还应该在 `php.ini` 文件中设置 `cgi.fix_pathinfo=0` ， 能避免掉很多不必要的 stat() 系统调用。

还要注意当运行一个 HTTPS 服务器时，需要添加 `fastcgi_param HTTPS on;` 一行， 这样 Yii 才能正确地判断连接是否安全


## 安装telnet

```sh
# rpm -qa | grep telnet
# yum -y install telnet*
# rpm -qa | grep xinetd
# yum -y install xinetd
# vim /etc/xinetd.d/telnet
service telnet
{  
    flags = REUSE  
    socket_type = stream  
    wait = no  
    user = root  
    server =/usr/sbin/in.telnetd  
    log_on_failure += USERID  
    disable = no
}
# systemctl restart xinetd.service
# ps -ef | grep xinetd

将xinetd服务加入开机自启动
# systemctl enable xinetd.service

将telnet服务加入开机自启动
# systemctl enable telnet.socket
# telnet 127.0.0.1 9501

关闭telnet
Ctrl+]
quit
```

## centos 7 时间与网络同步

1.安装ntpdate工具
`sudo yum -y install ntp ntpdate`

2.设置系统时间与网络时间同步
`sudo ntpdate cn.pool.ntp.org`

3.将系统时间写入硬件时间
`sudo hwclock --systohc`

4.查看系统时间
`timedatectl`


## 阿里云mongo连接方式

mongo --host host_name --port 27017 -u admin -p --authenticationDatabase admin


export GOROOT=/usr/local/go
export GOPATH=/home/gopath 
export PATH=\$PATH:\$GOROOT/bin
