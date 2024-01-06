# Ubuntu-22.04 环境搭建


## Docker

### 官方源安装 Docker

安装一些必要的软件包

```sh
apt update
apt upgrade -y
apt install curl vim wget gnupg dpkg apt-transport-https lsb-release ca-certificates
```

加入 Docker 的 GPG 公钥和 apt 源

```sh
curl -sSL https://download.docker.com/linux/debian/gpg | gpg --dearmor > /usr/share/keyrings/docker-ce.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-ce.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -sc) stable" > /etc/apt/sources.list.d/docker.list
```

国内机器可以用清华 TUNA的国内源

```sh
curl -sS https://download.docker.com/linux/debian/gpg | gpg --dearmor > /usr/share/keyrings/docker-ce.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-ce.gpg] https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/ubuntu $(lsb_release -sc) stable" > /etc/apt/sources.list.d/docker.list
```

### 阿里云加速服务

更新系统后即可安装 Docker CE

```sh
apt update
apt install docker-ce docker-ce-cli containerd.io docker-compose-plugin
# 检查是否安装成功
docker version
```

某个特定用户可以用 Docker rootless 模式运行 Docker，那么可以把这个用户也加入 docker 组，比如我们把 www-data 用户加进去

```sh
apt install docker-ce-rootless-extras
sudo usermod -aG docker www-data
```

### 安装 Docker Compose

已经安装了 docker-compose-plugin，所以 Docker 目前已经自带 docker compose 命令，基本上可以替代 docker-compose：


```sh
# docker compose version
```

如果某些镜像或命令不兼容，则我们还可以单独安装 Docker Compose：

可以使用 Docker 官方发布的 Github 直接安装最新版本：

```sh
curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-Linux-x86_64 > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

#命令检查是否安装成功
docker-compose version 
```

### 修改 Docker 配置

配置会增加一段自定义内网 IPv6 地址，开启容器的 IPv6 功能，以及限制日志文件大小，防止 Docker 日志塞满硬盘

```sh
cat > /etc/docker/daemon.json << EOF
{
    "log-driver": "json-file",
    "log-opts": {
        "max-size": "20m",
        "max-file": "3"
    },
    "ipv6": true,
    "fixed-cidr-v6": "fd00:dead:beef:c0::/80",
    "experimental":true,
    "ip6tables":true
}
EOF
```

```sh
vim /etc/docker/daemon.json

{
  "dns": ["8.8.8.8", "8.8.4.4"]
}
```

重启 Docker 服务：`systemctl restart docker`


### Docker 常用命令

```sh
#从远程仓库拉取镜像
docker pull imageName<:tags> 

#查看本地镜像
docker images

#创建容器并启动应用
docker run imageName<:tags>

#查看正在运行中的容器
docker ps

#删除容器
docker rm <-f> 容器id

#删除镜像(-f 正在运行的容器强制删除)
docker rmi <-f> imageName:<tags>

# 运行容器
docker run -p 8000:8080 tomcat

# 守护进程运行容器
docker run -p 8000:8080 -d tomcat

# 停止容器
docker stop COMTAINER_ID

# 删除容器
docker rm COMTAINER_ID

# 进入容器：it=> 交互方式
docker exec -it CONTAINER_ID /bin/bash


```
### Dockerfile

> 一个包含用于组合镜像胡命令的文本文档

Docker 通过读取 Dockerfile 中的指令按步自动生成镜像

`docker build -t 机构/镜像名<:tags> Dockerfile目录`


```sh

cd /usr/images
mkdir first-dockerfile
cd first-dockerfile
mkdir docker-web
vim docker-web/index.html

vim Dockerfile

#基准镜像(尽量使用官方提供胡Base Image) scratch:联依赖任何基准镜像
FROM tomcat:latest 

#机构名称
MAINTAINER wovert.com 

#描述信息
LABEL version="1.0"
LABEL description="说明"

#切换工作目录（容器内部目录）
#没有工作目录，则自动创建
WORKDIR /usr/local/tomcat/webapps

#复制同级目录docker-web目录下的所有文件到上一个容器工作目录下的docker-web
ADD docker-web ./docker-web   指定的文件和目录复制到镜像目录下

# 添加根目录并解压
ADD test.tar.gz / 

# 设置环境常量
ENV JAVA_HOME /usr/local/openjdk8

# 运行指令
RUN ${JAVA_HOME}/bin/java -jar test.jar




cd /usr/images/first-dockerfile

#构建镜像 mywebapp=镜像名:版本
docker build -t wovert.com/mywebapp:1.0 /usr/images/first-dockerfile/
docker build -t wovert.com/mywebapp:1.0 .

docker images
docker run -d -p 8001:8080 wovet.com/mywebapp:1.0
docker ps
http://ip:9001/docker-web/index.html
```


### 镜像分层

```sh
cd /usr/image
mkdir docker_layer
cd docker_layer

vim Dockerfile
FROM centos
RUN ["echo", "aaa"]
RUN ["echo", "bbb"]
RUN ["echo", "ccc"]

docker build -t wovert.com/docker_layer:1.0 .
docker images

vim Dockerfile
FROM centos
RUN ["echo", "aaa"]
RUN ["echo", "bbb"]
RUN ["echo", "hello ccc"]
RUN ["echo", "hello ddd"]

docker build -t wovert.com/docker_layer:1.1 .
docker images
```


