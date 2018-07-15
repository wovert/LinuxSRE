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
