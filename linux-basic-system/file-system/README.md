# Linux文件系统

- 文件是什么？

存储空间存储的一段流式数据，对数据可以做到按名存取	

## 程序编译方式：Linux: glibc(GNU libc)标准库

- 静态链接编译：运行程序复制一份系统库文件到程序当中并运行
- 动态链接编译：运行程序需要使用的系统库文件单独载入到内存中供多个程序同时使用

## 进程的类型

- 终端：硬件设备，关联一个用户接口
- 与终端相关：通过终端启动，交互式启动
- 与终端无关：操作引导启动过程当中自动启动

## 操作系统的组成

- 文件系统：层次结构（倒置树状结构）；有索引
- 在启动的时候需要使用文件，需要载入内存，有一个分区作为起始分区，这个分区被称为根分区。根是由内核直接访问的。

- 文件系统通过系统调用接口实现用户空间中用户操作

## 操作系统自身运行使用的

```
/bin
/sbin
```

## 运行正常功能的程序存放位置

```
/usr/bin
/usr/sbin
```

## 用来存放第三方软件的程序

```
/usr/local/bin
/usr/local/sbin
```

## Linux目结结构按类别组织的

- 应用程序：`/usr/bin`
- 数据文件：`/usr/share`
- 配置文件：`/etc`
- 启动服务：`/etc/init.d`

## [FHS, Filesytem Hierarchy Standard](http://www.pathname.com/fhs/)

- `/bin` 所有用户可用的命令基本命令程序文件
- `/sbin` 仅系统管理员使用的工具程序
- `/boot` 引导加载器必须用到的各静态文件 kernel,initramfs(initrd), grub等
- `/dev` 存储特殊文件或设备文件
- 设备类型：
  - 字符设备(线性设备), character device
    - 键盘，显示器
  - 块设备(随机设备), block device
    - 硬盘

- `/dev/tty[0-63]` 虚拟终端
- `/dev/ttyS[0-3]` 串口，串行终端
- `/dev/console` 物理终端，控制台
- `/dev/md[0-3]` 软raid设备
- `/dev/loop[0-7]` 本地回环设备
- `/dev/ram[0-15]` 内存
- `/dev/lp[0-3]` 并口
- `/dev/null` 无限数据接收设备，所有数据写入这个设备被丢弃
  - `~]# cat /dev/null > file` (清空文件内容)
- `/dev/zero` 无限0资源
- `/dev/hd[a-t]` IDE设备
- `/dev/sd[a-z]` SCSI设备
- `/dev/fd[0-7]` 标准软驱
- `/dev/cdrom => /dev/hdc`

- `/dev/fd[0-31]` framebuffer
- `/dev/modem` => /dev/ttyS[0-9]
- `/dev/pilot` => /dev/ttyS[0-9]，引导
- `/dev/random` 随机数设备
- `/dev/uradom` 随机数设备

- `/etc` 系统程序的配置文件，只能为静态文件
- `/etc/redhat-release`Linux发行版版本号
- `/etc/issue` 记录用户登陆前显示的信息
- `/etc/ld.so.conf` 额外的目录列表搜索共享库
- `/etc/fstab` 开机自动挂载磁盘文件
- `/etc/hosts` 主机名配置文件，设定IP与域名的对应解析表，相当于本地LAN的DNS
- `/etc/resolv.conf` 本地客户端DNS文件，实现域名和IP的互相解析
- `/etc/rc.local` 开机自动运行程序命令的文件
- `/etc/inittab` 初始化系统配置文件
- `/etc/networks` 静态信息网络名称文件
- `/etc/passwd` 用户信息文件
- `/etc/profile` 系统全局环境变量配置目录
- `/etc/profiel.d/` 系统全局环境变量目录
- `/etc/group` 用户组名相关信息
- `/etc/shadow` 密码信息文件
- `/etc/modprobe.conf`内核模块额外参数设定
- `/etc/protocols` 系统支持的协议文件
- `/etc/exports` NFS文件系统访问控制列表
- `/etc/motd` 系统登录显示消息文件
- `/etc/services` 网络服务端口名称
- `/etc/syslog.conf` syslogd配置文件
- `/etc/init.d/` 服务启动命令目录
- `/etc/xinit.d` 服务器通过xinetd模式运行目录
- `/etc/sysconfig` 系统级别的应用
- `/etc/sysconfig/network-scripts/ifcfg-eth0` 网卡配置文件
  - DEVICE eth0 设备名(0:第一个设备)
  - HWADDR=00:0C:29:BA:8C:8F 网卡 MAC地址
  - TYPE Ethernet 以太网
  - UUID=xxxxx
  - ONBOOT=yes 开机自动启动
  - BOOTPROTO={none|dhcp|static}
  - IPADDR=10.0.0.7
  - NETMAST=255.255.255.0 子网掩码（区分网络位和主机位）
  - DNS1=8.8.8.8
  - DNS2=202.106.0.20 域名解析服务器
  - GATEWAY=10.0.0.254 网关地址，路由器的地址
  - USERCTL=no

  - 修改IP为静态
    - `# cp ifcfg-etho{,.ori}`
    - `# vim ifcfg-eth0`
    - `# /etc/init.d/network restart` 影响所有网卡
    - `# netstat -an | grep 192`
    - `ifdown eth0 && ifup eht0`
  - `# route -n` 查看路由


