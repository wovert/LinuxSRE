```sh
--prefix=/usr/local/php7 # 配置安装目录
--with-config-file-path=/usr/local/php7 # 配置文件 php.ini 的路径
--enable-sockets # 开启 socket 
--enable-fpm # 启用 fpm 扩展
--enable-cli # 启用 命令行模式 (从 php 4.3.0 之后这个模块默认开启所以可以不用再加此命令)
--enable-mbstring # 启用 mbstring 库
--enable-pcntl # 启用 pcntl (仅 CLI / CGI)
--enable-soap # 启用 soap 
--enable-opcache # 开启 opcache 缓存
--disable-fileinfo # 禁用 fileinfo (由于 5.3+ 之后已经不再持续维护了，但默认是开启的，所以还是禁止了吧)(1G以下内存服务器直接关了吧)
--disable-rpath  #禁用在搜索路径中传递其他运行库。
--with-mysqli # 启用 mysqli 扩展
--with-pdo-mysql # 启用 pdo 扩展
--with-iconv-dir # 启用 XMLRPC-EPI 字符编码转换 扩展
--with-openssl # 启用 openssl 扩展 (需要 openssl openssl-devel)
--with-fpm-user=www #设定 fpm 所属的用户 
--with-fpm-group=www #设定 fpm 所属的组别
--with-curl # 启用 curl 扩展
--with-mhash # 开启 mhash 基于离散数学原理的不可逆向的php加密方式扩展库
# GD
--with-gd # 启用 GD 图片操作 扩展
--with-jpeg-dir # 开启对 jpeg 图片的支持 (需要 libjpeg)
--with-png-dir # 开启对 png 图片支持 (需要 libpng)
--with-freetype-dir # 开启 freetype 
# 压缩
--enable-zip # 启用 zip
--with-zlib # 启用对 zlib 支持 
# xml
--enable-simplexml # 启用对 simplexml 支持
--with-libxml-dir # 启用对 libxml2 支持
#不常用选项(可选)
--enable-debug 开启 debug 模式
```

## 1 下载源码包
在 官网 或者 搜狐镜像 下载对应版本的 PHP 源码压缩包

# 这里在 /usr/local/src/ 目录下进行，用 php-5.6.40 和 php-7.2.34 作为示例
cd /usr/local/src/
wget https://mirrors.sohu.com/php/php-5.6.40.tar.gz
wget https://mirrors.sohu.com/php/php-7.2.34.tar.gz

## 2 解压并进入编译

```sh
yum -y install libxml2 libxml2-devel openssl openssl-devel libcurl libcurl-devel install libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel


./configure --prefix=/usr/local/php72 --with-config-file-path=/usr/local/php72 --enable-sockets --enable-fpm --enable-cli --enable-mbstring --enable-pcntl --enable-soap --enable-opcache --disable-fileinfo --disable-rpath --with-mysqli --with-pdo-mysql --with-iconv-dir --with-openssl --with-fpm-user=www --with-fpm-group=www --with-curl --with-mhash --with-gd --with-jpeg-dir --with-png-dir --with-freetype-dir --enable-zip --with-zlib --enable-simplexml --with-libxml-dir 

make && make install 


cp php-7.2.34/php.ini-production /usr/local/php72/php.ini # 复制 php.ini 文件到目录
```

## 3 查看 PHP 是否安装成功
# /usr/local/php72

实在步骤三中的 --prefix=/usr/local/php72 指定的
/usr/local/php72/bin/php -v

## 4 设置快捷命令

```sh
vi ~/.bash_profile
# 加入以下两行后保存退出
alias php72="/usr/local/php72/bin/php"
alias php="php72"
```

php-5.6.40 版本安装从第 2 步开始重复一遍即可
## 5、编译安装扩展

```sh
# 下载需要安装扩展的 php 相同版本的 php 源码包，解压并进入源码包的 ext/ 目录
# 若是第三方扩展则下载对应的扩展包，解压并进入解压后的文件目录，然后执行 phpize
cd /usr/local/src/php-7.2.34/ext/

# 在 ext/ 目录下可以看到 php 所有的原生扩展，以 bcmath 为例
cd bcmath

# 执行 phpize
/usr/local/php72/bin/phpize

# 配置编译
./configure --with-php-config=/usr/local/php72/bin/php-config

# 编译并且安装
make && make install

# 查看扩展是否安装成功
php74 -m | grep bcmath

# 在 /usr/local/php72/etc/php.ini 中加入 `extension = bcmath.so`
```

## 6、修改 php-fpm 监听端口

