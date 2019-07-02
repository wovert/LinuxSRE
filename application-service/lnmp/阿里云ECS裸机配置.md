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

> 提前预定MariaDB的安装目录为/usr/local/mysql并且数据目录为/data/mysql，赋予mysql用户权限

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

### 下载解压源码包

```sh
进入下载目录
# cd /usr/local/src

下载
# wget https://downloads.mariadb.org/interstitial/mariadb-10.3.16/source/mariadb-10.3.16.tar.gz

解压
# tar -zxvf mariadb-10.3.16.tar.gz
```

### 下载安装编译工具

```sh
CMake：编译工具
# wget https://cmake.org/files/v3.12/cmake-3.12.1.tar.gz

解压
# tar -zxvf cmake-3.12.1.tar.gz

进入解压后的源码目录编译并安装
# cd cmake-3.12.1/
# ./bootstrap
# gmake
# make && make install
# cmake --version

Ncurses：提供功能键定义(快捷键),屏幕绘制以及基于文本终端的图形互动功能的动态库。

下载
# wget http://ftp.gnu.org/gnu/ncurses/ncurses-6.1.tar.gz

解压
# tar -zxvf ncurses-6.1.tar.gz

进入解压后的源码目录编译并安装
# cd ncurses-6.1/
# ./configure
# make && make install
# cd ~/soft/

Bison：GNU分析器生成器

下载
# wget http://ftp.gnu.org/gnu/bison/bison-3.0.5.tar.gz

解压
# tar -zxvf bison-3.0.5.tar.gz

进入解压后的源码目录编译并安装
# cd bison-3.0.5/
# ./configure
# make && make install


Boost库：一个开源可移植的C++库，是C++标准化进程的开发引擎之一

下载
# wget https://dl.bintray.com/boostorg/release/1.68.0/source/boost_1_68_0.tar.gz


解压
# tar -zxvf boost_1_68_0.tar.gz

进入解压后的源码目录编译并安装
# cd boost_1_68_0/
# ./bootstrap.sh
# ./b2 stage --with-iostreams --toolset=gcc link=static runtime-link=shared threading=multi release
# ./b2 install --prefix=/opt/boost
```

### 编译前配置

```sh
# cd mariadb-10.3.16

> 输入编译参数

# cmake . \
-DCMAKE_INSTALL_PREFIX=/usr/local/mysql \
-DDEFAULT_CHARSET=utf8 \
-DDEFAULT_COLLATION=utf8_general_ci \
-DENABLED_LOCAL_INFILE=1 \
-DENABLE_DOWNLOADS=1 \
-DEXTRA_CHARSETS=all \
-DSYSCONFDIR=/etc \
-DWITHOUT_TOKUDB=1 \
-DWITH_ARCHIVE_STPRAGE_ENGINE=1 \
-DWITH_ARCHIVE_STORAGE_ENGINE=1 \
-DWITH_BLACKHOLE_STORAGE_ENGINE=1 \
-DWITH_DEBUG=0 \
-DWITH_MEMORY_STORAGE_ENGINE=1 \
-DWITH_MYISAM_STORAGE_ENGINE=1 \
-DWITH_INNOBASE_STORAGE_ENGINE=1 \
-DWITH_PARTITION_STORAGE_ENGINE=1  \
-DWITH_READLINE=1 \
-DWITH_SSL=system \
-DWITH_ZLIB=system \
-DWITH_LOBWRAP=0 \
-DMYSQL_DATADIR=/data/mysql \
-DMYSQL_USER=mysql \
-DMYSQL_UNIX_ADDR=/var/run/mysql/mysql.sock \
-DMYSQL_TCP_PORT=3306 \
-DMYSQL_MAINTAINER_MODE=0

如果编译失败请删除CMakeCache.txt
# rm -f CMakeCache.txt

让指令重新执行，否则每次读取这个文件，命令修改正确也是报错
```

注释版

