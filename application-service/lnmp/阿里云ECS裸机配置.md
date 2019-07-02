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
安装系统开发工具包
# yum -y groupinstall "Development Tools" "Server Platform Development"

查看系统版本
# lsb_release -a

安装 git 源码构建
# git --version

安装编译依赖软件
# yum -y install curl-devel expat-devel gettext-devel openssl-devel zlib-devel asciidoc
# yum -y install gcc perl-ExtUtils-MakeMaker

卸载老版本
# yum remove git

下载最新版本
# cd /usr/local/src/
# wget https://www.kernel.org/pub/software/scm/git/git-2.22.0.tar.xz
# tar -vxf git-2.22.0.tar.xz
# cd git-2.22.0

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

## Node开发工具

[Install NVM](https://github.com/nvm-sh/nvm)

```sh
# curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash

# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

查看nvm版本
# nvm --version

查看都有哪些版本可以安装
# nvm ls-remote

安装版本
# nvm install v10.16.0

查看一下当前已经安装的版本
# nvm ls

切换版本
# nvm use v10.16.0

设置默认版本
# nvm alias default v10.16.0
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
  mariadb-libs-5.5.60-1.el7_5.x86_64

卸载
# rpm -e mariadb-libs-5.5.60-1.el7_5.x86_64 --nodeps`
```

### 安装相关包

```sh
# yum -y install libaio libaio-devel bison bison-devel zlib-devel openssl openssl-devel ncurses ncurses-devel libcurl-devel libarchive-devel boost boost-devel lsof wget gcc gcc-c++ make cmake perl kernel-headers kernel-devel pcre-devel
```

### 准备二进制程序

```sh
# cd /usr/local/src
# wget https://mirrors.tuna.tsinghua.edu.cn/mariadb//mariadb-10.3.16/bintar-linux-x86_64/mariadb-10.3.16-linux-x86_64.tar.gz
# tar xvf mariadb-10.3.16-linux-x86_64.tar.gz -C /usr/local  
# cd /usr/local
# ln -sv mariadb-10.3.16-linux-x86_64  mysql
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
```

### 创建数据库文件

```sh
# cd /usr/local/mysql/
# scripts/mysql_install_db  --user=mysql --datadir=/data/mysql 
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