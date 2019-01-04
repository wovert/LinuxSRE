# 容器

> 容器是一种基础工具；泛指任何可以用于容纳其他物品的工具，可以部分或完全封闭，被用于容纳、存储、运输物品；物体可以被防止在容器中，而容器则可以保护内容物；

## 由PaaS到Container

2013年2月，前Gluster的CEO Ben Golub和dotCloud的CEO Solomon Hykes坐在一起聊天时，Solomon谈到想把dotCloud内部使用的Container容器技术单独拿出来开源，然后围绕这个技术开一家新公司提供技术支持。28岁的Solomon在使用python开发dotCloud的PaaS云时发现，使用 LXC(Linux Container) 技术可以打破产品发布过程中应用开发工程师和系统工程师两者之间无法轻松协作发布产品的难题。这个Container容器技术可以把开发者从日常部署应用的繁杂工作中解脱出来，让开发者能专心写好程序；从系统工程师的角度来看也是一样，他们迫切需要从各种混乱的部署文档中解脱出来，让系统工程师专注在应用的水平扩展、稳定发布的解决方案上。他们越深入交谈，越觉得这是一次云技术的变革，紧接着在2013年3月Docker 0.1发布，拉开了基于云计算平台发布产品方式的变革序幕。

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

## OCI

> Open Container Initiative

- Linux基金会主导与2015年6月创立
- 围绕容器格式和运行时机制顶一个开放的工业化标准

- contains two specifications
  - The **Runtime** Specifications(runtime-spec)
  - The **Image** Specifications(image-spec)

- The Runtie Specification outlines how to run a "filesystem bundle" that is unpacked on disk
- At a high-level an OCI implementation would download an OCI Image then unpack that image into an OCI Runtime filesystem bundle.

## runC

OCF: Open Container Format(开发容器格式)

- runC(实现的) is a CLI tool for spawning and running container according to the OCI specification

## Docker

![docker introduction](./images/docker-intro.png)

Docker 是 Docker.Inc 公司开源的一个基于 LXC技术之上构建的Container容器引擎， 源代码托管在 GitHub 上, 基于Go语言并遵从Apache2.0协议开源。 Docker在2014年6月召开DockerConf 2014技术大会吸引了IBM、Google、RedHat等业界知名公司的关注和技术支持，无论是从 GitHub 上的代码活跃度，还是Redhat宣布在RHEL7中正式支持Docker, 都给业界一个信号，这是一项创新型的技术解决方案。 就连 Google 公司的 Compute Engine 也支持 docker 在其之上运行, 国内“BAT”先锋企业百度Baidu App Engine(BAE)平台也是以Docker作为其PaaS云基础。

### Docker产生的目的就是为了解决以下问题

1) 环境管理复杂: 从各种OS到各种中间件再到各种App，一款产品能够成功发布，作为开发者需要关心的东西太多，且难于管理，这个问题在软件行业中普遍存在并需要直接面对。Docker可以简化部署多种应用实例工作，比如Web应用、后台应用、数据库应用、大数据应用比如Hadoop集群、消息队列等等都可以打包成一个Image部署。如图所示：

![docker flow](./images/docker-flow.png)

2) 云计算时代的到来: AWS的成功, 引导开发者将应用转移到云上, 解决了硬件管理的问题，然而软件配置和管理相关的问题依然存在 (AWS cloudformation是这个方向的业界标准, 样例模板可参考这里)。Docker的出现正好能帮助软件开发者开阔思路，尝试新的软件管理方法来解决这个问题。

3) 虚拟化手段的变化: 云时代采用标配硬件来降低成本，采用虚拟化手段来满足用户按需分配的资源需求以及保证可用性和隔离性。然而无论是KVM还是Xen，在 Docker 看来都在浪费资源，因为用户需要的是高效运行环境而非OS, GuestOS既浪费资源又难于管理, 更加轻量级的LXC更加灵活和快速。如图所示：

![container vs vms](./images/container-vs-vms.jpg)


4) LXC的便携性: LXC在 Linux 2.6 的 Kernel 里就已经存在了，但是其设计之初并非为云计算考虑的，缺少标准化的描述手段和容器的可便携性，决定其构建出的环境难于分发和标准化管理(相对于KVM之类image和snapshot的概念)。Docker就在这个问题上做出了实质性的创新方法。

