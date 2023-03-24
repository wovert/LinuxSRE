# 修改软件管理仓库

```shell
~# egrep  "^[^#]" /etc/apt/sources.list

修改默认软件仓库（预发布软件仓库源，下载很慢，不建议使用的，替换为国内的软件仓库）
# sed -i 's/cn.archive.ubuntu/mirrors.aliyun/' /etc/apt/sources.list


更新ubuntu 系统
更新软件仓库，创建链接
# apt update

系统软件包更新
# apt upgrade

#apt常用命令
apt list                #apt列出仓库软件包，等于yum list
apt update              #更新本地软件包列表索引，修改了apt仓库后必须执⾏
apt upgrade             #升级所有已安装且可升级到新版本的软件包
apt search NAME         #搜索安装包
apt purge apache2       #卸载单个软件包删除配置⽂件
apt show apache2        #查看某个安装包的详细信息
apt install apache2     #在线安装软件包
apt remove apache2      #卸载单个软件包但是保留配置⽂件
apt autoremove apache2  #删除安装包并解决依赖关系
apt full-upgrade        #升级整个系统，必要时可以移除旧软件包。
apt edit-sources        #编辑source源⽂件
apt-cache madison nginx #查看仓库中软件包有哪些版本可以安装
apt install nginx=1.14.0-0ubuntu1.6   #安装软件包的时候指定安装具体的版本

安装vim
先卸载 vim-tiny
# apt-get remove vim-common
再安装vim full
# apt-get install vim

C/C++开发环境搭建
# apt install build-essential gdb

查看是否安装了git 及 安装
# git
# apt-get install git
# apt-get update

git的配置
这里git的配置，与window的相似，只是执行的地方不一样，乌班图直接在终端执行即可！！


# git config --global user.name  “aaa”
# git config --global user.email "aa@qq.com"
解除ssl验证后，再次git即可
# git config --global http.sslVerify false
# ssh-keygen -t rsa -C "aa@qq.com"

# cd ~/.ssh
# less id_rsa.pub

配置静态IP

# vim /etc/netplan/00-installer-config.yaml
# This is the network config written by 'subiquity'
network:
  ethernets:
    ens33:
      dhcp4: true
    ens34:
      dhcp4: false
      addresses:
        - 192.168.1.111/24
      optional: true
      routes:
        - to: default
          via: 192.168.1.1
      nameservers:
        addresses: [192.168.1.1, 8.8.8.8]
        search:
          - localhost
          - local
  version: 2

应用生效
# sudo netplan apply
```


# ubuntu16.04编译安装php7.2.7 + nginx-1.14.0

```
~]# apt-cache search package #搜索包
~]# apt-cache show package # 获取报的相关信息
~]# apt-cache depends package # 了解包依赖
~]# apt-cache rdepends package # 查看该包被那些包依赖
~]# apt-get install package=version #安装制定版本的包
~]# apt-get install package --reinstall #重新安装包
~]# apt-get -f install #修复安装(启动APT自动安装依赖关系的一个功能键，更新完源之后，如果APT还不能自行解决依赖关系，就可以执行一下这个命令)

~]# apt-get source package #下载该包的源代码
~]#  apt-get remove package #删除包
~]#  apt-get remove package --purge #删除包,包括删除配置文件等
~]# sudo apt-get update #更新apt软件源数据库
~]# apt-get upgrade #更新已安装的软件包
~]# apt-get dist-upgrade #升级系统
~]# apt-get dselect-upgrade #使用dselect升级
~]# apt-get build-dep package #安装相关的编译环境
~]# apt-get clean & apt-get autoclean #清理无用的包
~]# apt-get check #检查是否有损坏的依赖
```

## 1. PHP官网php-7.2.7 下载源码

``` shell
~]# wget -c http://cn2.php.net/distributions/php-7.2.7.tar.gz
-c  表示使用断点续传功能。在网络状况不佳的情况下很实用
-r  使用 -r会在当前止录下面生成以目标IP地址命名的文件夹
```

## 2. 下载解压

``` shell
~]# tar xf php-7.2.7.tar.gz
~]# cd php-7.2.7/
```

### 3. 安装相关依赖库

``` shell
~]# apt-get install build-essential
~]# apt-get install libxml2-dev
~]#  apt-get install openssl
~]#  apt-get install libssl-dev
~]#  apt-get install make
~]#  apt-get install curl
~]#  apt-get install libcurl4-gnutls-dev
~]#  apt-get install libjpeg-dev
~]#  apt-get install libpng-dev
~]#  apt-get install libmcrypt-dev
~]#  apt-get install libreadline6 libreadline6-dev
```

