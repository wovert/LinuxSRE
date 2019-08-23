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
  mariadb-libs-5.5.60-1.el7_5.x86_64

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
yum -y install lrzsz gcc gcc-c++ autoconf automake make
yum install -y pcre pcre-devel
yum install -y zlib zlib-devel
yum install -y openssl openssl-devel
```

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
--user=www \
--group=www \
--conf-path=/etc/nginx/nginx.conf \
--error-log-path=/var/log/nginx/error.log \
--http-log-path=/var/log/nginx/access.log \
--pid-path=/var/run/nginx/nginx.pid \
--lock-path=/var/lock/nginx.lock \
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
--with-debug

make && make install

cd /etc/nginx/ && cp nginx.conf{,.bak}
```

### 环境变量配置

```sh
# vim  /etc/profile.d/nginx.sh
  export PATH=$PATH:/usr/local/nginx/sbin

# source /etc/profile.d/nginx.sh
```

### 相关服务

- 启动服务: `# /usr/local/nginx/sbin/nginx`
- 重读配置文件: `# nginx -HUB PID`
- 关闭服务-PID(主进程号): `# kill -QUIT pid`
- kill -signal : `# cat /usr/local/nginx/log/nginx.pid`

## redis 安装配置

```sh
# yum install gcc gcc-c++

# wget http://download.redis.io/releases/redis-5.0.5.tar.gz
# tar -xzvf redis-5.0.5.tar.gz
# cd redis-5.0.5 && make

不推荐直接在前台运行Redis，如果用 ctrl+z 将 redis 切换到后台后，此时 redis 将被挂起，不能被连接。所以推荐以下方式运行Redis。不仅可以后台运行，加载自己的配置文件，还可以输入日志到 redis.log 中。

运行命令
# nohup src/redis-server redis.conf > /home/redis.log 2>&1 &

查看运行的redus：

# ps -ef | grep redis

关闭命令
# cd redis-5.0.4
# src/redis-cli shutdown

强制关闭
# kill -9 id

Redis5 允许远程连接

redis 默认只允许自己的电脑（127.0.0.1）连接。如果想要其他电脑进行远程连接，将 配置文件 redis.conf 中的 bind 127.0.0.1 后添加自己的ip即可。然后重新运行redis服务。

# vim redis.conf
  bind 127.0.0.1 10.10.10.10 123.123.123.123
  protected-mode no

Redis5 增加密码

redis 增加密码需要修改 redis.conf 配置文件，将 requirepass 的注释解除掉，在后面加上自己的密码。然后重新运行 redis 服务。

# vim redis.conf
  requirepass  mypassword

增加密码后连接命令
# src/redis-cli -a mypassword

增加密码后关闭命令
# src/redis-cli -a mypassword shutdown
```

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