### 核心技术预览

Docker核心是一个操作系统级虚拟化方法, 理解起来可能并不像VM那样直观。我们从虚拟化方法的四个方面：隔离性、可配额/可度量、便携性、安全性来详细介绍Docker的技术细节。


2.1. 隔离性: Linux Namespace(ns)

每个用户实例之间相互隔离, 互不影响。 一般的硬件虚拟化方法给出的方法是VM，而LXC给出的方法是container，更细一点讲就是kernel namespace。其中pid、net、ipc、mnt、uts、user等namespace将container的进程、网络、消息、文件系统、UTS("UNIX Time-sharing System")和用户空间隔离开。

1) pid namespace

不同用户的进程就是通过pid namespace隔离开的，且不同 namespace 中可以有相同pid。所有的LXC进程在docker中的父进程为docker进程，每个lxc进程具有不同的namespace。同时由于允许嵌套，因此可以很方便的实现 Docker in Docker。

2) net namespace

有了 pid namespace, 每个namespace中的pid能够相互隔离，但是网络端口还是共享host的端口。网络隔离是通过net namespace实现的， 每个net namespace有独立的 network devices, IP addresses, IP routing tables, /proc/net 目录。这样每个container的网络就能隔离开来。docker默认采用veth的方式将container中的虚拟网卡同host上的一个docker bridge: docker0连接在一起。

3) ipc namespace

container中进程交互还是采用linux常见的进程间交互方法(interprocess communication - IPC), 包括常见的信号量、消息队列和共享内存。然而同 VM 不同的是，container 的进程间交互实际上还是host上具有相同pid namespace中的进程间交互，因此需要在IPC资源申请时加入namespace信息 - 每个IPC资源有一个唯一的 32 位 ID。

4) mnt namespace

类似chroot，将一个进程放到一个特定的目录执行。mnt namespace允许不同namespace的进程看到的文件结构不同，这样每个 namespace 中的进程所看到的文件目录就被隔离开了。同chroot不同，每个namespace中的container在/proc/mounts的信息只包含所在namespace的mount point。

5) uts namespace

UTS("UNIX Time-sharing System") namespace允许每个container拥有独立的hostname和domain name, 使其在网络上可以被视作一个独立的节点而非Host上的一个进程。

6) user namespace

每个container可以有不同的 user 和 group id, 也就是说可以在container内部用container内部的用户执行程序而非Host上的用户。

2.2 可配额/可度量 - Control Groups (cgroups)

cgroups 实现了对资源的配额和度量。 cgroups 的使用非常简单，提供类似文件的接口，在 /cgroup目录下新建一个文件夹即可新建一个group，在此文件夹中新建task文件，并将pid写入该文件，即可实现对该进程的资源控制。groups可以限制blkio、cpu、cpuacct、cpuset、devices、freezer、memory、net_cls、ns九大子系统的资源，以下是每个子系统的详细说明：

blkio 这个子系统设置限制每个块设备的输入输出控制。例如:磁盘，光盘以及usb等等。

cpu 这个子系统使用调度程序为cgroup任务提供cpu的访问。

cpuacct 产生cgroup任务的cpu资源报告。

cpuset 如果是多核心的cpu，这个子系统会为cgroup任务分配单独的cpu和内存。

devices 允许或拒绝cgroup任务对设备的访问。

freezer 暂停和恢复cgroup任务。

memory 设置每个cgroup的内存限制以及产生内存资源报告。

net_cls 标记每个网络包以供cgroup方便使用。

ns 名称空间子系统。

以上九个子系统之间也存在着一定的关系.详情请参阅官方文档。

2.3 便携性: AUFS

AUFS (AnotherUnionFS) 是一种 Union FS, 简单来说就是支持将不同目录挂载到同一个虚拟文件系统下(unite several directories into a single virtual filesystem)的文件系统, 更进一步的理解, AUFS支持为每一个成员目录(类似Git Branch)设定readonly、readwrite 和 whiteout-able 权限, 同时 AUFS 里有一个类似分层的概念, 对 readonly 权限的 branch 可以逻辑上进行修改(增量地, 不影响 readonly 部分的)。通常 Union FS 有两个用途, 一方面可以实现不借助 LVM、RAID 将多个disk挂到同一个目录下, 另一个更常用的就是将一个 readonly 的 branch 和一个 writeable 的 branch 联合在一起，Live CD正是基于此方法可以允许在 OS image 不变的基础上允许用户在其上进行一些写操作。Docker 在 AUFS 上构建的 container image 也正是如此，接下来我们从启动 container 中的 linux 为例来介绍 docker 对AUFS特性的运用。