```txt
# cmake . \
-DCMAKE_INSTALL_PREFIX=/usr/local/mysql \           [MySQL安装的根目录]
-DDEFAULT_CHARSET=utf8 \                            [设置默认字符集为utf8]
-DDEFAULT_COLLATION=utf8_general_ci \               [设置默认字符校对]
-DENABLED_LOCAL_INFILE=1 \                          [启用加载本地数据]
-DENABLE_DOWNLOADS=1 \                              [编译时允许自主下载相关文件]
-DEXTRA_CHARSETS=all \                              [使MySQL支持所有的扩展字符]
-DSYSCONFDIR=/etc \                                 [MySQL配置文件所在目录]
-DWITHOUT_TOKUDB=1 \
-DWITH_ARCHIVE_STPRAGE_ENGINE=1 \                   [MySQL的数据库引擎]
-DWITH_ARCHIVE_STORAGE_ENGINE=1 \                   [MySQL的数据库引擎]
-DWITH_BLACKHOLE_STORAGE_ENGINE=1 \                 [MySQL的数据库引擎]
-DWITH_DEBUG=0 \                                    [禁用调试模式]
-DWITH_MEMORY_STORAGE_ENGINE=1 \                    [MySQL的数据库引擎]
-DWITH_MYISAM_STORAGE_ENGINE=1 \                    [MySQL的数据库引擎]
-DWITH_INNOBASE_STORAGE_ENGINE=1 \                  [MySQL的数据库引擎]
-DWITH_PARTITION_STORAGE_ENGINE=1  \                [MySQL的数据库引擎]
-DWITH_READLINE=1 \                                 [MySQL的readline library]
-DWITH_SSL=system \                                 [通讯时支持ssl协议]
-DWITH_ZLIB=system \                                [允许使用zlib library]
-DWITH_LOBWRAP=0 \
-DMYSQL_DATADIR=/data/mysql \                       [MySQL数据库文件存放目录]
-DMYSQL_USER=mysql \                                [MySQL用户名] 
-DMYSQL_UNIX_ADDR=/var/run/mysql/mysql.sock \       [MySQL的通讯目录]
-DMYSQL_TCP_PORT=3306 \                             [MySQL的监听端口]
-DMYSQL_MAINTAINER_MODE=0
```

### 编译和安装

```sh
# make && make install
# cd
```

### 配置MariaDB

> 使用maria用户执行脚本, 安装数据库到数据库存放目录

`# /usr/local/mysql/scripts/mysql_install_db --user=mysql --datadir=/data/mysql`

### 复制MariaDB配置文件到/etc目录

> 拷贝maria安装目录下 support-files目录下的文件wsrep.cnf到/etc目录并重命名为my.cnf

`# cp /usr/local/mysql/support-files/wsrep.cnf /etc/my.cnf`

### 创建启动脚本

`# cp /usr/local/mysql/support-files/mysql.server /etc/rc.d/init.d/mysqld`

### 启动mysqld服务

`# /etc/rc.d/init.d/mysqld start`

### 配置环境变量

```sh
打开并新建文件
# vim /etc/profile.d/mysql.sh
  export PATH=$PATH:/usr/local/mysql/bin/

为脚本赋于可执行权限
# chmod 0777 /etc/profile.d/mysql.sh

读取并执行`mysql.sh`脚本, 并执行脚本, 以立即生效环境变量
# source /etc/profile.d/mysql.sh
```

### 初始化MariaDB

```sh
运行MariaDB初始化脚本
# /usr/local/mysql/bin/mysql_secure_installation
Nh123456;

运行MariaDB初始化脚本
# ./bin/mysql_secure_installation

> 以下提示：

Enter current password for root (enter for none):   输入当前root密码(没有输入)

Set root password? [Y/n]    设置root密码?(是/否)

New password:   输入新root密码

Re-enter new password:      确认输入root密码

Password updated successfully!      密码更新成功

By default, a MariaDB installation has an anonymous user, allowing anyone
to log into MariaDB without having to have a user account created for
them.  This is intended only for testing, and to make the installation
go a bit smoother.  You should remove them before moving into a
production environment.

默认情况下,MariaDB安装有一个匿名用户,
允许任何人登录MariaDB而他们无需创建用户帐户。
这个目的是只用于测试,安装去更平缓一些。
你应该进入前删除它们生产环境。

Remove anonymous users? [Y/n]       删除匿名用户?(是/否)

Normally, root should only be allowed to connect from 'localhost'.  This
ensures that someone cannot guess at the root password from the network.

通常情况下，root只应允许从localhost连接。
这确保其他用户无法从网络猜测root密码。

Disallow root login remotely? [Y/n]     不允许root登录远程?(是/否)

By default, MariaDB comes with a database named 'test' that anyone can
access.  This is also intended only for testing, and should be removed
before moving into a production environment.

默认情况下，MariaDB提供了一个名为“测试”的数据库，任何人都可以访问。
这也只用于测试，在进入生产环境之前应该被删除。

Reloading the privilege tables will ensure that all changes made so far
will take effect immediately.

重新加载权限表将确保所有到目前为止所做的更改将立即生效。

Reload privilege tables now? [Y/n]      现在重新加载权限表(是/否)

All done!  If you've completed all of the above steps, your MariaDB
installation should now be secure.

Thanks for using MariaDB!
```

### 启动|查看 MariaDB服务

```sh
# systemctl start mysqld
# systemctl status mysqld
```
