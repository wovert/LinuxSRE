# Linux 内核模块

> Linux是单内核设计，但借鉴了微内核设计的优点；为内核引入了模块化机制

[Linux kernel map](https://makelinux.github.io/kernel/map/)

## 内核的组成部分

- kernel：内核核心一般为bzimage，通常位于`/boot/vmlinuz-VERSION-release`
- kernel object: 内核对象，即内核模块，一般放置于`/lib/modules/VERSION-release/`

**注意**：内核模块与内核核心版本一定要严格匹配

## 编译时模块选择

- [ ]: N，不编译进内核
- [M]: Module，动态加载
- [X]: Y, 编译进内核

- 内核：动态装载或卸载

## ramdisk

>辅助性文件，并非必须，这取决于内核是否能直接驱动rootfs所在的设备

- 目标设备驱动，例如SCSI设备的驱动
- 逻辑设备驱动，例如LVM设备的驱动
- 文件系统，例如xfs文件系统

- ramdisk是简装版的根文件系统（内存中的根文件系统）
- 数据不能永久保存，所以需要根文件系统切换chroot /

**内核文件**: /boot/vmlinuz-VERSION-release

## 内核信息查看名利个`uname`选项

``` SHELL
-a: 所有信息
-r: 内核的发布版本
-n: hostname 等同于hostname命令
-s: kernel-name
-v: kernel-version，编译版本号
-m: machine
-p: processor
```

## 模块信息获取

### 列出内核已加载的模块

`# lsmod`

Module|Size|Used(引用次数)|by(被什么模块所引用)

> 显示的内核来自于`# cat /proc/modules`

### `modinfo` 单个模块信息命令(不管是否安装)

> 显示当前release内核信息
> 读取/lib/modules/$(uname -r)/*元数据获取显示
> 修改modules.alias源码，生成modules.alias.bin二进制文件

``` shell
# modinfo ext4
# modinfo btrfs
# lsmod | grep btrfs

-k kernel 显示指定内核的模块信息(多个内核版本时)
-F field ：仅显示指定的字段信息；{filename|depends}
-a, --author
-d, --description
-l, --license
-p, --parameters
-n, --filename
```

``` shell
# ls /lib/modules/3.10.xxx.x86_64/
module.alias 原文件(修改代码文件)
module.alias.bin 二进制编码(原文件编译成二进制文件)
```

``` SHELL
# modinfo -F filename btrfs
  /lib/modules/3.10.0-229.el7.x86_64/kernel/fs/btrfs/btrfs.ko
# modinfo -F depends btrfs
  raid6_qp.xor,zlib_deflate
```

## 模块管理

> modprobe命令:模块的动态装载或卸载

### modprobe 动态装载模块

`# modprobe module_name`

### modprobe 卸载模块

`# modprobe -r module_name`

**注意：正在使用的模块不能卸载**

### depmod命令：生成依赖关系

> 内核模块依赖关系文件的生成工具

### 模块的装载和卸载：insmod命令

`# insmod [filename] [module options...]`

- filename:模块文件的文件路径
- 有依赖关系是不能装载

``` SHELL
# lsmod btrfs
# lsmod | grep libcrc32c
# insmod $(modinfo -n libcrc32c)
# insmod $(modinfo -n zlib_deflate)
# insmod $(modinfo -n lzo_compress)
# insmod $(modinfo -n lzo_decompress)
# lsmod | grep libcrc32c
# insmod $(modinfo -n btrfs)
# lsmod | grep btrfs
```

### rmmod命令：移除模块

`# rmmod [module_name,模块名称]`

## ramdisk文件的管理

### mkinitrd命令(CentOS 5,6,7)

> 为当前使用的内核重新制作initramfs文件
> mkinitrd [OPTIONS...] [<initrd-image>] <kernel-release>

``` SHELL
--with=<module> 除了默认的模块之外装载至initramfs中的模块
--preload=<module> initramfs所提供的模块需要预先装载的模块
```

创建initrd文件

``` shell
5/6/7 CentOS
# mv /boot/initramfs-$(uname -r).img /tmp/
# mkinitrd /boot/initramfs-$(uname -r).img $(uname -r)
```

### dracut命令(CentOS 6,7)

`dracut [OPTION]... <image>  <kernel-version>`

``` shell
# dracut /boot/inintramfs-$(uname -r).img $(uname -r)
```

## 内核信息输出的伪文件系统

- /proc：**内核状态和统计信息**的输出接口；同时，还提供了配置接口，/proc/sys;
  - 参数：
    - 只读：信息输出；例如`/proc/#/*`(某进程的相关信息)
    - 可写：可接受用户指定一个"新值"来实现对内核某功能或特性的配置：`/proc/sys`（仅管理员有权限）

- /proc/sys
  - `net/ipv4/ip_forward` 相当于 `net.ipv4.ip_forward`

### 修改方式

1. sysctl命令：专用于查看或设定/proc/sys目录下的参数的值

查看

``` SHELL
# sysctl -a
# sysctl variable
# cat /proc/sys/PATH/TO/SOME_KERNEL_FILE
```

设置/修改其值

``` SHELL
# sysctl -w variable=value
# sysctl -a 可配置的所有选项
# sysctl net.ipv4.ip_forward
# sysctl -w net.ipv4.ip_forward=1

# sysctl -w kernel.hostname=www.ligyima.com
# uname -n
# cat /proc/sys/kernel/hostname
```

2. 文件系统命令（cat,echo)

查看: `# cat /proc/sys/PATH/TO/TO/SOME_KERNEL_FILE`

修改：`# echo "VALUE" > /proc/sys/PATH/TO/SOME_KERNEL_FILE`

**注意：上述两种方式设定仅当前运行内核有效；重启之后无效**

3. 修改配置文件

``` SHELL
/etc/sysct.conf
/etc/sysct.d/*.conf
```

- 参数重启系统之后有效
- 重读配置文件，当前运行内核有效

- 永久生效：

``` SHELL
# vim /etc/sysctl.conf
  net.ipv4.ip_forward=1

# cat /proc/sys/net/ipv4/ip_forward`
```

立即生效(-p 读取配置文件)

``` SHELL
默认读取/etc/sysctl.conf
# sysctl -p [/PATH/TO/CONFIG_FILE]

```

## 内核参数

### net.ipv4.ip_forward：核心转发功能

> 从一个网络主机的报文经过主机转发到另一个网络的主机

主机转发功能

### vm.drop_caches: 0 1 2

``` SHELL
# free -m
# echo 1 > /proc/sys/vm/drop_caches   buffer
0：表示不丢，1：丢掉
# echo 2 > /proc/sys/vm/drop_caches    cahe
```

- vm.drop_caches 0 | 1 | 2
- 回收buffer/cache
- 即使清空了，内核为了加快速度运行也会在buffer/cache 有些不能清空

### kernel.hostname 主机名配置

### net.ipv4.icmp_echo_ignore_all:忽略所有ping操作（禁别人ping本机）

> 0：能ping通
> 1: 不能ping

## /sys目录

### sysfs：输出内核识别出的各**硬件设备的相关属性信息**，也有内核对硬件特性的可设置参数，以此写参数的修改，即可定制硬件设备工作特性

- /sys目录**2.6版本**引入的

- Linux社区研发峰会的文档

### udev 通过读取/sys目录下的硬件设备信息按需为各硬件设备创建设备文件；

- udevl是用户空间程序；专用工具; `devadmin,hotplug`

- udev为设备创建设备文件时，会读取其实现定义好的规则文件，
  - `/etc/udev/rules.d/目录下` CentOS 6-
  - `/usr/lib/udev/rules.d/目录下` CentOS 7

### 网卡文件对换

- 网卡名词对换：`# vim /etc/udev/rules.d/70-persistent-net.rules`
- 网卡文件对换: `# /etc/sysconfig/network-scripts/ifcfg-eth0 ifcfg-eth1`
- 卸载网卡模块: `# modprobe -r e1000`
- 重装网卡模块：`# modprobe e1000`

---

## Linux启动流程

1. POST
2. Boot Sequence(BIOS)
3. Boot Loader(MBR)
4. Kernel(ramdisk)
5. rootfs(switch_root)
6. /sbin/init(/etc/inittab,/etc/init/*.conf,/usr/lib/systemd/system)
7. 默认运行级别、系统初始化、关闭和启动服务、启动终端（图形终端）

## grub

- 1st stage: MBR
- 1_5 stage: MBR之后的扇区
- 2nd stage: /boot/grub/

- 加密：编辑、内核