典型的启动Linux运行需要两个FS: bootfs + rootfs:

![Docker Images](./images/docker-images.png)

bootfs (boot file system) 主要包含 bootloader 和 kernel, bootloader主要是引导加载kernel, 当boot成功后 kernel 被加载到内存中后 bootfs就被umount了. rootfs (root file system) 包含的就是典型 Linux 系统中的 /dev, /proc,/bin, /etc 等标准目录和文件。

对于不同的linux发行版, bootfs基本是一致的, 但rootfs会有差别, 因此不同的发行版可以公用bootfs 如下图:

![busybox](./images/buxybox.png)

典型的Linux在启动后，首先将 rootfs 设置为 readonly, 进行一系列检查, 然后将其切换为 "readwrite" 供用户使用。在Docker中，初始化时也是将 rootfs 以readonly方式加载并检查，然而接下来利用 union mount 的方式将一个 readwrite 文件系统挂载在 readonly 的rootfs之上，并且允许再次将下层的 FS(file system) 设定为readonly 并且向上叠加, 这样一组readonly和一个writeable的结构构成一个container的运行时态, 每一个FS被称作一个FS层。如下图:

![Docker Image Layer](./images/docker-image-layer.png)

得益于AUFS的特性, 每一个对readonly层文件/目录的修改都只会存在于上层的writeable层中。这样由于不存在竞争, 多个container可以共享readonly的FS层。 所以Docker将readonly的FS层称作 "image" - 对于container而言整个rootfs都是read-write的，但事实上所有的修改都写入最上层的writeable层中, image不保存用户状态，只用于模板、新建和复制使用。

![Docker Image Layer](./images/01.png)

上层的image依赖下层的image，因此Docker中把下层的image称作父image，没有父image的image称作base image。因此想要从一个image启动一个container，Docker会先加载这个image和依赖的父images以及base image，用户的进程运行在writeable的layer中。所有parent image中的数据信息以及 ID、网络和lxc管理的资源限制等具体container的配置，构成一个Docker概念上的container。如下图:

![Docker Image Layer](./images/02.png)

2.4 安全性: AppArmor, SELinux, GRSEC

安全永远是相对的，这里有三个方面可以考虑Docker的安全特性:

由kernel namespaces和cgroups实现的Linux系统固有的安全标准;

Docker Deamon的安全接口;

Linux本身的安全加固解决方案,类如AppArmor, SELinux;

由于安全属于非常具体的技术，这里不在赘述，请直接参阅Docker官方文档。

3. 最新子项目介绍

![docker架构](./images/sub-project.png)

我们再来看看Docker社区还有哪些子项目值得我们去好好研究和学习。基于这个目的，我把有趣的核心项目给大家罗列出来，让热心的读者能快速跟进自己感兴趣的项目:

Libswarm，是Solomon Hykes (Docker的CTO) 在DockerCon 2014峰会上向社区介绍的新“乐高积木”工具: 它是用来统一分布式系统的网络接口的API。Libswarm要解决的问题是，基于Docker构建的分布式应用已经催生了多个基于Docker的服务发现(Serivce Discovery)项目，例如etcd, fleet, geard, mesos, shipyard, serf等等，每一套解决方案都有自己的通讯协议和使用方法，使用其中的任意一款都会局限在某一个特定的技术范围內。所以Docker的CTO就想用libswarm暴露出通用的API接口给分布式系统使用，打破既定的协议限制。目前项目还在早期发展阶段，值得参与。

Libchan，是一个底层的网络库，为上层 Libswarm 提供支持。相当于给Docker加上了ZeroMQ或RabbitMQ，这里自己实现网络库的好处是对Docker做了特别优化，更加轻量级。一般开发者不会直接用到它，大家更多的还是使用Libswarm来和容器交互。喜欢底层实现的网络工程师可能对此感兴趣，不妨一看。