### RUN & CMD & ENTRPOINIT

- RUN: 在build **构建镜像**时执行命令
  - shell命令格式: yum 创建子进程
    - yum -y install vim
  - exec命令格式: exec 进程替换当前进程，并且保持PID不变，执行完毕，直接退出
    - RUN ["yum", "install", "y", "vim"]
- ENTRYPOINT: **容器启动时**执行的命令
  - 只有最后一个ENTRYPOINT会被执行
  - ENTRYPOINT["ps"]
- CMD: **容器启动后**执行默认的命令或参数
  - 容器启动时附加指令，则CMD被忽略

### 构建 Redis 镜像

```sh
mkdir docker-redis && cd docker-redis
vim Dockerfile

FROM centos
RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
RUN sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*
RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-Linux-*
RUN sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.epel.cloud|g' /etc/yum.repos.d/CentOS-Linux-*
RUN ["yum", "install", "-y", "gcc", "gcc-c++", "net-tools", "make"]
WORKDIR /usr/local
ADD redis-4.0.14.tar.gz .
WORKDIR /usr/local/redis-4.0.14/src
RUN make && make install
WORKDIR /usr/local/redis-4.0.14
ADD redis-7000.conf .
EXPOSE 7000
CMD ["redis-server", "redis-7000.conf"]


docker build -t wovert.com/docker-redis .
docker run -p 7000:7000 wovert.com/docker-redis

docker pull redis
docker run redis
```


### 容器件通信

#### 容器件单向通信

tomcat -> mysql

```sh
docker run -d --name web tomcat
docker run -d --name database -it centos /bin/bash

docker inspect CONTAINER_ID （web）
docker inspect CONTAINER_ID （database）

docker exec -it CONTAINER_ID /bin/bash
ping 172.17.0.3 (database virtual ip)

docker rm -f WEB

# --link 单向通信
docker run -d --name web --link database tomcat
docker exec -it web
ping database
```


#### 容器件双向通信

```sh
docker network ls

docker network create -d bridge mybridge
docker network connect mybridge web
docker network connect mybridge database
```


### Volume 数据共享

1. 挂载宿主机目录
```sh
docker run --name CONT_NAME -v hostPath:containerPath imageName
docker run --name web1 -v /web/webapps:/usr/local/tomcat/webapps tomcat
docker run --name web2 -v /web/webapps:/usr/local/tomcat/webapps tomcat
```

2. 创建共享容器

```sh
#创建共享容器
docker create --name webpage -v /webapps:/tomcat/webapps tomcat /bin/true

# 共享容器挂载点
docker run --volumes-from webpage --name web1 -d tomcat
```


```sh
mkdir /usr/www && cd /usr/www
mkdir webapp && cd webapp
vim index.html

docker run --name web1 -p 8000:8080 -d -v /usr/www:/usr/local/tomcat/webapps tomcat
http://IP/webapp/index.html

# 创建共享容器
docker create --name webpage -v /usr/www:/usr/local/tomcat/webapps tomcat /bin/true

docker run -p 8002:8080 --volumes-from webpage --name web3 -d tomcat 

```

### Failed to get D-Bus connection: Operation not permitted



```sh
docker run -d --name my-mysql --privileged=true mysql:5.7.43 /sbin/init

```



# 创建镜像并启动镜像 -d: diamon
`docker-compose up -d`

docker-compose start/stop/state/ps



## php

```sh
#拉取php7.2镜像
docker pull php:7.2-fpm

#创建PHP容器        
docker run \
--name my-php  \
-p 9000:9000 \
-v ./www:/usr/share/nginx/html \
-v ./php/php.ini:/usr/local/etc/php/php.ini \
-v ./php/logs:/usr/local/var/log \
-d app_my-php

```

## nginx

```sh
#拉取nginx镜像
docker pull nginx:1.19

#创建nginx容器 
docker run \
--name nginx119  \
-p 80:80 \
-v ./www:/usr/share/nginx/html \
-v ./nginx/nginx.conf:/etc/nginx/nginx.conf \
-v ./nginx/conf.d:/etc/nginx/conf.d \
-v ./nginx/logs:/var/log/nginx \
--link php72 \
-d nginx:1.19
```

## mysql

```sh
#拉取nginx镜像
docker pull mysql:5.7

#创建nginx容器 
docker run \
--name mysql57  \
-p 3306:3306 \

-v ./mysql/mydir:/mydir
-v ./mysql/datadir:/var/lib/mysql
-v ./mysql/conf/my.cnf:/etc/my.cnf
-v ./mysql/source:/docker-entrypoint-initdb.d
-e MYSQL_ROOT_PASSWORD=root \ 
-e TZ=Asia/Seoul \

-d 
--link php-fpm mysql






```


## php-7.2

```sh
FROM php:7.2-fpm-alpine
RUN apk add --update --no-cache libgd libpng-dev libjpeg-turbo-dev freetype-dev
RUN docker-php-ext-install -j$(nproc) gd mysqli opcache
ADD php.ini /usr/local/etc/php.ini
```






