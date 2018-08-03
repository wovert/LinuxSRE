# Linux 系统启动流程

## Linux系统的组成部分：内核+根文件系统

### 内核

- 进程管理
  - IPC Inter Process Communication
  - 消息队列、semerphor、shm
  - socket
- 内存管理
- 网络协议栈
- 文件系统
- 驱动程序
- 安全功能

## 运行中的系统环境：内核空间、用户空间

- 用户空间（用户模式）：应用程序（进程或线程）
- 内核空间（内核模式）：内核代码（系统调用）

## IPC：Inter Process Communication

- 本地进程间通信
  - 消息队列
  - semerphor
  - shm
- 跨主机进程间通信
  - socket

## 分区

- 启动分区：/boot
- rootfs：FHS

## 内核设计

- 单内核设计：所有功能集成于同一个程序
  - 代表产品：Linux
- 微内核设计：每种功能使用一个单独的子系统实现
  - 代表产品：Windows, Solaris

## Linux内核特点

- 支持模块化
  - `.ko`(kernel object)除了文件系统、驱动程序等主要模块之外都使用了内核对象（模块） 是动态转载卸载的内核模块(某一种功能实现)
  - `.so`(shared object，共享对象，各种应用程序之间共享的模块)
- 支持**模块运行时**动态装载或卸载

### Linux内核组成部分：

- 核心文件：`/boot/vmlinuz-VERSION.release`
- rimdisk：虚拟内存盘
- 模块文件 `/lib/modules/$(uname -r)/kernel/`

- 核心文件：文件系统、驱动程序、网络协议等文件
  - `/boot/vmlinuz-VERSION.release`
    - 核心文件放置文件：编译后的后文件
    - `/boot/vmlinuz-3.10.0-327.el7.x86_64`
    - `/boot/vmlinuz-$(uname -r)`
    - z:内核文件压缩后文件格式

- rimdisk：虚拟内存盘
  - 虚拟内存盘是通过软件将一部分内存（RAM）模拟为硬盘来使用的一种技术。相对于直接的硬盘文件访问来说，这种技术可以极大的提高在其上进行的文件访问的速度。但是RAM的易失性也意味着当关闭电源后这部分数据将会丢失。但是在一般情况下，传递到RAM盘上的数据都是在硬盘或别处永久贮存的文件的一个拷贝。经由适当的配置，可以实现当系统重启后重新建立虚拟盘。
  - CentOS 5: /boot/initrd-VERSION-release.img
    - rd:（ram disk）内存当磁盘使用，磁盘里必须有缓存和缓冲)
  - CentOS 6,7: /boot/initramfs-VERSION-release.img
    - ramfs：文件系统，避免双缓存缓冲，提高性能速度

- Linux 模块文件
  - `/lib/modules/$(uname -r)/kernel/`
    - arch    平台相关的特有代码（汇编级别）
    - fs      文件系统，ext2,ext3编译进内核中
    - drives  驱动程序
    - crypto  加密/解密组件模块
    - lib     库
    - mm      内存功能
    - net     网络功能
    - sound   声音相关驱动程序，解码器
    - kernel  内核追中到的文件模块

## Linux 内核版本

- mainline：正在研发主板版本
- stable: 稳定版，不增加功能，只要负责修复bug
- longterm: 长期维护版
- linux-next

- CentOS 6: 2.6.X
- CentOS 7: 3.10.X

> 内核启动之后，加载根文件系统,然后运行init进程，init进程用户所有进程，内核退回只在特权指令时运行

## CentOS 系统的启动流程

### 1. POST（Power On Self 加电自检，检查内存，磁盘，显示等硬件是否存在）

- ROM: CMOD（主板上的识别设备只读程序）
  - BIOS: Basic Input and Output System，基本输入输出系统
  - ROM + RAM: 只读内存+随机内存

### 2. Boot Sequence: 引导过程

> 按次序查找各引导设备，第一个有引导程序的设备即为本次启动要用到的设备

- bootloader：引导加载器，程序
  - Windows：ntloader
  - Linux:
    - LILO: LInux LOader(手机设备)
    - GRUB: Grand Uniform Bootloader,同一引导加载器
      - GRUB 0.x(Grub Legacy): CentOS 5,6
      - GRUB 1.x: (Grub2,完全重写) CentOS 7
  - 功能：提供一个菜单，允许用户选择要启动的系统或不同的内核版本；把用户的选定的内核装载到RAM中的特定空间中，解压、展开，而后把系统控制移交给内核；

