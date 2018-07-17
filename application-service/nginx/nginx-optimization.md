# Nginx 生产环境优化

## 隐藏Nginx版本

```
Syntax: server_tokens off;
Default: server_tokens on;
Context: http, server, location

优化：server_tokens off;
```

## 更改源码隐藏 Nginx 软件名称及版本号

一次修改 3个 Nginx 源码文件

```
# vim nginx-X.X.X/src/core/nginx.h
# sed -n '13,18p' nginx.h
  #define NGINX_VERSION "1.2.23" # 修改为想要的显示的版本号，如 2.2.32
  #define NGINX_VER "gqsj/" NGINX_VERSION # 将nginx修改为想要修改的软件名称
  
  #define NGINX_VAR "gqsj" # 将 nginx 修改为想要修改的软件名称
  #define NGX_OLDPID_EXT ".cc"

# vim nginx-x.x.x/src/http/ngx_http_header_filter_module.c
# grep -n 'Server: nginx' ngx_http_header_filer_module.c
49行 static char ngx_http_server_string[] = "Server: gqsj " CRLF; # 修改
# sed -i 's#Server: nginx#Server: gqsj#g' ngx_http_header_filer_module.c


对外面报错时，它会控制是否展示铭感信息
# vim nginx-x.x.x/src/http/ngix_http_special_response.c
# sed -n '21,30p' ngx_http_special_response.c
  static u_char ngx_http_error_full_tail[] = 
  "<hr><center>" NGINX_VER " (http://gqsj.cc)</cener>" CRLF
  ...

  "<hr><center>gqsj</center>" CRLF

```

最后编译软件即可

测试：`# curl -I http://www.gqsj.cc`

## 更改 Nginx 服务的默认用户

- 端口、用户

- 禁止 root SSH 连接

```
# grep '#user' nginx.conf.default

nginx 服务建立新用户
# useradd nginx -s /sbin/nologin -M
# vim nginx.conf
  user nginx nginx;
# ./configure --user=nginx --group=nginx --prefix=/usr/local/nginx --with-http_stub_status_module --with-http_ssl_module

检查更改用户的效果
# ps -ef | grep nginx | grep -v grep
```

## 根据参数优化 Nginx 服务性能

### 优化 Nginx服务的 worker 进程个数

worker_processes 参数开始时，与CPU核心相等配置，或 worker 进程数要多一些，这样起始提供服务时就不会出现因为访问量快速增加而临时启动新进程提供服务的问题，缩短了系统的瞬时开销和提供服务的时间，提升了服务用户的速度。

高流量高并发场合可以考虑进程数提高至CPU核数x2

```
查看 CPU信息
# grep processor /proc/cpuinfo | wc -l
 4 # 标识一颗CPU四核
# grep -c processor /proc/cpuinfo

查看 CPU 总颗数
# grep 'physical id' /proc/cpuinfo | sort | uniqu | wc -l
1 # 对phsical id 去重计算，表示 1 颗 CPU

显示所有的CPU核数
# top 
按数字 1

```


修改 Nginx 配置
```
CPU 一颗，核数位 4核

# sed -i 's#worker_processes 1#worker_processes 4#g' nginx.conf
# ps -ef | grep nginx | grep -v grep

```

优化不同的 Nginx 进程到不同的 CPU 上

```
worker_cpu_affinity 0001 0010 0100 1000;

八核
worker_cpu_affinity 00000001 00000010 00000100 00001000 00010000 00100000 01000000 10000000;



压力测试
# webbench -c 20000 -t 180 http://10.0.0.190/

# top
按数字 1 查看CPU使用情况
```

```
use epoll;
worker_connections 20480; # 每个进程最大并发连接数，默认1024，这个连接数包括了所有连接，例如：代理服务器的连接、客户端的连接等，实际的并发连接数除了受woker_connections参数控制外，海鸥最大打开文件数 worker_rlimit_nofile 有关。 max_client=worker_processes*worker_connections。进程的最大连接数受 Linux 系统进程的最大打开文件数限制，在执行操作系统命令"ulimit -HSn 65535" 或配置相应文件后，worker_connections 的设置才能生效

Nginx 总并发连接 = worker数量 * worker_connections

worker_rlimit_nofile 65535;
```

优化服务器域名的散列表大小
```
server_name nginx.org www.nginx.org *.nginx.org;
```

开启高效文件传输模式
```
sendfile on;
```


pool：php-fpm池的名称，一般都是应该是www
process manage：进程的管理方法，php-fpm支持三种管理方法，分别是static,dynamic和ondemand，一般情况下都是dynamic
start time：php-fpm启动时候的时间，不管是restart或者reload都会更新这里的时间
start since：php-fpm自启动起来经过的时间，默认为秒
accepted conn：当前接收的连接数
listen queue：在队列中等待连接的请求个数，如果这个数字为非0，那么最好增加进程的fpm个数
max listen queue：从fpm启动以来，在队列中等待连接请求的最大值
listen queue len：等待连接的套接字队列大小
idle processes：空闲的进程个数
active processes：活动的进程个数
total processes：总共的进程个数
max active processes：从fpm启动以来，活动进程的最大个数，如果这个值小于当前的max_children，可以调小此值
max children reached：当pm尝试启动更多的进程，却因为max_children的限制，没有启动更多进程的次数。如果这个值非0，那么可以适当增加fpm的进程数
slow requests：慢请求的次数，一般如果这个值未非0，那么可能会有慢的php进程，一般一个不好的mysql查询是最大的祸首。

开启php-fpm慢日志

slowlog = /usr/local/php/log/php-fpm.log.slow

request_slowlog_timeout = 5s

8.设置php-fpm单次请求最大执行时间，今天碰到一个问题，测试服务器php-fpm一直是被占满状态，后来发现是set_time_limit(0)，file_get_content()，原因如下:

比如file_get_contents(url)等函数，如果网站反应慢，会一直等在那儿不超时，php-fpm一直被占用。有一个参数 max_execution_time 可以设置 PHP 脚本的最大执行时间，但是，在 php-cgi(php-fpm) 中，该参数不会起效。真正能够控制 PHP 脚本最大执行时间的是 php-fpm.conf 配置文件中的以下参数。

request_terminate_timeout = 10s

默认值为 0 秒，也就是说，PHP 脚本会一直执行下去。这样，当所有的 php-cgi 进程都卡在 file_get_contents() 函数时，这台 Nginx+PHP 的 WebServer 已经无法再处理新的 PHP 请求了，Nginx 将给用户返回“502 Bad Gateway”。可以使用 request_terminate_timeout = 30s，但是如果发生 file_get_contents() 获取网页内容较慢的情况，这就意味着 150 个 php-cgi 进程，每秒钟只能处理 5 个请求，WebServer 同样很难避免“502 Bad Gateway”。php-cgi进程数不够用、php执行时间长、或者是php-cgi进程死掉，都会出现502错误。