```sh
# 编辑 php-fpm 配置文件，如找不到可使用 `find / -name php-fpm.conf` 命令
vim /usr/local/php72/etc/php-fpm.conf # 去掉 `; pid = run/php-fpm.pid` 前面的分号注释，打开 pid 配置
vim /usr/local/php72/etc/php-fpm.d/www.conf # 输入 /9000 回车，找到 listen = 127.0.0.1:9000 这一行将 9000 修改为 9074

# php56 版本路径和 php72 版本略有不同，默认没有引入外部配置，打开 pid, 将端口修改为 9056
vim /usr/local/php56/etc/php-fpm.conf

# 关闭并重启 php-fpm
killall php-fpm
/usr/local/php72/sbin/php-fpm
/usr/local/php56/sbin/php-fpm

# 打开了 pid 配置后，可使用过以下命令关闭或重启 php-fpm
# INT, TERM 立刻终止
# QUIT 平滑终止
# USR1 重新打开日志文件
# USR2 平滑重载所有worker进程并重新载入配置和二进制模块
# php-fpm 关闭：
kill -INT `cat /usr/local/php72/var/run/php-fpm.pid`
kill -INT `cat /usr/local/php56/var/run/php-fpm.pid`
# php-fpm 重启：
kill -USR2 `cat /usr/local/php72/var/run/php-fpm.pid`
kill -USR2 `cat /usr/local/php56/var/run/php-fpm.pid`

# 复制启动脚本到 init.d 目录
$ cp php-7.2.34/sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm
# 增加执行权限
$ chmod +x /etc/init.d/php-fpm
# 配置 php-fpm 文件
$ cd /usr/local/php72/etc/
$ cp php-fpm.conf.default php-fpm.conf
# 进入 php-fpm.conf , 并去除 pid = run/php-fpm.pid 的注释
$ vim php-fpm.conf
=== 
...
[global]
; Pid file
; Note: the default prefix is /usr/local/php72/var
; Default Value: none
# 取消下面的注释
pid = run/php-fpm.pid
...
===
# 复制 www.conf 文件
$ cp php-fpm.d/www.conf.default php-fpm.d/www.conf
# 重启 php 服务器
$ pkill -9 php-fpm
$ /usr/local/nginx/php72/sbin/php-fpm
# 测试 
$ /etc/init.d/php-fpm stop  # 停止服务
Gracefully shutting down php-fpm . done
$ /etc/init.d/php-fpm start # 启动服务
Starting php-fpm  done
$ /etc/init.d/php-fpm restart # 重启服务


# 启动(因为上面已经配置好启动脚本了,并且放到了 /etc/init.d 中所以下面命令是可以用的)
# 在 centos7 中 systemctl 是找 /etc/init.d 中的脚本
$ systemctl start php-fpm # 启动
$ systemctl enable php-fpm # 自启动
php-fpm.service is not a native service, redirecting to /sbin/chkconfig.
Executing /sbin/chkconfig php-fpm on # 这里他提示我 php-fpm 并不是系统服务所以不能使用     systemctl 推荐我使用 /sbin/chkconfig php-fpm on 来实现自启动
$ /sbin/chkconfig php-fpm on 再次重启即可完成自启动
# 注: 如果不想配置 php-fpm 服务器化到此已经可以结束了,如果想看服务化可以看以下操作


# 在 centos 7 之后我们可以使用 systemctl 更好的管理系统服务
# 所以我们也要让 php-fpm 支持
# 因为 php 7.2 源码包里面含有 systemctl 所需要的脚本文件
# 我们只要复制过去即可,我们来开始配置
# 进入下载的 php源码包
$ cd php-7.2.19/sapi/fpm
# 复制其中的 php-fpm.service 到 /usr/lib/systemd/system/
$ cp php-fpm.service /usr/lib/systemd/system/
# 再次使用 systemctl enable php-fpm 进行配置自启动
$ systemctl enable php-fpm
# 重启测试一下看看自己服务器的 php-fpm 是否成功运行

```

## 7、Nginx 配置多版本 PHP 解析

```sh
server {
    listen       80;
    server_name  www.xxx.com;
    set $root "/usr/local/share/html";
    charset utf-8;
    #access_log  logs/host.access.log  main;

    location / {
        root   $root;
        index  index.php index.html index.htm;
    }

    #error_page  404              /404.html;

    # redirect server error pages to the static page /50x.html
    #
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   html;
    }

    # php72 匹配路由根据自己需要自行配置
    location /php72 {
        root           $root;
        fastcgi_pass   127.0.0.1:9074; # 这里端口需和前面 php-fpm 修改的端口保持一致
        fastcgi_index  index.php;
        fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
        include        fastcgi_params;
    }

    # php56
    location /php56 {
        root           $root;
        fastcgi_pass   127.0.0.1:9056; # 这里端口需和前面 php-fpm 修改的端口保持一致
        fastcgi_index  index.php;
        fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
        include        fastcgi_params;
    }

    # 没有匹配到以上两种路由，默认走 php74
    location ~ \.php$ {
        root           $root;
        fastcgi_pass   127.0.0.1:9074;
        fastcgi_index  index.php;
        fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
        include        fastcgi_params;
    }

    # deny access to .htaccess files, if Apache's document root
    # concurs with nginx's one
    #
    #location ~ /\.ht {
    #    deny  all;
    #}
}

```


1. configure: error: libxml2 not found. Please check your libxml2 installation.
安装 libxml2 库

`$ yum -y install libxml2 libxml2-devel`

2. configure: error: Cannot find OpenSSL\'s <evp.h>
安装 openssl 库

`$ yum -y install openssl openssl-devel`

3. checking for cURL 7.10.5 or greater... configure: error: cURL version 7.10.5 or later is required to compile php with cURL support
安装 curl 库 

`$ yum -y install libcurl libcurl-devel`

4. configure: error: jpeglib.h not found.
安装 libjpeg 顺便 把 libpng 也装上

`$ yum -y install libjpeg libjpeg-devel libpng libpng-devel`

5. configure: error: freetype-config not found.
安装 freetype 库 

`$ yum -y install freetype freetype-devel`