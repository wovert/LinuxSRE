# httpd

## httpd 的安装和使用

ASF：Apache Software Foundation

Apache Project: httpd/tomcat/hadoop/

httpd: apache

a patchy(补丁) server = apache

## httpd 特性

- 高度模块化：core + modules
- DSO: Dynamic Shared Object
- MPM: Multipath Processing Modules 多路处理模块
  - prefork: 多进程模型，每个进程响应一个请求；
    - 一个主进程：负责生成子进程及回收子继承；负责创建套接字；负责接收请求，并将其派发给某子进程进行处理；
    - n个子进程：每个子进程处理一个请求；
    - 工作模型：会预生成几个空闲进程，随时等待用于响应用户请求；最大空闲和最小空闲；
  - worker：多进程多线程模型，每个线程处理一个用户请求；
    - 一个主进程：负责生成子进程；负责创建套接字；负责接收请求，并将其派发给某子进程进行处理；
    - 多个子进程：每个子进程负责生成多个线程；
    - 每个线程：负责响应用户请求；
    - 并发响应数量：m*n
      - m: 子进程数量
      - n: 每个子进程所能创建的最大线程数量；
  - event：事件驱动模型，多进程模型，每个进程响应多个请求；
    - 一个主进程：负责生成子进程；负责创建套接字；负责接收请求，并将其派发给某子进程进行处理；
    - 子进程：基于事件驱动机制直接响应多个请求；
    - http-2.2: 测试使用模型
    - httpd-2.4: event 可生产环境使用
  
## httpd 的程序版本

- httpd  1.3: 官方已经停止维护
- httpd 2.0 主流版本
- httpd 2.2 主流版本 （CentOS 6 默认版本）
- httpd 2.4 目前最新稳定版 （CentOS 7 默认版本）

## httpd 功能特性

- CGI: Common Gateway Interface
- 虚拟主机：IP,PORT,FQDN
- 反向代理
- 负载均衡
- 路径别名
- 丰富的用户认证机制
  - basic
  - digest
- 支持第三方模块

## httpd 安装

- rpm 包安装：CentOS 发行版中直接提供
- 编译安装：定制新功能，或其他原因；

- CentOS 6: httpd-2.2
  - 程序环境：
    - 配置文件：
      - `/etc/httpd/conf/httpd.conf`
      - `/etc/httpd/conf.d/*.conf`
    - 服务脚本
      - `/etc/rc.d/init.d/httpd`
      - 脚本配置文件：`/etc/sysconfig/httpd`
    - 主程序文件：
      - `/usr/sbin/httpd`
      - `/usr/sbin/httpd.event`
      - `/usr/sbin/httpd.worker`
    - 日志文件
      - `/var/log/httpd`
        - `access.log` 访问日志
        - `error_log` 错误日志
    - 站点文档：
      - `/var/www/html`
    - 模块文件路径：
      - `/usr/lib64/httpd/modules`

    - 服务控制和启动
      - 开启自启动：`# chkconfig httpd on|off`
      - `# service {start|stop|restart|status|configtest|reload} httpd`

``` shell
# rpm -ql httpd
# service httpd start

访问 http://172.16.1.1

# cd /etc/httpd/conf.d/
# ls
# mv welcome.conf welcome.conf.bak
# service httpd reload
# vim /var/www/html/test.html
  <h1>Test Site</h1>

访问 http://172.16.1.1

```

- CentOS 7: httpd-2.4
  - 安装 httpd: `# yum -y install httpd && rpm -ql httpd`
  - 程序环境
    - 配置文件
      - 主配置文件: `/etc/httpd/conf/httpd.conf`
      - 其他配置文件: `/etc/httpd/conf.d/*.conf`
      - 模块相关的配置文件：`/etc/httpd/conf.modules.d/*.conf`
    - systemd unit file:
      - `/usr/lib/systemd/system/httpd.service`
    - 主程序文件：
      - `/usr/sbin/httpd`
      - httpd-2.4 支持 MPM 的动态切换
    - 日志文件
      - `/var/log/httpd`
        - `access.log` 访问日志
        - `error_log` 错误日志
    - 站点文档：
      - `/var/www/html`
    - 模块文件路径：
      - `/usr/lib64/httpd/modules`

    - 服务控制
      - 开启自启动：`# systemctl enable|disable httpd.service`
      - `# systemctl {start|stop|restart|status} httpd.service`

## httpd-2.2 的常用配置

``` shell
# systemctl start httpd.service
# systemctl status httpd.service
```