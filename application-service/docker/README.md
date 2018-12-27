# 容器

> 容器是一种基础工具；泛指任何可以用于容纳其他物品的工具，可以部分或完全封闭，被用于容纳、存储、运输物品；物体可以被防止在容器中，而容器则可以保护内容物；

## 主机级虚拟化和容器级虚拟化

- 虚拟化目的：隔离进程，不影响其他进程，彼此之间不受影响。

![虚拟化对比](./images/hostos-container.jpg)

### 主机级虚拟化（完整物理平台，VMwareStation）

- Type-I()
- Type-II(hostOS，vmware,workerstation)

为每一个封闭的实例，提供的是一个**从底层硬件开始一直到高层**的基础环境。也就意味着说我们每一个对应的虚拟机实例就拥有自己可视的，而且是隔离于其它实例的基础硬件，包括CPU,内存等等，所以它在硬件完成资源划分以后，提供给了我们每一个实例一个基础环境，使得我们每一个实例都得安装操作系统，从而就拥有自己的内核空间和用户空间，所以这么一来不当紧，做为当前实例的使用者，就得安装操作系统，提供环境，安装程序并提供配置文件，最终才可用服务。

主机级虚拟化，由于做了两级内核，虚拟机自己有一级，hypervisor会有**性能损耗**，但是**隔离性是非常好**的。但**过于重量级**。

### 容器级虚拟化

- CPU 可压缩机制（挂起等待）
- Mem 不可压缩机制
  - 大量占用内存，OOM kill掉 ——> 内核Control Groups, CGroups实现

为什么出现容器技术：
如果现在我打算在一台完全隔离的环境中，尽量不影响其它应用的情况下，安装一个tomcat。做为一个程序猿来讲，发部一个新程序就要运行在tomcat上测试下。这时候我提供给用户的仅仅是一个虚拟机，即便安装好操作系统，用户还得安装tomcat等，会非常麻烦，过程就感觉很重量。因为我们额外步骤会非常的多。所以这种虚拟化方式过于重量级，尤其在某些轻量级的需求面前它就显得欲发重量。所以在这种情况下就出现了容器技术。

容器技术：

用户空间仅仅运行用户进程而以，就不需要在主机级虚拟化技术上，它自己管理自己的内核，把虚拟出来的内核给剥离掉。给用户一个chroot环境，在这个虚根下，能够隔离和其它用户相关的用户环境。

在内核中的一个逻辑级别能够设置为隔离开来的区域，彼此之间互相不干扰，不影响的话。那么我们就可以做出来**仅在用户空间**，就能实现**隔离的组件**来。那这个在用户空间就能实现的**组件**就称为“**容器**”。每一个空间就称为一个容器，因为每一个空间都容纳了一堆的**进程和用户帐号文件**等等

将内核分为**多个空间**，然后每个空间能够提供一个完整意义上的**程序运行环境**，容纳了文件，系统和进程以及彼此间职离的一些组件。我们把这些技术称之为容器。

1. FreeBSD, jail 隔离技术
2. Linux, vserver(chroot)

## LXC

> LinuX Container - LXC

创建进程并保护其进程不被其他进程所干扰——容器

容器技术实现：**chroot+namespaces+cgroups**

- chroot, 根切换
- namespaces: 名称空间
- CGroups(Control): 控制组
  - blkio: 块设备IO
  - cpu: CPU
  - cpuacct: CPU资源使用报告
  - cpuset: 多处理器平台上的CPU集合(比例分配，核分配)
  - devices: 设备访问(启用一个用户空间对该光驱设备可资源分配)
  - freezer: 挂起或恢复任务
  - memory: 内存用量及报告
  - pref_event: 对cgroup中的任务进行统一性能测试
  - net_cls: cgroup 中的任务创建的数据报文的类型标识符

### Control Groups

- group1
- group1-1 自动拥有group1的拥有权限
- group1-2
- group2
- group2-1
- group3