### 4. 查看系统版本

```shell
~]# cat /proc/version
~]# uname -a 
~]# uname -m
~]# lsb_release -a
~]# cat /etc/issue
```

### 5. 编译

```shell
~]# ./configure --prefix=/usr/local/php --with-config-file-path=/usr/local/php/etc --enable-fpm --with-fpm-user=ghostwu
~]#make && sudo make install
```

### 6. 如果需要添加扩展可以重新编译，或者用扩展安装方式，记得重新编译之前要make clean或者重新删除解压

``` shell
~]# ./configure --prefix=/usr/local/php \
--with-apxs2=/usr/local/httpd/bin/apxs \

--build=编译该软件所使用的平台
--host=该软件将运行的平台
--target=该软件所处理的目标平台
```

### 7. 大部分机器即可编译

``` shell

~]# ./configure \
--prefix=/usr/local/php \
--build=amd64 \
--enable-fpm --with-fpm-user=www \
--with-config-file-path=/usr/local/php/etc \
--with-fpm-group=www \
--with-mysqli \
--enable-pdo \
--enable-mbstring \
--enable-mysqlnd \
--with-pdo-mysql \
--with-mcrypt \
--with-zlib \
--with-pdo-mysql=mysqlnd \
--with-curl \
--enable-xml \
--enable-bcmath
```

``` options
--with-gd
--enable-sockets \
--enable-mbregex \
--enable-inline-optimization \
--enable-gd-native-ttf \
--with-iconv-dir \
--without-pear \
--with-libxml-dir=/usr \
--with-mhash \
--with-jpeg-dir \
--with-png-dir \
--with-openssl \
--with-freetype-dir \
--disable-rpath \
--enable-shmop \
--enable-sysvsem \
--enable-ftp \
--enable-gd-native-ttf \
--enable-pcntl \
--with-xmlrpc \
--enable-soap \
--with-gettext \
--disable-fileinfo \
--enable-maintainer-zts
```


### 64位x86系统编译

``` shell
~]# ./configure --prefix=/usr/local/php \
--with-config-file-path=/usr/local/php/etc \
--enable-fpm --enable-inline-optimization \
--disable-debug --disable-rpath \
--enable-shared --enable-opcache \
--with-mysql --with-mysqli --with-mysql-sock \
--enable-pdo \
--with-pdo-mysql \
--with-gettext \
--enable-mbstring \
--with-iconv \
--with-mcrypt \
--with-mhash \
--with-openssl \
--enable-bcmath \
--enable-soap \
--with-libxml-dir \
--enable-pcntl \
--enable-shmop \
--enable-sysvmsg \
--enable-sysvsem \
--enable-sysvshm \
--enable-sockets \
--with-curl \
--with-zlib \
--enable-mysqlnd \
--with-pdo-mysql=mysqlnd \
--enable-zip \
--enable-bz2 \
--with-iconv-dir \
--with-readline \
--without-sqlite3 \
--without-pdo-sqlite \
--with-pear \
--with-libdir=/lib/x86_64-linux-gnu \
--with-gd \
--with-jpeg-dir=/usr/lib \
--enable-gd-native-ttf \
--enable-xml
```

### configure: error: cannot guess build type; you must specify one

`~#] cat /proc/version`

Linux version 4.4.0-117-generic (buildd@lgw01-amd64-029) (gcc version 5.4.0 20160609 (Ubuntu 5.4.0-6ubuntu1~16.04.9) ) #141-Ubuntu SMP Tue Mar 13 11:58:07 UTC 2018

`--build=amd64 \`

histo安装php7提示 configure: error: Cannot find OpenSSL's libraries 解决方案

出现这种有2中情况，一种是没有安装 openssl，另一种是安装了找不到libssl.so 文件。
先安装openssl

`~]# apt-get install openssl`

如果还提示该错误的话，查找一下libssl.so所在位置，重新连接一下

`~]# find / -name libssl.so`

输出 /usr/lib/x86_64-linux-gnu/libssl.so 说明 libssl.so在这个位置

然后重新连接一下

`~]# ln -s /usr/lib/x86_64-linux-gnu/libssl.so /usr/lib`