- `# ifdown eth0 && ifup eth0`
- `/etc/sysct.conf` 内核参数里配置永久生效
- `/etc/sudoers` 执行使用sudo命令的配置文件
- `/etc/securetty` 设定哪些终端可以让root登录
- `/etc/rsyslog.conf` 日志设置文件
- `/etc/login.defs` 所有用户登录时的缺省配制
- `/etc/DIR_COLORS` 设定颜色
- `/etc/host.conf` 用户的系统如何查询节点名
- `/etc/hosts.allow` 设置允许使用inetd的机器使用
- `/etc/hosts.deny` 设置不允许使用inetd的机器使用
- `/etc/X11` X Window的配置文件
- `/etc/opt` /opt配置文件目录
- `/etc/x11` x Windows system(opitonal)
- `/etc/sgml` 配置SGML(opitonal)
- `/etc/xml` 配置XML(opitonal)

- `/home` 普通用户的家目录的集中位置；每个普通用户的家目录默认为此目录下与用户名同名的子目录，`/home/UERNAME`
- `/root`系统管理员家目录
- `/lib` 32bits库文件目录，为系统启动或根文件系统上的应用程序(`/bin,/sbin`等) 提供共享库，以及为内核提供内核模块
- `/lib/libc.so.*` 动态链接的C库
- `/lib/ld*` 运行时链接器/加载器
- `/lib/Modules/` 可装载内核模块的目录

- `/lib64` 64bit系统特有的存放64位共享库的路径
- `/lost-found` 丢失数据目录
- `/mnt` 其他文件系统的临时挂载点；
- `/media` 移动媒体挂载点
- `/opt` 附加应用程序的安装位置；用于有些软件包数据安装目录
- `/srv` 当前主机为服务提供的数据， swift服务
- `/tmp` 为那些会产生临时文件的程序提供的用于存储临时文件的目录；
  - 可供所用户执行写入操作；
  - 有特殊权限；

- `/usr` Universal Shareable, read-only data 全局共享的只读数据目录；
- `/usr/bin` 用户可执行文件目录
- `/usr/sbin` 管理员可执行文件目录
- `/usr/include` 程序的头文件存放目录
- `/usr/lib` 32bits库文件存放目录
- `/usr/lib64` 64bits库文件存放目录
- `/usr/share` 与体系结构无关的数据，架构特有的文件的存储位置
- `/usr/share/fonts` 字体目录
- `/usr/share/man` 命令手册帮助目录
- `/usr/share/doc` 程序自带文档
- `/usr/src` 源码目录
- `/usr/X11R6` X-Window程序的安装位置
- `/usr/local` 系统管理员安装本地应用程序，通常是第三方应用程序安装目录
- `/usr/local/bin`	应用程序目录
- `/usr/local/sbin`	管理员程序目录
- `/usr/local/lib`		32bits库目录
- `/usr/local/lib64`		64bits库目录
- `/usr/local/include`	头文件

- `/var` 经常变化的目录
- `/var/cache/` 应用缓存数据目录
- `/var/tmp` 临时文件保留与系统重启目录
- `/var/lib/` 变量状态信息
- `/var/local/` /usr/local变量数据目录
- `/var/lock/` 锁文件目录
- `/var/log/` 日志文件目录
- `/var/log/messages` 系统日志文件，按周自动轮询
- `/var/log/lastlog` 记录每个用户登录系统信息
  - 只能使用 `lastlog` 命令，不能打开文件