- MBR：Master Boot Record, 512bytes
  - 446bytes: bootloader
  - 64bytes: fat filesystem all table
  - 2bytes: 55AA(有效MBR)

>注意：UEFI, GPT

- GRUB: 两个阶段
  - Bootloader: 1st stage
  - Partition: filesystem diver 1.5 stage
  - Partition: /boot/grub, 2nd stage

### 3. Kernel

- 自身初始化
  - 探测可识别到的所有硬件设备
  - 加载硬件驱动程序（有可能借助于ramdisk加载驱动）
  - 以只读方式挂载根文件系统
  - 运行用户空间的第一个应用程序：/sbin/init

- **init**程序类型：
  - CentOS 5>：**SysV init**
    - 配置文件：/etc/inittab
  - CentOS 6: **Upstart**(基于Ubuntu)
    - 配置文件：/etc/initab(废弃), /etc/init/*.conf

  - CentOS 7: **Systemd**
    - 配置文件：/usr/lib/systemd/system/, /etc/systemd/system/

- **ramdisk**
  - Linux内核的特性之一：使用缓冲和缓存来加速对磁盘上的文件访问
  - ramdisk --> 内存当磁盘使用
  - ramdisk --> ramfs 提速机制

  - CentOS 5: initrd
    - 工具程序：`mkinitrd`
  - CentOs 6,7: initramfs
    - 工具程序：`dracut,mkinitrd`

## 系统初始化流程（内核级别）

1. POST
2. BootSequence(BIOS)
3. Bootloader(MBR)
4. Kernel(ramdisk)
5. rootfs(read only，避免BUG)，自动挂载根文件系统
6. switchroot
7. 运行用户空间的/sbin/init程序
8. (/etc/inittab, /etc/init/*.conf)
9. 设定默认运行界别
10. 系统初始化脚本
11. 关闭或启动对应界别下的服务
12. 启动终端

> 注意：Bootleader不能加载软设备上
内核文件必须放在基本磁盘设备上（不能放在LVM等设备上）

- `/sbin/init`
  - CentOS 5: Sysv init

## 运行级别：为了系统的运行或维护的目的而设定的机制

- 0: 关机模式，shutdown
- 1: 单用户模式（single user),root用户，无需认证；维护模式
- 2：多用户模式（multi user），有认证机制，会启动网络功能，但不会启动NFS；维护模式
- 3：多用户模式（multi user），完全功能模式；文本界面
- 4：预留级别，目前无特别适用目的，当习惯一同3级别功能使用
- 5：多用户模式（multi user），完全功能模式；同行界面
- 6：重启模式,reboot

- 默认级别：
  - 3: 服务器
  - 5: 个人级别

### 界别切换命令

`# init [0-6]`

### 级别查看

``` SHELL
# who -r
# runlevel
```

- N 3:
  - N: 上一个级别 3：当前级别
  - N：表示没有上一个级别

## 配置文件：`/etc/inittab`

> 每行定义一种action以及与之对应的process(CentOS 5)

### id:runlevels:action:process

- **id**：一个任务的**标识符**
- **runlevels**：在哪些**级别**启动此任务;#,###，也可以为空，表示所有级别
- **action**: 在什么**条件**下启动此任务
- **process**: **任务**(应用程序或脚本)

### action

- **wait**: 等待切换至此任务所在的级别时执行一次
- **respawn**: 一旦此任务终止时，就自动重新启动之, Login -> login ->login(提示)
- **initdefault**: 设定默认运行级别；此时，process省略
- **sysinit**: 设定系统初始化方式，此处一般为指定/etc/rc.d/rc.sysinit脚本(CentOS 5,6)

### 例如

``` CONFIG
id:3:initdefault
si::sysinit:/etc/rc.d/rc.sysinit 系统初始化

l0:0:wait:/etc/rc.d/rc 0
l0:1:wait:/etc/rc.d/rc 1
l0:2:wait:/etc/rc.d/rc 2
l0:3:wait:/etc/rc.d/rc 3
l0:4:wait:/etc/rc.d/rc 4
l0:5:wait:/etc/rc.d/rc 5
l0:6:wait:/etc/rc.d/rc 6
```

> 启动或关闭/etc/rc.d/rc3.d/目录下的服务脚本所控制服务

- K*：要停止的服务
  - K##*：优先级，数字越小, 越优先关闭
  - 依赖的的服务先关闭，而后关闭被依赖的

- S*：要启动的服务
  - S##*：优先级，数字越小，越是优先启动
  - 被依赖的服务先启动，而依赖的服务后启动

- rc脚本：接受一个运行界别数字为参数

#### 脚本框架

``` SHELL
for srv in /etc/rc.d/rc#.d/K*;do
  $srv stop
done

for srv in /etc/rc.d/rc#.d/S*;do
$srv start
done

/etc/init.d/* (/etc/rc.d/init.d/*)
```

#### 脚本执行方式：

``` SHELL
# /etc/init.d/SRV_SCRIPT {start|stop|restart|status}
```

`/etc/init.d = /etc/rc.d/init.d`

``` SHELL
# /etc/initd./crond {start|stop|restart|status}
# service SRV_SCRIPT {start|stop|restart|status}
```

## chkconfig命令：

>创建K*,S*文件

管控/etc/init.d/每个服务脚本在各个级别下的启动或关闭状态

### 查看

``` SHELL
# chkconfig --list [SERVICE_NAME]
```

### 添加

``` SHELL
# chkconfig --add SERVICE_NAME`
```

> 能被添加的服务的脚本定义格式之一

``` SHELL
#!/bin/bash
# chkcofig: 2323 START_nice STOP_nice
# description: content
```

### 删除

``` SHELL
# chkconfig --del SERVICE_NAME
```

### 修改指定的链接类型：

``` SHELL
#chkconfig [--level LEVELS] name <on|off|reseat> 
```

> --level LEVELS：指定要控制的级别；默认为2345

### 启动级别

- 启动优先级：小于所有依赖于此服务的其他服务的优先级（因为他被依赖，先启动）
- 关闭优先级：大于所有依赖于此服务的其他服务的优先级（因为他被依赖，后关闭）

``` SHELL
# vim /etc/init.d/testsrv
  #!bin/bash
  # testsrv This starts and stops testsrv
  #
  # chkconfig: 2345 11 88  **-** 11 99 任何级别都没有
  # description: This sdfkjlasjdfljaf
  # `
  prog=$(basename $0)
  if [ $# -lt 1 ]; then
    echo "User:$prog {start|stop|status|restart}"
    exit 1
  fi

  if [ "$1" == "start" ]; then
    echo "Start $prog finished."
  elif [ "$1" == "stop" ]; then
    echo "Stop $prog finished."
  elif [ "$1" == "restart" ]; then
    echo "Restart $prog finished."
  elif [ "$1" == "status" ]; then
    if pidof $prog &> /dev/null; then
      echo "$prog is running"
    else
      echo "$prog is stopped."
    fi
  else
    echo "Usage: $prog {start|stop|status|restart}";
    exit 2
  fi

# chmod +x testsrv
# bash -n testsrv
# chkconfig --add testsrv 初始化testsrv服务
# chkconfig testsrv on
# ls /etc/rc.d/rc3.d/ | grep testsrv
# chkconfig --del testsrv
# chkconfig --level 0123456 testsrv off
# chkconfig --level 35 testsrv on
```

**注意**： 正常级别下，最后启动的一个服务S99local没有链接至/etc/init.d下的某脚本，而是链接至了/etc/rc.d/rc.local脚本；因此，不便或不需要为脚本的程序期望能开机自动运行时，直接放置于此脚本文件中即可。

``` SHELL
/etc/rc.d/rc3.d/S99local => /etc/rc.d/rc.local
/etc/rc.local => /etc/rc.d/rc.local

tty1:2345:respawn:/usr/sbin/mingetty tty1
tty6:2345:respawn:/usr/sbin/mingetty tty6
```

1. mingetty调用login程序
2. 打开虚拟终端的程序除了mingetty之外，还有诸如gettty等

``` SHELL
tty7:5:respawn:/etc/X11/
```

### CentOS 5 系统初始化脚本

`/etc/rc.d/rc.sysinit`

1. 设置主机名 `/bin/hostname, /etc/sysconfig/network`
2. 设置欢迎信息
3. 激活udev和selinux
4. 挂载`/etc/fstab`文件中定义的所有文件系统
5. 检测根文件系统，并以读写方式挂载根文件系统
6. 设置系统时钟
7. 根据`/etc/sysctl.conf`文件的设置**内核参数**
8. 激活vim及软raid设备
9. 激活swap设备
10. 加载额外设备的驱动程序
11. 清理操作

### 用户空间的启动流程：`/sbin/init(/etc/inittab)`

1. 设置默认运行级别
2. 运行系统初始化脚本，完成系统初始化
3. 关闭对应级别下要停止的服务，启动对应级别下需要开启的服务
4. 设置登录终端
5. 启动图形终端

###　CentOS 6

- init程序：`upstart`，但依然为`/sbin/init`，其配置文件：
  - `/etc/init/*.conf, /etc/inittab`(仅用于定义默认运行级别)	
  - 注意：`*.conf`为upstart风格的配置文件
    - `rcS.conf` 初始化脚本
    - `rc.conf`  服务开发关闭脚本
    - `start-ttys.conf` 启动终端服务脚本

### CentOS 7

- init程序：`systemd`
  - 配置文件:`/usr/lib/systemd/system/*, /etc/systemd/system/*`
  - 完全兼容Sysv脚本机制；service命令依然可以使用；建议使用systemctl命令来控制服务

`# systemctl {start|stop|restart|status} name[.service]`

`# systemctl get-default`

> multi-user.target

### 启动为什么快？

> 所有服务都没有启动。当第一次启动的时候启动服务

### 博客作业：UEFI,GPT;CentOS启动流程

## CentOS 6启动流程

1. POST
2. Boot Sequence(BIOS)
3. Boot Loder(MBR)
4. Kernel(ramdisk)
5. rootfs
6. switchroot
7. /sbin/init
8. (/etc/inittab, /etc/init/*.conf)
9. 设定默认运行界别
10. 系统初始化脚本
11. 关闭或启动对应界别下的服务
12. 启动终端

##　GRUB(Boot Loader):

- Grub 0.x: grub legacy
- Grub 1.x: grub2

## Grub legacy

- Stage1: mbr
- Stage1_5: mbr之间的扇区，让stage1中的boot loader能识别stage2所在的分区上的文件系统
- Stage2: 磁盘分区（/boot/grub/）

- 配置文件：/boot/grub/grub.conf <-- /etc/grub.conf

- Stage2及内核等通常放置于一个基本磁盘分区：
  + 功用：
    1. 提供菜单，并提供交互式接口
      + e: 编辑模式，用于编辑菜单
      + c: 命令模式，交互式接口
    2. 加载用户选择的内核或操作系统
      + 允许传递参数给内核
      + 可隐藏此菜单
    3. 为菜单提供了保护机制
      + 为编辑菜单进行认证
      + 为启动内核或操作系统进行认证

## grub如何识别设备？
- hd#，#（hd：hardware，#:第几块磁盘，第几个分区）
  + hd#：磁盘编号，用数字表示；从0开始编号
  + #：分区编号，用数字表示；从0开始编号
  + (hd0,0)

## grub的命令行接口：
`help`：获取帮助列表
`help root`：设置grub的根设备
`help KEYWORD`：详细帮助信息
`find (hd#,#)/PATH/TO/SOMEFILE`
`find (hd0,0)/wmlinuz-`tab键
`root (hd#,#)` 设定哪个设备的哪个分区作为根文件系统
`root (hd0,0)`
`find /vmlinuz-2.6.32-504.e.....`
`kernel /PATH/TOKERNEL_FILE`：本次启动时用到内核文件(z代表压缩文件)；额外还可以添加许多内核支持使用的cmdline参数：`init=/path/to/init, selinux=0`
`initrd /PATH/TO/INITRAMFS_FILE`：设定为选定的内核提供额外文件的ramdisk
`boot`：引导启动选定的内核

## 手动在grub命令行接口启动系统：
grub> `root(hd0,0)`
grub> `kernel /vmlinuz-VERSION-RELEASE ro root=/dev/mapper/vg0-root quite`
grub> `initrd /initramfs-VERSION-RELEASE.gim`
grub> `boot` 

## grub2命令行接口
`help`        显示所有可用命令
`ls`          列出当前的所有设备
`ls -l`       列出当前的所有设备，对于分区显示其label及uuid
`ls (hd1,1)`  列出(hd1,1)分区下文件
`search -f /ntldr`  列出根目录里包含ntldr文件的分区，返回为分区号
`search -l Linux`   搜索label是linux的分区
`search --set -f /ntldr`  搜索根目录包含ntldr文件的分区并设为root，注意如果多外分区含有ntldr文件,set失去作用
`set root=`   设置变量的值
`set timeout=`设置变量的值
调用变量的值时，使用${AA}，如set root=(hd1,1)，则${root}=(hd1,1)
linux取代grub中的kernel
boot 

## 配置文件：/boot/grub/grub.conf
- default=0	设定默认启动的菜单项;菜单项(title)编号从0开始
- timeout=5	指定菜单项等待选项选择的时长
- splashimage=(hd0,0)/grub/xpm.gz	菜单背景图片文件路径(14位图像600x800)
- hiddenmenu	隐藏菜单
- password [--md5] STRING：菜单编辑认证
  + Password --md5 $1$TOrM8/$zY5p2Lr4CbXBqXyfguLaG.

- title TITLE	定义菜单项的标题，可出现多次
  + root (hd#,#)：grub查找stage2及kernel文件所在设备分区；为grub的根
  + kernel /PATH/TO/vmlinuz_FILE [PARAMETERS] 启动的内核
  + initrd /PATH/TO/INITRAMFS_FILE	内核匹配的ramfs文件
  + password [--md5] STRING：启动选定的内核或操作系统时进行认证
    + `grub-md5-crypt命令`：生成grub密码
    + openssl生成密码串


## 如何进入单用户模式？
1. 编辑grub菜单(选定要编辑的title,而后使用**e命令**）
2. 在选定的kernel后附加
  + 1,s,S或single都可以
3. 在kernel所在上，键入**"b"命令**


## 安装grub方法（2种）：
1. `# grub-install --root-directory=ROOT /dev/DISK`

2. `grub` 修复
  + grub> `root (hd#,#)`   stage1,stage1.5必须存在
  + grub> `setup (hd#)`

## 创建系统
> 添加一个硬盘sdb
创建分区：boot(100Mb), root(5G)，swap(1G)
创建文件系统:ext4,ext4
挂载文件：
`# mkdir /mnt/boot`
`# mount /dev/sdb1 /mnt/boot/`
`# ls /mnt/boot`
`# grub-install --root-directory=/mnt /dev/sdb`
`# ls -l /mnt/boot/grub/`

### 没有grub配置文件，需要自己配置
`# vim /mnt/boot/grub/grub.conf`
default=0
timeout=5
titie Centos(Expres)
  root (hd0,0)
  kernel /vmlinuz ro root=/dev/sda3 selinux=0 init=/bin/bash
  initrd /initramfs.img

### 没有kernel文件，需要复制
`# cp /boot/vmlinuz-ss /mnt/boot/vmlinuz`

### 没有initramfs文件，需要复制
`# cp /boot/initramfs-.. /mnt/boot/initramfs.img`


### 创建系统目录
`# mkdir /mnt/sysroot`
`# mount /dev/sdb3 /mnt/sysroot/`
`# cd /mnt/sysroot/`
`# mkdir -pv etc bin sbin lib lib64 dev proc sys tmp var usr home root mnt media `
`# cp /bin/bash /mnt/sysroot/bin/` 
`# ldd /bin/bash` 查看bash依赖哪些库文件
`# cp /li64/libtiinfo.so.5 /mnt/sysroot/lib64/`
......
`# chroot /mnt/sysroot/` 切换根文件系统
`# sync` 同步

### 创建虚拟机刚才创建生成的新的系统磁盘
...

## grub菜单文件丢失怎么办？
> grub文件丢失，说明bootloader丢失
修复MBR,硬盘接到其他机器上，修复MBR的bootloader程序

`# dd if=/dev/sda of=/root/mbr.bak count=1 bs=512`
`# dd if=/dev/zero of=/dev/sda bs=200 count=1`
`# sync` 同步到磁盘上

`# grub-install --root-directory=/ /dev/sda`	boot所在的根目录
`# sync`

`# dd if=/dev/zero of=/dev/sda bs=200 cont=1`
`# grub`
`grub> root (hd0,0)`
`grub> setup (hd0)`  hd0硬盘
`grub> exit`
`# sync`
`# reboot`


## 紧急求援模式：
`# dd if=/dev/zero of=/dev/sda bs=200 cont=1`
`# sync`
`# reboot`

1. 载入光盘设备：
  + 选择 Rescure installed system
  + 输入 boot: linux rescure

`# chroot /mnt/sysimage/`
`# grub-install --root-directory=/ /dev/sda`
`# reboot`

## 练习
1. 新加硬盘，提供直接单独运行bash系统
2. 破坏本机grub stage1, 而后在救援模式下修复之
3. 为grub设备保护功能

## ldd命令
> 程序命令所依赖的库文件

`# ldd /PATH/TO/COMMAND`

- 库文件名 => 库文件路径
- linux-vdso.so.1 => (0x00008fffea5a3000) 系统调用库入口
- /lib64/ld-linux-x86-64.so.2 各应用程序调用其他库文件入口

# ldd /bin/ls | grep -o "/lib[^[:space:]*"