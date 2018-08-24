# 编译内核

## 程序包的编译安装

- 前提: 开发环境
  - 开发工具 gcc,开发库
  - 头文件(`/usr/include`)

``` shell
检查编译依赖环境关系并设定编译参数
# ./configure

 编译过程（调用工具）
# make

安装（编译好的文件复制对应的目录下）
# make install`
```

- 开源：源代码 -> 可执行格式
  - 发行版：以"通用"的目标
    - 各种开源的源代码编译好后组织有效利用提供给用户

## 6.4 内核有bug？强制服务重启

- 解决方案：升级内核

## 标准化

- 硬件标准化
- 内核标准化
- 软件标准化
- 路径标准化

## 编译内核前提

1. 准备好开发环境：gcc工具
2. 获取目标主机上**硬件设备**相关的信息：设备驱动程序
3. 获取到目标主机**系统功能**的相关的信息，例如要启用的文件系统
4. 获取内核源代码：www.kernel.org

### 准备开发环境

### CentOS 6,7 包组

- Development Tools 开发工具
- Server Platform Developemnt 服务器平台开发

``` shell
# yum grouplist
# yum list all  *ncurses*
```

CentOS 6, 7 包组

``` shell
# yum -y groupinstall "Development Tools"
# yum -y groupinstall "Server Platform Developemnt"
# yum -y install *ncurses*
```

- 获取目标主机上硬件设备的相关信息

### CPU

``` shell
# cat /proc/cpuinfo
  vendor_id
  model_name:
# lscpu
# yum -y install x86info
# x86info --help
# x86info -a
```

### PIC设备

``` shell
# lspci [-v | vv]
  - PCI bridge 北桥
  - ISA bridge 南桥
  - IDE interface IDE接口
  - Bridge: Inter Corporation
  - System peripheral: VMware 集成接口
  - VGA 显卡
  - SCSI storage controller:
  - Ethernet controller
  - USB controller: USB1.1 UHCI Controller
  - USB controller: USB2 EHCI Controller
  - USB controller: USB3 XHCI Controller
# lsusb [-v | -vv]
# lsblk 硬盘信息
```

### 了解全部硬件设备信息：

``` shell
CentOS 6
# yum list all | grep hal  
# hal-device
```

### 查看 CPU 物理个数

`# grep 'physical id' /proc/cpuinfo | sort -u | wc -l`

### 查看 CPU 核心数量

`# grep 'core id' /proc/cpuinfo | sort -u | wc -l`

### 查看 CPU 线程数

`# grep 'processor' /proc/cpuinfo | sort -u | wc -l`

### 查看 CPU  型号

`# dmidecode -s processor-version`

### 查看 CPU 的详细信息：

`# cat /proc/cpuinfo`

**注意： udev相关信息是可以参考**

### 内核编译过程

``` shell
# tar xf linux-3.10.107.tar.xz -C /usr/src
# cd /usr/src
# ln -sv linux-3.10.107 linux
# cd linux
配置内核选项
# make menuconfig
编译内核，-j指定内核线程数量
# make [-j #]
安装内核模块
# make modules_install
# make install` 安装内核核心
```

### screen命令：打开新的屏幕，不会终端断开而关闭

- 打开screen: `# screen`
- 列出screen: `# screen -ls` 
- 拆除screen: `Ctrl+a,d`
- 连接screen: `# screen -r SCREEN_ID`
- 关闭screen: `# exit`

### 配置内核选项：

参考当前内核编译文件

``` shell
# cd /usr/src/linux
编译内核文件
# ls /boot/config-$(uname -r)
```

有些发行版在这里支持 /proc/config.gz

``` shell
# cp /boot/config-$(uname -r) /usr/src/linux/.config
# vim /usr/src/linux/.config
# cd /usr/src/linux
# make menuconfig
```

- 64-bit kernel 64内核编译(不选择编译成32位)
- General setup 通用设定
  - Local version - append to kernel release
    - -1.el7 （第一次编译el7）
  - Default hostname

- Enable loadable module support 是否支持模块动态装载（必须）

- Enable the block layer 是否支持块层（必须支持）
- Processor type and feature 处理器类型和特性
  - Processor family(Core 2/newer Xeon)

- Power management and ACPI options 电源管理和高级电源选项
- Bus options(PCI etc.) 总线选项
- Executable file forms /Emulations 可执行文件格式
- Write ELF core dumps with partial segments
- Kernel support for scripts starting with #!
- Network options
- Device Drivers 驱动程序，网卡、
- Firmware Drivers 固件驱动
- File systems 文件系统
- Kernel hacking 内核调试
- Security options selinux
- Cryptographic API 加密解密库
- Virtualization 虚拟化技术
- Library routines

- Yes->保存到.config

``` shell
# screen
# make -j 2
# make modules_install
# make install
# reboot
设置默认grub
# vim /etc/default/grub
```

- 重新启动，选择新内核

### 编译过程

#### 1. 配置内核选项

- 支持更新模式进行配置：在已有的.config文件的基础之上进行修改配置
  - `make config`：基于**命令行**以遍历的方式去配置内核中可配置的每个选项；
  - `make menuconfig`：基于**ncureses**的文本配置窗口
  - `make gconfig`：基于**GTK开发环境**的窗口界面；包组"桌面平台开发"
  - `make xonfig`：基于**QT开发环境**的窗口界面
- 支持全新配置模式进行配置
  - `make deconfig`：基于内核为**目标平台**提供的默认配置为模版进行配置
  - `make allnoconfig`：所有选项均为no

#### 2. 编译

- 多线程编译：`make [-j #]`
- 编译内核中的一部分代码：
  - 只编译某子目录中的代码：
    - `# cd /usr/src/liux && make path/to/dir/`
  - 只编译一个特定的模块
    - `# cd /usr/src/linux && make path/to/dir/file.ko`
    - `# ls /lib/modules/$(uname -r)/kernel/` 编译好的文件复制移动到系统内核模块目录中
- 如何交叉编译
  - 目标平台与当前编译操作所在的平台不同：
    - `# make ARCH=arm_name`
  - 获取特定目标平台的 `# make ARCH=arm help`

#### 3. 如何在执行过编译操作的内核源码上做重新编译

- 实现清理操作

``` shell
清理编译生成的绝大多数文件，当会保留config，及编译外部模块所需要的文件
# make clean

清理编译生成的所有文件，包括配置生成的config文件及某些备份文件
# make mrproper

相当于mrproper，额外清理各种patches以及编辑器备份文件
# make disclean
```

### 常见编译出错

#### 报错：缺少bc

> /bin/sh: bc: command not found

make[1]: *** [kernel/timeconst.h] Error 127
make: *** [kernel] Error 2

解决方案：`# yum install -y bc`