Libcontainer，Docker技术的核心部分，单独列出来也是因为这一块的功能相对独立，功能代码的迭代升级非常快。想了解Docker最新的支持特性应该多关注这个模块。


[docker镜像源](https://hub.docker.com)

![docker架构](./images/architecture.png)

- Client
  - docker build
  - docker pull
  - docker run
- DOCKER_HOST
  - Docker daemon (守护进程)
    - ipv4
    - ipv5
    - unix sock file
  - Images(从Registry下载镜像)
    - Ubuntu
    - Redis
  - Containers
    - 容器1
    - 容器2
    - 容器3

- 为了加速下载镜像，

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

- OCL(Oopen Container Initiative)规范

批量创建容器

- 镜像构建：分层构建，联合挂在实现

- nginx(挂载) | apache(挂载) | tomcat(挂载)
- 挂载数据存储（另外一个服务器独立存放的数据服务器）

- 镜像层
  - nginx(只读的) | apache(只读的) | tomcat(只读的)
  - centos(底层共享，只读)

- 编排工具
  - nmp
  - machine+swarm+compose
  - mesos + maratbon(统一资源调度)
  - kubernetes -> k8s
  - libcontainer->runC(容器运行时的环境标准，工业标准)

- Moby(Enterprise Docker)
- CNCF(google,IBM) 另外一个docker

### Docker architecture

- Docker objects
  - images
  - containers
  - networks
  - volumes
- Docker client
- Docker registries
  - 镜像存储的仓库
  - 用户认证
  - 一个仓库(nginx)只有一个应用程序的镜像(包含多个标签，nginx:1.15,  nginx:stable, nginx:latest)
  - 镜像：静态
  - 容器：动态，声明周期
  - 镜像与容器是程序与进程的关系

### 安装及使用Docker

- 依赖的基础环境
  - 64 bits CPU
  - Linux Kernel 3.10+
  - Linux Kernel cgroups and namespace
- CentOS 7
  - "extras" repository
  - `/etc/yum.repos.d/extras`

- Docker Daemon
  - `systemctl start docker.service`
- Docker Client
  - `docker [options] COMMAND [arg...]`

- extras源: `docker`
- 自定义源: `docker-ce`

- 常用操作
  - docker search: Search the Docker Hub for images
  - docker pull: Pull an image or a repository from a registry
  - docker images: List images
  - docker create: Create a new container
  - docker start: Start one or more stopped containers
  - docker run: Run a command in a new container
  - docker attach: Attach to a running container
  - docker ps: List containers
  - docker logs: Fetch the logs of a container
  - docker restart: Restart a container
  - docker stop: Stop one or more running containers
  - docker kill: Kill one or more running containers
  - docker rm: Remove one or more containers

#### 1. 修改yum源

``` sh

# cd /etc/yum.repos.d

下载配置文件
# wget https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/centos/docker-ce.repo
# vim docker-ce.repo
:%s@https://download.docker.com@https://mirrors.tuna.tsinghua.edu.cn/docker-ce
# yum repolist


启用[extras]源 使用docker, 上面镜像使用docker-ce
# yum info docker-ce
# yum -y install docker-ce
# ifconfig

镜像加速器
# vim /etc/docker/daemon.json
  {
    "registry-mirrors": ["https://registry.docker-cn.com"]
  }


docker帮助
# docker
# docker container --help
# docker version
# docker info

docker info报错docker bridge-nf-call-iptables is disabled解决办法

在CentOS中
# vim /etc/sysctl.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-arptables = 1

# systemctl start docker.service
# ifconfig
  docker0: 172.17.0.1
# iptables -t nat -vnL
```

#### 2. 镜像文件

[HubDocker](https://hub.docker.com)

``` sh
# docker search centos
  CIAL AUTOMATED
  nginx 顶级仓库/官方仓库
  jwilder/nginx-proxy 个人用户仓库

  alpine: 微型发行版，空间小，缺少调试的工具

  docker.io docker.io/centos 官方镜像

- 拉取nginx-alpine镜像
# docker [image] pull NAME[:tag]
# docker image pull nginx:1.14-alpine
# docker image pull nginx:1.14-alpine

- 刪除镜像
# docker rmi busybox

- 显示本地镜像列表
# docker images ls
# docker image ls --help

- 拉取centos，默认7
# docker pull centos

- 拉取centos6
# docker pull centos:6
```

#### 3. 容器操作 - docker container

``` sh
- 创建容器
# docker container ls

- 创建并启动
# docker [container] run --help
# docker [container] run [OPTIONS] IMAGE [COMMAND] [ARG...]
# docker [container] run --name c1 -it centos:latest /bin/bash

-it 交互式启动busybox
#docker run --name b1 -it busybox:latest

# mkdir /data/html -p
# vi /data/html/index.html
# httpd -f -h /data/html/
Ctrl+c 退出 httpd
# exit 退出shell，即退出容器（停止容器状态）
# docker ps -a
# docker container ls -a

激活停止的容器(attach,interactive)
# docker container start -i -a b1
# docker kill (强制终止)
# docker ps -a
# docker container rm b1 (删除容器)
# docker ps -a

打开终端
# docker ps
# docker inspect b1
# curl 172.17.0.2


启动nginx(没有下载镜像会自动从docker镜像站下载镜像) -d：daemon 后台
# docker container run --name web1 -d nginx:1.14-alpine

打开终端
# curl 172.17.0.2

启动redis
# docker run --name kvstor1 -d redis:4-alpine

在容器中运行客户端命令
# docker container exec -it kvstor1 /bin/sh
# ps
# netstat -tnl
# redis-cli
> keys
> SELECT 1
> exit
/data # exit

查看日志
# docker container logs web1


- 安装网络查看工具
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
```

### docker 组件

- docker程序环境
  - 环境配置文件
    - /etc/sysconfig/docker-network
    - /etc/sysconfnig/docker-storage
    - /etc/sysconfig/docker

  - Unit File
    - /usr/lib/systemd/system/docker.service
  - Docker REgistry 配置文件
    - /etc/containers/registries.conf
  - docker-ce
    - 配置文件：`/etc/docker/daemon.json`
      - {"registry-mirrors": ["https://registry.docker-cn.com"]}

- Docker镜像加速
  - docker cn
  - 阿里云加速器
  - 中国科技大学

- 注册阿里云账号，专用加速器地址获得路径
  - https://cr.console.aliyun.com/#/accelerator

- 物理：client <--> Daemon <--> Registry Server
- 逻辑
  - Containers

![docker event state](./images/docker-event-state.png)

## docker镜像管理基础

### docker 架构

docker host运行docker daemon(守护进程)的主机。docker daemon接受客户端请求通过http或https协议与客户端交互，客户端主机可以是远程主机（docker creat,docker run都是客户端命令）
docker daemon 接收到 docker create 创建容器，docker run 启动容器的命令。一个 docker host 可以启动多个容器，即运行多个应用程序。而容器的运行时基于镜像来实现的。如果镜像本地没有，docker daemon 会自动连到 docker registries上从中获取镜像，先把镜像存储在本地存储镜像空间中。这个镜像空间是专有的文件系统(overlay2)。镜像是只读的。仓库名是应用程序名，而仓库内可以放置多个镜像，而多个镜像是同一个应用程序的多个版本。可以用标签来识别镜像。镜像就是应用程序的集装箱。

Docker? 码头工人，装卸集装箱。

### About Docker Images

Docker 镜像含有启动容器所需要的**文件系统**及其内容，因此，其用于创建并启动 docker容器

采用**分层构建机制**，最底层为**bootfs**, 其之为 **rootfs**

![Docker Images](./images/docker-images.png)

- bootfs: **用于系统引导的文件系统**，包括 bootloader和kernel，容器启动完成后会**被卸载**以节约内存资源
- rootfs: 位于 bootfs 之上，表现为docker容器的**根文件系统**
  - 传统的模式中，系统启动之时，内核挂在rootfs时会首先将其挂载为“只读”模式，完整性自检完成后将其重新挂载为读写模式
  - docker中，rootfs有内核挂载为“只读”模式，而后通过“联合挂载”技术额外挂载一个“可写”层

### Docker Image Layer

- 位于下层的镜像称为父镜像（parent image），最底层的称为基础基础镜像（base image）
- 最上层为“可读写”层，其下层为“只读”层

![Docker Image Layer](./images/docker-image-layer.png)