- `lastb` 记录所有用户登录时间
- `/var/log/secure` 系统安全信息日记(端口,pop3,ssh,telnet,ftp
- `/var/log/wtmp` 记录所有登录和注销信息
- `# last -f /var/log/wtmp`
- `/var/opt` 变量数据/opt
- `/var/run` 运行进程相关数据，运行时变量数据
- `/var/spool` 应用轴数据目录
- `/var/spool/mail` 邮件目录
- `/var/spool/cron` 定时任务的配置文件目录
- `/var/spool/postfix` postfix邮件目录
- `/var/spoo/clientmqueue` sendmail 临时邮件文件目录，很多原因导致目录碎片文件很多，比如crontab定时任务命令不加`>/dev/null`

- `/proc` 内核及进程信息虚拟文件系统，基于内存的虚拟文件系统，用于为内核及进程存储其相关信息；多为内核参数；例如：`net.ipv4.ip_forward`, 虚拟为 `net/ipv4/ip_forward`，存储于`/proc/sys/`，因此其完整路径为`/proc/sys/net/ipv4/ip_forward` 参考：https://www.ibm.com/developerworks/cn/linux/l-cn-sysfs/

- `/proc/filesystems` 目前系统已经加载的文件系统
- `/proc/uptime`
- `/proc/mounts` 系统已经挂载的数据
- `/proc/modules` Linux已经加载的模块列表
- `/proc/loadavg` 负载信息
- `/proc/meminfo` 内存信息
- `/proc/cpuinfo` CPU信息
- `/proc/version` 内核版本

- `/proc/sys/kernel` 系统内核功能
- `/proc/sys/net/ipv4/` 修改ipv4配置
- `/proc/sys/net/ipv4/tcp_max_tw_buckets` 36000
- `/proc/sys/net/ipv4/tcp_tw_reuse 1`

- `/proc/cmdline` 加载kernel时所下达的相关参数
- `/proc/kcore` 内存的大小
- `/proc/ioports` 目前系统上各个装置所配置的IO位址
- `/proc/interrupts`IRQ分配状态，正在使用的中断，和曾经有多少个中断

- `/sys` sysfs 虚拟文件系统提供了比 proc 更为理想的访问**内核数据**的途径；其主要作用在于为管理Linux设备提供统一模型的接口；

- 《奇点临近》

## Linux文件类型

- -或f：常规文件；regular file；
- d: directory，目录文件；
- b: block device，块设备文件，支持以“block”为单位进行随机访问
- c：character device，字符设备文件，支持以“character”为单位进行线性访问
  - major number：主设备号，用于标识设备类型，进而确定要加载的驱动程序
  - minor number：次设备号，用于标识同一类型中的不同的设备
  - 8位二进制：0-255
- l：symbolic link，符号链接文件；
- p: pipe，命名管道；
- s: socket，套接字文件；

## 文件查找

> 在文件系统上查找符合条件的文件

### locate

- 依赖于事先构建好的索引库
- 系统自动实现（周期性任务）

- 工作特性：
  - 查找速度快；
  - 模糊查找；
  - 非实时查找；

- `locate [OPTIONS] ... PATTERN...`	
  - -b：只匹配路径中的基名
  - -c：仅显示匹配的数量
  - -r, --regexp：BRE

- 手动更新数据库 `~]# updatedb`

- 注意：索引构建过程中需要遍历整个跟文件系统，极消耗资源；

### `find` 命令

> 实时查找工具，通过遍历指定起始路径下的文件系统层级结构完成文件查找

- 工作特性：
  - 查找速度略慢；
  - 精确查找；
  - 实时查找；

`find [OPTIONS] [查找起始路径] [查找条件] [处理动作]`

- 查找起始路径：
  - 指定具体搜索目标起始路径；
  - 默认为当前目录；

- 查找条件：
  - 可以根据文件名、大小、类型、从属关系、权限等等标准进行；
  - 默认为找出指定路径下的所有文件；

- 处理动作：
  - 对符合查找条件的文件做出的操作，例如删除等操作；
  - 默认为输出至标准输出；

- 查找条件：
  - 表达式：选项和测试

- 选项：
  - `-maxdepth levels`
  - `-mindepth levels`

### 测试：结果通常为布尔型（"true"， "false"）

### 根据文件名查找

- `-name "pattern"`
- `-iname "pattern"`
- 支持glob风格通配符 `*,?[],[^]`
- `-regex "pattern"` 基于正则表达式查找文件，匹配是整个路径

### 根据文件从属关系查找

- `-user` USERNAME 查找属主指定用户的所有文件
- `-group` GROUPNAME 查找属组指定用户的所有文件
- `-uid UID` 查找属主指定的UID的所有文件
- `-gid GID` 查找属组指定的UID的所有文件
- `-nouser` 查找没有属主的所有文件
- `-nogroup` 查找没有属组的所有文件

### 根据文件的类型查找：

`-type {f|d|l|b|c|s|p}`

### 根据文件的节点查找：

`-inum NUMBER`

### 组合测试

- 与：`-a`, 默认组合逻辑
- 或：`-o`
- 非：`-not, ！`

- 或条件表达式时，必须加上括号`\(....\)`

``` 示例
~]# find /tmp \( -nouser -o -uid 1003 \) -ls
~]# find /tmp -not \( -user root -o -iname "*fstab*" \) -ls
```

``` 示例
!A -a !B = !(A -o B) -o并(或)
!A -o !B = !(A -a B) -a交(且)
```

```
~]# find /tmp ! -user root -a ! -name "*fsta*" -a -type f -ls
~]# find /tmp ! \( -user root -o -name "*fsta*" \) -a -type f -ls
```

### 根据文件的大小查找

`-size[+|-]#UNIT`

- 常用单位：c,k,M,G
  - `#UNIT：-1 < ? <= #`
  - `-#UNIT: 0 < ? <= #-1`
  - `+#UNIT: # < ?`

`~]#find /tmp -size 115k`

### 根据时间戳查找

- 以”天“为单位：
  - `-atime [+|-]#`

  - `#：[#, #-1]`, 大于#-1天至#天
  - `-#：[#, 0]`, #天内
  - `+#：[oo, #-1]`, #-1天之前所有
  - `-mtime`
  - `-ctime`

- 以“分钟”为单位：
  - `-amin`
  - `-mmin`
  - `-cmin`

#### 根据权限查找

`-perm mode` 精确查找

`-perm /mode` 任何一类用户(u, g, o)的权限中的任意一位(r,w,x)符合条件即满足；9位权限之间存在"或"关系(包含权限)

/002 其他用于有写权限的文件

/222 ugo权限当中至少有写权限满足（至少有一个有=任何一位有）

`-perm -mode` 每一类用户(u,g,o)的权限中的每一位(r,w,x)同时符合条件即满足；9位权限之间存在"与"关系(包含权限)

-222 ugo权限当中所有类必须都有写权限满足

-not -222 ugo权限当中至少有一类没有

`-perm +mode`

精确查找：`find ./ -perm 644 -ls`

### 处理动作

- `-print` 输出至标准输出，默认的动作；
- `-ls` 输出文件的详细信息，类似于"ls -l"命令
- `-delete：删除查找到的文件
- `-fls /PATH/TO/SOMEFILE` 长格式保存在指定文件
- `-ok COMMAND {} \;` 
  - 对查找到的每个文件执行由COMMAND表示的命令
  - 每次操作显示提示确认执行命令
- `-exec COMMAND {}` \；对查找到的每个文件执行由COMMAND表示的命令
- `{}` 查找到的文件的占位符

`~]# find ./ -perm /002 -exec mv {} {}.danger \;`