- cgroups隔离性不如主机虚拟化，为了防止一个用户空间通过访问其他用户使用selinux技术加固用户空间的容器的边界。但大多数不启用其就技术。

- Linux内核级创建名称空间(namespaces)
  - 6个 namespace + chroot 实现容器技术

- 使用内核级的名称空间及时+chroot实现
- namespace()
  - clone() -> setns() 放置容器

### Linux Namespaces

- 虚拟机目的：隔离（测试环境、生产环境）
  - 运行mongodb服务，主机虚拟化运行两个内核，浪费资源

- 一个内核上实现多个用户空间
  - 用户空间（真特权） | 用户空间 | 用户空间
    - 各自有根文件系统、进程、管理、用户，按名称空间分割
    - 限制各个空间资源：CPU(可压缩性资源)，内存(内存耗完 **OOM**内存不足)等，按控制组
      - 内存：按照用户空间比例配置或单个用户空间最大分配资源
        - 3个用户空间内存分配: 1:2:1
        - 4个用户空间内存分配: 1:2:1
        - 单个用户空间最多可使用最大分配资源
  - OS
  - 硬件

| namespace | 系统调用参数   | 隔离内容                 | 内核版本
| --------- | -----------   | -------                      | ------ |
| UTS       | CLONE_NEWUTS  | 主机名和域名                  | 2.6.19 |
| PIC       | CLONE_NEWIPC  | 信号量、消息队列和共享内存     | 2.6.19 |
| PID       | CLONE_NEWPID  | 进程编号                      | 2.6.24 |
| Network   | CLONE_NEWNET  | 网络设备、网络栈、端口等       | 2.6.29 |
| Mount     | CLONE_NEWNS   | 挂载点(文件系统)              | 2.4.19 |
| User      | CLONE_NEWUSER | 用户和用户组                  | 3.8 |

- CentOS 6 不支持 Docker，内核2.6

### 安装 LXC

> lxc-templates

基于模板，就是脚本，这个脚本创建名称空间以后自动执行，在脚本执行环境。这个脚本自动的去实现安装过程。这个安装
指向了你说打算创建那个类的名称空间系统发行版所属的仓库，从仓库中拉取下载各种包进行安装，生成这个行的名称空间。这个名称空间就像虚拟机一样可以使用。

在子目录执行脚本并创建名称空间，然后chroot，就可以拥有虚拟机了

**epel仓库**

``` sh
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
```

**创建物理桥**

``` sh
# vim ifcfg-virbr0
  UUID 删除
  DEVICE=virbr0
  TYPE=bridge
  name="System virbr0" 或删除

# vim ifcfg-eno16777736
  删除地址:IP,NETMASK,GATEWAY,DNS
  BRIDGE=virbr0

# systemctl restart network.servie
```

**创建容器**

``` shell
# lxc-create -h
# cd /usr/share/lxc/templates/
# cp lxc-centos{,.bak}
# vim lxc-centos
  [base]
  #mirrorlist
  baseurl=http://172.18.0.1/cobbler/ks_mirror/7/

  [updates]
  enables=0

# lxc-create -n centos7 -t centos
# chroot /var/lib/lxc/centos7/rootfs passwd
# ls /var/lib/lxc/centos7
```

**运行容器**

``` shell
# lxc-start -n centos7
  centos7 login: root
# ifconfig
# ip a l
# cd /etc/yum.repo.d/CentOS7-base.repo
  baseurl=http://172.18.0.1/cobbler/ks_mirror/7/
  [updates]
  enable=0
  [extra]
  enable=0

# yum repolist
# yum -y install net-tools
# ss -tunl
```

**ssh远程登录**