``` echo
Installing shared extensions:     /usr/local/php/lib/php/extensions/no-debug-non-zts-20170718/
Installing PHP CLI binary:        /usr/local/php/bin/
Installing PHP CLI man page:      /usr/local/php/php/man/man1/
Installing PHP FPM binary:        /usr/local/php/sbin/
Installing PHP FPM defconfig:     /usr/local/php/etc/
Installing PHP FPM man page:      /usr/local/php/php/man/man8/
Installing PHP FPM status page:   /usr/local/php/php/php/fpm/
Installing phpdbg binary:         /usr/local/php/bin/
Installing phpdbg man page:       /usr/local/php/php/man/man1/
Installing PHP CGI binary:        /usr/local/php/bin/
Installing PHP CGI man page:      /usr/local/php/php/man/man1/
Installing build environment:     /usr/local/php/lib/php/build/
Installing header files:          /usr/local/php/include/php/
  program: phpize
  program: php-config
Installing man pages:             /usr/local/php/php/man/man1/
  page: phpize.1
  page: php-config.1
Installing PEAR environment:      /usr/local/php/lib/php/
[PEAR] Archive_Tar    - installed: 1.4.3
[PEAR] Console_Getopt - installed: 1.4.1
[PEAR] Structures_Graph- installed: 1.1.1
[PEAR] XML_Util       - installed: 1.4.2
[PEAR] PEAR           - installed: 1.10.5
Wrote PEAR system config file at: /usr/local/php/etc/pear.conf
You may want to add: /usr/local/php/lib/php to your php.ini include_path
/usr/local/src/php-7.2.7/build/shtool install -c ext/phar/phar.phar /usr/local/php/bin
ln -s -f phar.phar /usr/local/php/bin/phar
Installing PDO headers:           /usr/local/php/include/php/ext/pdo/
```

### 复制配置文件

`php-7.2.7# cp php.ini-development /usr/local/php/lib/php.ini`

### 设置全局的php命令

``` shell
~]# vim /etc/profile 在文件最后添加
  PATH=$PATH:/usr/local/php/bin:/usr/local/php/bin
  export PATH

~]# source /etc/profile
~]# php -v 查看php版本信息
~]# php -m 看看刚刚编译加载的模块
```

### 配置php-fpm

``` shell
~]# cd /usr/local/php/etc
~]# cp php-fpm.conf.default php-fpm.conf
~]# cd /usr/local/php/etc/php-fpm.d
~]# cp www.conf.default www.conf

~]# cp /usr/src/php-7.2.0/sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm
~]# chmod +x /etc/init.d/php-fpm
```

user = www
group = www

如果www用户不存在，那么先添加www用户
groupadd www
useradd -g www www

###  验证PHP

`~]# /usr/local/php/bin/php -v`

###  启动php-fpm

``` shell
~]# /usr/local/php/sbin/php-fpm
~]# /etc/init.d/php-fpm start
```

(可选)配置php-fpm自启动，如果存在这个文件，这步省略

``` shell
~]# vim /etc/init.d/php-fpm
#!/bin/sh
# chkconfig:   2345 15 95

# description:  PHP-FPM (FastCGI Process Manager) is an alternative PHP FastCGI implementation \

# with some additional features useful for sites of any size, especially busier sites.
# DateTime: 2016-09-20

# Source function library.  
. /etc/rc.d/init.d/functions  

# Source networking configuration.  
. /etc/sysconfig/network  

# Check that networking is up.  
[ "$NETWORKING" = "no" ] && exit 0  

phpfpm="/usr/local/php/sbin/php-fpm"  
prog=$(basename ${phpfpm})  

lockfile=/var/lock/subsys/phpfpm

start() {  
    [ -x ${phpfpm} ] || exit 5  
    echo -n $"Starting $prog: "  
    daemon ${phpfpm}
    retval=$?  
    echo  
    [ $retval -eq 0 ] && touch $lockfile  
    return $retval  
}  

stop() {  
    echo -n $"Stopping $prog: "  
    killproc $prog -QUIT  
    retval=$?  
    echo  
    [ $retval -eq 0 ] && rm -f $lockfile  
    return $retval  
}  

restart() {  
    configtest || return $?  
    stop  
    start  
}  

reload() {  
    configtest || return $?  
    echo -n $"Reloading $prog: "  
    killproc ${phpfpm} -HUP  
    RETVAL=$?  
    echo  
}  

force_reload() {  
    restart  
}  

configtest() {  
  ${phpfpm} -t
}  

rh_status() {  
    status $prog  
}  

rh_status_q() {  
    rh_status >/dev/null 2>&1  
}  

case "$1" in  
    start)  
        rh_status_q && exit 0  
        $1  
        ;;  
    stop)  
        rh_status_q || exit 0  
        $1  
        ;;  
    restart|configtest)  
        $1  
        ;;  
    reload)  
        rh_status_q || exit 7  
        $1  
        ;;  
    status)  
        rh_status  
        ;;  
    *)  
        echo $"Usage: $0 {start|stop|status|restart|reload|configtest}"  
        exit 2  
esac
```

