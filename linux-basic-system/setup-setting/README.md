# Linux 安装与配置-[沃尔特](https://www.wovert.com)

## Linux 发行版安装

> 本节以企业级 CentOS 6.9 操作系统安装为例子

### 下载 CentOS 6.9 操作系统

#### 下载 CentOS 6.9 操作系统镜像站

- [CentOS 官网](https://www.centos.org/)主页下有 **Older Versions** 标题下有[then click here>>](https://wiki.centos.org/Download) 选择版本跳转到选择[镜像站点列表页面](http://isoredirect.centos.org/centos/6/isos/x86_64/)，选择一个国内的镜像站点下载即可
- [阿里巴巴镜像站](https://mirrors.aliyun.com) https://mirrors.aliyun.com/centos/6/isos/x86_64/CentOS-6.9-x86_64-minimal.iso
- [网易镜像站](http://mirrors.163.com) http://mirrors.163.com/centos/6.9/isos/x86_64/CentOS-6.9-x86_64-minimal.iso
- [搜狐镜像站](http://mirrors.sohu.com) http://mirrors.sohu.com/centos/6.9/isos/x86_64/CentOS-6.9-x86_64-minimal.iso

#### ISO 文件

> 扩展名为".iso"格式的文件就是所谓的镜像文件。

由于bin-DVD 文件比较大，建议使用ftp客户端或下载工具来下载文件，因为中途一旦断网浏览器下载的文件就是无效文件而重新下载。

#### 安装 Linux 常见引导方式

- 光盘引导安装
- U 盘引导安装
- 网络安装（需要网卡支持，现在主流网卡都支持）

虚拟机环境可以直接使用 ISO 镜像，安装方式可以是上面三种方式的任何一种

#### 为什么选择 64 位操作系统而不是 32 位操作系统

1. 设计定位: 64 位操作系统的设计定位是满足机械设计和分析、三维动画、视频编辑，以及科学计算和高性能计算应用等领域。这些领域的共同特点是需要有大量的系统内存和浮点性能。也就是位高科技人员使用本行业特殊软件的运行平台而设计的，而32 位操作系统为普通用户设计的。

2. 安装要求配置: 64 位操作系统只能安装在 64 位CPU架构的计算机上，并且尽在 64 位的软件是才能发挥其最佳性能。虽然 32 位操作系统或软件也可以安装在 64 位CPU架构的计算机上，但无法发挥 64 位硬件性能。

3. 运算速度: 64 位 CPU GPPRs(General-Purpose Registers, 通用寄存器)的数据宽度为 64 位，64 位指令集可以运行 64 位数据指令，也就是说处理器一次课提取 64 位数据（只要两个指令，一次提取 8 字节的数据），比 32 位提高了一倍（32 位需要 4个指令，一次只能提取 4 字节的数据），性能会响应提升。

4. 寻址能力: 64 位处理器的在系统对内存的控制上使用更多的地址。比如，Windows 7 x86 Editions 支持高达 128 GB的物理内存和 16 TB 的虚拟内存，而 32 位的 CPU 和操作系统理论上仅支持 4 GB 的内存，实际上 3.2 GB 内存，当前也可以通过扩展来支持更大内存（PAE技术）。

64 位操作系统比 32 位操作系统 CPU 运算速度更快，支持更大的内存使用，可以发挥更大更好的硬件性能，提升业务工作效率。

#### 如何区分 32 位和 64 位

- 查看系统位数方法

`~]# uname -m` x86_64

`~]# uname -a`

.... i686 i386 GNU/Linux

i386/i686字样，说明该系统为 32 位。

- 系统跟目录下是否 /lib64 库目录: `~]# ls -d /lib64`

### 安装 CentOS 6.9 操作系统准备

#### 安装 VMware 虚拟机

### 开始安装 CentOS 6.9 操作系统

1. 选择系统引导方式
2. 检查安装光盘介质
3. 进入安装下一步界面
4. 安装过程语言选择
5. 选择键盘布局
6. 选择合适的物理设备
7. 初始化硬盘提示
8. 初始化主机名及配置网络; 设置主机名; 配置网卡及连接网络
9. 系统时钟及时区设置
10. 设置超级用户 root 口令; 设置 8 位以上包含数字、字母大小写、特殊字的的口令
11. 系统安装磁盘空间类型
- 选择自定义磁盘分区：Create Custom Layout
- Standard Partition
  - RAID Partition(磁盘冗余阵列): 一般通过硬件 RAID 卡的效率更高，操作系统的 RAID 功能性能差
  - LVM（逻辑卷管理）：设置好的分区大小进行动态调整。所有分区格式都实现做成 LVM 格式，即分区标号为 8e。企业环境的分区一般都是按需求事先规划好的，极少后续调整的需求，因此，不推荐选择 LVM

- 分区方案
  - /boot(ext4): 100~200MB 
  - swap: 物理内存的 1.5 倍，当内存大于或等于 8GB 时，配置为 8 ~ 16 GB即可。
  - /(ext4): 生于硬盘空间

12. 启动引导设备

- 引导程序为 grub, 选择在 MBR 中

13. 系统安装软件包

- 建议最小化安装原则，即不需要的或不确定是否需要的就不安装，这样可以最大程度上确保系统安装
- 补充安装
  - `~]# yum groupinstall "Compatibility libraries" "Base" "Development tools"`
  - `~]# yum groupinstall "debugging Tools" "Dial-up Networking Support"`

## 安装界面

- Install or upgrade an existing system (安装或升级已经存在的系统)
- Install system with basic video driver
- Resue installed system（救援安装系统）
- Boot from local drive（从本地启动）
- Memory test（内存测试）

1. 光盘完整性检查：建议(Skip)
2. Basic Storage Devices (基本存储设备)

## 系统安装后基本配置

### 配置网卡

`~]#setup` 或 `~]# vim /etc/sysconfig/network-scripts/ifcfg-eth0`

IP/netmask/gateway/禁止 DHCP/DNS1/DNS2

- 注意：ifcfg-eth0 网卡文件中不配置 DNS，只在 /etc/resolve.conf 中配置 DNS 设置，网卡重启命令 /etc/init.d/network restart 仍会清除 /etc/resolve.conf 的 DNS

- 重启网卡: `~]# /etc/init.d/network restart`

- 查看默认网管: `~]# route -n`

- 查看DNS: `~]# cat /etc/resolv.conf`

- 查看 IP 地址: `~]# ip addr list` 或 `ipconfig`

- 测试网络连通性: `~]# ping lingyima.com`

### 确保防火墙处于关闭状态

- 查看防火墙: `~]# iptable -L -n`

- 当前环境清空防火墙，重启系统之后防火墙仍然有效 :`~]# iptable -F`

- CentOS 7 下完全关闭防火墙操作

`~]# systemctl stop firewalld.service`

`~]# systemctl disable firewalld.service`

- CentOS 6 下完全关闭防火墙操作

`~]# service iptables stop`

`~]# chkconfig iptables off`

### 设定语言环境

`~]# locale`

`~]# localectl set.locale LANG=zh_CN.utf8`

LC_ALL=zh_CN.utf8

### 更新系统，打补丁到最新

#### 1. 修改更新源

``` shell
~]# cd /etc/yum.repos.d
~]# mv CentOS-Base.repo CentOS-Base.repo.back
~]# wget -O Centos-6-aliyun.repo http://https://mirrors.aliyun.com/repo/Centos-6.repo
~]# wget -O epel-6-aliyun.repo http://https://mirrors.aliyun.com/repo/epel-6.repo
```

#### 2. 系统更新到最新状态

``` shell
~]# ll /etc/pki/rp-gpg/
~]# rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY*
~]# yum update -y
```

#### 3. 安装额外工具包

``` shell
~]# yum -y install tree telnet dos2unix sysstat lrzsz nc nmap
~]# yum groupinstall "Development Tools"
```

### 远程连接

- 查看系统是否监听于 TCP 协议的 ssh 服务22端口: `~]# ss -tnl`