``` sh
# lxc-info -n centos7
# lxc-top
# lxc-monitor -n centos7

# lxc-freeze -n centos7 暂停在内存中
# lxc-unfreeze -n centos7

# lxc-stop -n centos7 正常关机

# lxc-start -n centos7 -d

# lxc-console -h

# lxc-attch -h


# lxc-start -n centos7 -d
# ps aux
# laxc-info -n centos7
# lxc-attach -n centos7 -t 0
# lxc-console -n centos7 -t 0
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

# yum -y install git
# git clone https://github.com/lxc-webpanel/LXC-Web-Panel.git
# cd LXC-Web-Panel/
# yum list all | grep flask
# yum -y install python-flask
  repo源, enable=1
# python ./lwp.py
# ss -tnl
  admin:admin
```

## Docker

- 基于LXC的二次封装发行版的增强版
- Docker的只能运行一个进程，docker没有init
- 主要为了实现，进程的**分发**和**部署**
- LNMP要运行三个Docker
- docker -> moby
- Docker-CE
- Docker-EE

一个OS用户空间所需要的所有组件事先准备编排好以后整体打包成一个文件，这个文件就是镜像文件。此镜像文件存放在集中仓库内。比如：UbuntOS镜像，Nginx镜像。创建容器的时候，不会激活模板安装，会链接镜像服务器上加载匹配你的创建容器所需要的镜像拖到本地，基于镜像来启动容器，所以socker极大的简化了容器的难度。一个容器内只能运行一个进程。监控运行程序必须在容器里安装才能调试进程，容器对于开发人员极大地便利，但对于运维不便利。

在CentOS/Ubuntu/OpenSuSE 开发适用于每一种OS的软件，每个OS的配置文件都不一样。但docker有自己的文件系统和用户管理不同考虑OS的不同配置等。

docker中的容器

- 运行环境: lxc->libcontainer->runC

- OCL规范

68：30

### Docker architecture

- Docker objects
  - images
  - containers
  - networks
  - volumes
- Docker client
- Docker registries

### 安装Docker

- 依赖的基础环境
  - 64 bits CPU
  - Linux Kernel 3.10+
  - Linux Kernel cgroups and namespace
- CentOS 7
  - extras repository

- Docker Daemon
  - `systemctl start docker.service`
- Docker Client
  - `docker [options] COMMAND [arg...]`

1. 修改yum源，启用[extras]源

``` shell
# yum repolist
# yum info docker
# yum -y install docker
# ifconfig

# systemctl start docker.service
# ifconfig
  docker0: 172.17.0.1
# iptables -t nat -vnL

2. 镜像文件
[HubDocker](https://hub.docker.com)
# docker search centos
  docker.io docker.io/centos 官方镜像
# docker pull NAME[:tag]
# docker pull busybox:lastest
- 显示本地镜像
# docker images -h

- 拉取centos，默认7
# docker pull centos

- 拉取centos6
# docker pull centos:6

3. 启动容器
- 创建并启动
# docker run --help
# docker run [OPTIONS] IMAGE [COMMAND] [ARG...]
# docker run --name c1 -it centos:latest /bin/bash
# vim /etc/um.repos.d/CentOS7-base.repo
# yum repolist
# yum -y install net-tools
# ifconfig
  172.17.0.2

- 脱离终端
# Ctrl+p,Ctrl+q

- 查看运行容器
# docker ps
# docker ps -a

- 停止容器
# docker stop c1
# docker ps

- 删除容器
# docker rm c1
# docker rm -f c1

- 常用操作：
# docker search : Search the Docker Hub for images
# docker pull : Pull a image or a repository from a registry
# docker images : List images
# docker create : Create a new container
# docker start: Start one or more stopped container
# docker run: Run a command in a new container
# docker attach: Attach to a running container
# docker ps: List containers
# docker logs: Fetch the logs of a container
# docker stop: Stop one or more running containers
# docker kill: Kill one or more running containers
# docker rm: Remove one or more containers

docker run= docker create + docker start


- Docker Image Layer
  - writeable | Container
  - add Nginx | Image
  - add net-tools | Image
  - CentOS Base | Image
  - bootts
  - kernel