###  添加到开机启动项 ~]# chkconfig --add php-fpm

```
 ~]# service php-fpm start
 ~]# service php-fpm stop

 ~]# cd /usr/lib/systemd/system
 ~]# vim php-fpm.service

[Unit]
Description=The PHP FastCGI Process Manager
After=syslog.target network.target

[Service]
Type=simple
PIDFile=/usr/local/php/var/run/php-fpm.pid
ExecStart=/usr/local/php/sbin/php-fpm --nodaemonize --fpm-config /usr/local/php/etc/php-fpm.conf
ExecReload=/bin/kill -USR2 $MAINPID
ExecStop=/bin/kill -SIGINT $MAINPID

[Install]
WantedBy=multi-user.target
```

### 启动服务

··· SHELL
# systemctl stop php-fpm.service
# systemctl start php-fpm.service
# systemctl reload php-fpm.service
# systemctl enable php-fpm.service
```


下机为systemctl指令

``` SHELL
# systemctl enable *.service #开机运行服务
# systemctl disable *.service #取消开机运行
# systemctl start *.service #启动服务
# systemctl stop *.service #停止服务
# systemctl restart *.service #重启服务
# systemctl reload *.service #重新加载服务配置文件
# systemctl status *.service #查询服务运行状态
# systemctl --failed #显示启动失败的服务
```

### 修改 php.ini 文件 设置 expose_php = Off

`# vim /usr/local/php/etc/php.ini`

找到 expose_php = On
改为 expose_php = Off

### php编译安装后，加扩展模块

1. 进入php源码包中，找到需要安装的扩展模块目录

`~]# cd /root/php-5.6.26/ext/mbstring`

2. 在扩展模块目录，运行phpize程序

`~]# /usr/local/bin/phpize`

3. 进行编译安装

``` SHELL
~]# ./configure --with-php-config=/usr/local/bin/php-config
~]# make && make install
```

### 安装 Nginx

#### 安装gcc g++的依赖库

```
apt-get install build-essential
apt-get install libtool
```


#### 安装pcre 依赖库 (http://www.pcre.org)

`apt-get install libpcre3 libpcre3-dev`


#### 安装zlib依赖库（http://www.zlib.net）

`apt-get install zlib1g-dev`

#### 安装SSL依赖库（16.04默认已经安装了）

`sudo apt-get install openssl`

#### 安装 Nginx

```
# wget -c http://nginx.org/download/nginx-1.14.0.tar.gz

# tar -zxvf nginx-1.14.0.tar.gz &&  cd nginx-1.14.0/

# ./configure --prefix=/usr/local/nginx --user=www --group=www --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --pid-path=/var/run/nginx/nginx.pid --lock-path=/var/lock/nginx.lock --with-http_ssl_module --with-http_stub_status_module --with-http_gzip_static_module --with-http_flv_module --with-http_mp4_module --with-debug --http-client-body-temp-path=/var/tmp/nginx/client --http-proxy-temp-path=/var/tmp/nginx/proxy --http-fastcgi-temp-path=/var/tmp/nginx/fastcgi --http-uwsgi-temp-path=/var/tmp/nginx/uwsgi --http-scgi-temp-path=/var/cache/nginx/scgi

# make && make install
```

### Nginx配置软连接（现在就可以不用路径直接输入nginx启动）

`# ln -s /usr/local/nginx/sbin/nginx /usr/bin/ngin`x

### Nginx 配置开机启动服务

``` SHELL
# vim /usr/lib/systemd/system/nginx.service

[Unit]
Description=nginx - high performance web server 
Documentation=http://nginx.org/en/docs/
After=network.target remote-fs.target nss-lookup.target

[Service]
Type=forking
PIDFile=/var/run/nginx/nginx.pid
ExecStartPre=/usr/local/nginx/sbin/nginx -t -c /etc/nginx/nginx.conf
ExecStart=/usr/local/nginx/sbin/nginx -c /etc/nginx/nginx.conf
ExecReload=/bin/kill -s HUP $MAINPID
ExecStop=/bin/kill -s QUIT $MAINPID
PrivateTmp=true

[Install]
WantedBy=multi-user.target


[Unit]:服务的说明
Description:描述服务
After:描述服务类别

[Service]服务运行参数的设置
Type=forking是后台运行的形式
ExecStart为服务的具体运行命令
ExecReload为重启命令
ExecStop为停止命令
PrivateTmp=True表示给服务分配独立的临时空间
注意：[Service]的启动、重启、停止命令全部要求使用绝对路径
[Install]运行级别下服务安装的相关设置，可设置为多用户，即系统运行级别为3
```