注意：find传递查找到的文件路径至后面的命令时，实现查找出所有符合条件的文件格式，并一次性传递给后面的命令；

但是有些命令不能接受过长的参数，此时命令执行会失败，另一种方式可规避此问题；

`~]# find | xargs COMMAND`

1. 查找 `/var` 目录下属主为 `root`，且属组为 `mail` 的所有文件或目录；
`~]# find /var -user root -a -group mail -ls`

2. 查找 `/usr` 目录下不属于 `root`, `bin` 或 `hadoop` 的所有文件或目录；用两种方法；
`~]# find /usr -not -user root -a -not -user bin -a -not -user hadoop`

`~]# find /usr -not \( -user root -o -user bin -o -user hadoop \) -ls`

3. 查找 `/etc` 目录下最近一周内其内容修改过，且属主不是 `root` 用户也不是 `hadoop` 用户的文件或目录；

```
~]# find /etc -mtime -7 -a -not \( -user root -o -user hadoop \) -ls
~]# find /etc -mtime -7 -a -not -user root -a -not -user hadoop -ls
```

4. 查找当前系统上没有属或属组，且最近一周内曾被访问过的文件或目录；

```
~]# find  /  \( -nouser -o -nogroup \)  -atime  -7  -ls
```

5. 查找 `/etc` 目录下大于 `1M` 且类型为普通文件的所有文件；

```
~]# find /etc -size +1M -type f -exec ls -lh {} \;
```

6. 查找 `/etc` 目录下所有用户都没有写权限的文件；

```
~]# find /etc -not -perm /222 -type f -ls
```

7. 查找 `/etc` 目录至少有一类用户没有执行权限的文件；
```
~]# find /etc -not -perm -111 -type f -ls
```

8. 查找 `/etc/init.d/`目录下，所有用户都有执行权限，且其它用户有写权限的所有文件；
`~]# find /etc -perm -113 -type f -ls`