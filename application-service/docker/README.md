# 容器
> 容器是一种基础工具；泛指任何可以用于容纳其他物品的工具，可以部分或完全封闭，被用于容纳、存储、运输物品；物体可以被防止在容器中，而容器则可以保护内容物；

# LXC
> LinuX Container
- chroot, 根切换
- namespaces: 名称空间
- CGroup(Control): 控制组

- 虚拟机目的：隔离（测试环境、生产环境）
	+ 运行mongodb服务，主机虚拟化运行两个内核，浪费资源
	
- 一个内核上实现多个用户空间
	+ 用户空间（真特权） | 用户空间 | 用户空间
		* 各自有根文件系统、进程、管理、用户，按名称空间分割
		* 限制各个空间资源：CPU，内存等，按控制组
	+ OS 
	+ 硬件

## 安装 lxc, lxc-templates
- epel仓库
# yum clean all
# yum repolist
# yum info lxc
# yum -y install lxc lxc-templates
# rpm -ql lxc
# lxc-checkconfig
# rpm -ql lxc-templates

# lxc-create -h 
# cd /etc/sysconfig/network-scripts/ 
# cp ifcfg-eno16777736 ifcfg-virbr0

- 创建物理桥
`# vim ifcfg-virbr0`
	UUID 删除
	DEVICE=virbr0 
	TYPE=bridge
	name="System virbr0" 或删除

# vim ifcfg-eno16777736
删除地址:IP,NETMASK,GATEWAY,DNS
BRIDGE=virbr0
`# systemctl restart network.servie`

## 创建容器
`# lxc-create -h`

`# cd /usr/share/lxc/templates/`
`# cp lxc-centos{,.bak}`
`# vim lxc-centos`
[base]
#mirrorlist
baseurl=http://172.18.0.1/cobbler/ks_mirror/7/

[updates]
enables=0

`# lxc-create -n centos7 -t centos`

`# chroot /var/lib/lxc/centos7/rootfs passwd`
`# ls /var/lib/lxc/centos7`

## 运行容器
`# lxc-start -n centos7`
	centos7 login: root
`# ifconfig`
`# ip a l`
`# cd /etc/yum.repo.d/CentOS7-base.repo`
	baseurl=http://172.18.0.1/cobbler/ks_mirror/7/
	[updates]
	enable=0
	[extra]
	enable=0

`# yum repolist`
`# yum -y install net-tools`
`# ss -tunl`

- ssh远程登录


# lxc-info -n centos7
# lxc-top 
# lxc-monitor -n centos7

# lxc-freeze -n centos7 暂停在内存中
# lxc-unfreeze -n centos7

# lxc-stop -n centos7 正常关机

# lxc-start -n centos7 -d

# lxc-console -h

# lxc-attch -h


`# lxc-start -n centos7 -d`
`# ps aux`
`# laxc-info -n centos7`
# lxc-attach -n centos7 -t 0
`# lxc-console -n centos7 -t 0`
ctrl+a,q


- 检查系统环境是否满足容器使用要求
	lxc-checkconfig
- 创建lxc容器
	lxc-create -n NAME -t TEMPLATE_NAME
- 启动容器
	lxc-start -n NAME -d
- 查看容器相关的信息
	lxc-info NAME
- 附加至指定容器的控制台
	lxc-console -n NAME -t NUMBER
		NUMBER:
			0: 物理控制台
			1: tty1
			2: tty2
			...
	Ctrl+a,q

- 停止容器
	lxc-stop -n NAME
- 删除处于停机状态的容器
	lxc-destroy -n centos7

- 列出快照
	 lxc-snapshot -n centos7 -L
- 创建快照
	lxc-snapshot -n centos7

- 恢复快照
	lxc-snapshot -n centos7 -r snap1
- 删除快照
	lxc-snapshot -n centos7 -d snap0

- 克隆
	lxc-clone -s centos7 centos7-clone 
	overlayfs: error mouting...


`# yum -y install git`
`# git clone https://github.com/lxc-webpanel/LXC-Web-Panel.git`
`# cd LXC-Web-Panel/`
`# yum list all | grep flask`
`# yum -y install python-flask`
	repo源, enable=1
`# python ./lwp.py`
`# ss -tnl`
	admin:admin


# Docker
- Docker的只能运行一个进程，docker没有init
- 主要为了实现，进程的**分发**和**部署**
- LNMP要运行三个Docker
- docker -> moby
- Docker-CE
- Docker-EE

docker中的容器

- 运行环境
lxc->libcontainer->runC

- OCL规范

## Docker architecture
- Docker objects
	+ images
	+ containers
	+ networks
	+ volumes
- Docker client
- Docker registries

## 安装Docker
- 依赖的基础环境
	+ 64 bits CPU
	+ Linux Kernel 3.10+
	+ Linux Kernel cgroups and namespace
- CentOS 7
	+ extras repository

- Docker Daemon
	+ `systemctl start docker.service`
- Docker Client
	+ `docker [options] 	COMMAND [arg...]`

1. 修改yum源，启用[extras]源
`# yum repolist`
`# yum info docker`
`# yum -y install docker`
`# ifconfig`

`# systemctl start docker.service`
`# ifconfig`
	docker0: 172.17.0.1
`# iptables -t nat -vnL`

2. 镜像文件
[HubDocker](https://hub.docker.com)
`# docker search centos`
	docker.io docker.io/centos 官方镜像
`# docker pull NAME[:tag]`
`# docker pull busybox:lastest`
- 显示本地镜像
`# docker images -h`

- 拉取centos，默认7
`# docker pull centos`

- 拉取centos6
`# docker pull centos:6`

3. 启动容器
- 创建并启动
`# docker run --help`
`# docker run [OPTIONS] IMAGE [COMMAND] [ARG...]`
`# docker run --name c1 -it centos:latest /bin/bash`
`# vim /etc/um.repos.d/CentOS7-base.repo`
`# yum repolist`
`# yum -y install net-tools`
`# ifconfig`
	172.17.0.2

- 脱离终端
`# Ctrl+p,Ctrl+q`

- 查看运行容器
`# docker ps `
`# docker ps -a`

- 停止容器
`# docker stop c1`
`# docker ps`

- 删除容器
`# docker rm c1`
`# docker rm -f c1`

- 常用操作：
`docker search`: Search the Docker Hub for images
`docker pull`: Pull a image or a repository from a registry
`docker images`: List images
`docker create`: Create a new container
`docker start`: Start one or more stopped container
`docker run`: Run a command in a new container
`docker attach`: Attach to a running container
`docker ps`: List containers
`docker logs`: Fetch the logs of a container
`docker stop`: Stop one or more running containers
`docker kill`: Kill one or more running containers
`docker rm`: Remove one or more containers

docker run= docker create + docker start


- Docker Image Layer
	+ writeable | Container
	+ add Nginx | Image
	+ add net-tools | Image
	+ CentOS Base | Image
	+ bootts
	+ kernel