#### 然后开启开机启动
`# systemctl enable nginx.service`

###3 用命令关掉nginx

`# pkill -9 nginx`

#### 后面可以用systemctl来操作nginx.service

`# systemctl start nginx.service`

### 然后php装好后更改配置 编辑/etc/nginx/nginx.conf

查看所有已启动的服务

`# systemctl list-units --type=service`

### 设置php-fpm使用socket文件

``` SHELL
# vim /usr/local/php/etc/php-fpm.d/www.conf
  ;listen = 127.0.0.1:9000
  listen = /var/run/php-fpm.sock
```

### 重启php-fpm
`# /usr/local/php/sbin/php-fpm restart`

### 2、配置nginx

```
在/usr/local/nginx/conf/nginx.conf中找到
fastcgi_pass 127.0.0.1:9000;

改为
fastcgi_pass unix:/var/run/phpfpm.sock;

重启nginx
# /usr/local/nginx/sbin/nginx -s reload
```

#### php fpm安装curl后，nginx出现connect() to unix:/var/run/php5-fpm.sock failed (13: Permission denied)的错误

```
# vim /usr/local/php/etc/php-fpm.d/www.conf 文件，将以下的注释去掉:
listen.owner = www-data
listen.group = www-data
listen.mode = 0660 

然后重启php5-fpm
# service php5-fpm restart
```


### nginx + php-fpm配置后页面显示空白的解决办法


由于nginx与php-fpm之间的一个小bug，会导致这样的现象： 网站中的静态页面 .html 都能正常访问，而 .php 文件虽然会返回200状态码， 但实际输出给浏览器的页面内容却是空白。 简而言之，原因是nginx无法正确的将 *.php 文件的地址传递给php-fpm去解析， 相当于php-fpm接受到了请求，但这请求却指向一个不存在的文件，于是返回空结果。 为了解决这个问题，需要改动nginx默认的fastcgiparams配置文件

```
# vim /etc/nginx/fastcgi_params

在文件的最后增加两行：
fastcgi_param SCRIPT_FILENAME  $document_root$fastcgi_script_name;  
fastcgi_param PATH_INFO     $fastcgi_script_name;
```

### 虚拟机配置

``` shell
# vim /etc/nginx/nginx.conf
  include conf.d/cg.conf
# mkdir -pv /etc/nginx/conf.d
# vim /etc/nginx/conf.d/cg.conf

server {
    listen 8080;
    server_name  127.0.0.1;
    location / {
      index index.php;
    }

    location ~ \.php$ {
      root /data/www/cg;
      fastcgi_pass unix:/var/run/php-fpm.sock;
      #fastcgi_pass 127.0.0.1:9000;
      fastcgi_index index.php;
      # 必须加加载fastcgi_params
      include fastcgi_params; 
    }
}
```

## ubuntu 挂在smb服务器的方法

sudo mount -t cifs -o rw,user=chengguo,password=zj123456 //192.168.1.2/chengguo /home/chengguo/dev

share 是  smb.conf 文件的共享名称[share]

网站根目录权限遵循：

文件644

文件夹755

权限用户和用户组www-data

chown -R www-data.www-data /usr/local/nginx/html/

find /usr/local/nginx/html/ -type d -exec chmod 755 {} \;

find /usr/local/nginx/html/ -type f -exec chmod 644 {} \;


PHPstorm激活码: http://www.activejetbrains.gq 


ubuntu忘记密码怎么办

刚安装了，ubuntu14.04，就想着，如果忘记登录密码，这可不好办，所以测试下
开机，刚过bios显示画面，不停的点击，，键盘左边的shift键。（因为刚开始是采用按着不放的办法，结果不灵。所以我不停的点击，失败了，重启机子，直到用这个方法，不停的点击，出来成功为止）
grub2画面出来了
选择第二项：ubuntu kylin gnu/linux 高级选项
进入另一画面后，再选择第二项
ubuntu kylin gnu/linux,with linux 3.13.0-24-generic (recover mode)
进入画面后，选择第八选项。
root drop to root shell prompt


最后操作的部分
chmod 666 /dev/null            (chmod 666,所有用户都有读写权限，）
mount -o remount,rw /   (备注：-o,这个是字母，不是零,是磁盘配额的挂载点为/分区。rw是读写模式。通俗点，大概意思就是将根分区设置为读写模式。）
chmod 777 /etc/passwd         （chmod 777,所以用户都有读写执行权限）
pwconv                                         (开启用户的shadow口令.)
passwd root （备注，root是用户名）
接下来，你连续输入两次相同的密码。
最后大功成了。


 useradd -r -m -s /bin/bash chengguo