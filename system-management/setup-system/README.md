# 安装系统

## 安装程序: anaconda

1. bootloader（光盘) -> isolinux/vmlinuz(isolinux/initrd) -> anaconda
2. kernel(initrd(rootfs)，不做根切换)
3. 启动anaconda程序（用户空间第一个程序）

## anaconda

- tui: 基于curses(多视窗处理方式)的文本配置窗口
- gui: 图形界面

## CentOS安装过程启动流程：

1. MBR：`isolinux/boot.cat`（光盘的**引导加载器**）
2. Stage2: `isolinux/isolinux.bin` (操作系统**安装菜单**)

``` config
配置文件：`isolinux/isolinux.cfg`

每个对应的菜单选型
  加载内核：`isolinux/vmlinuz`
  向内核传递参数：`append initrd=initrd.img`

  label linux
    menu label ^Install CentOS 7
    menu default
    kernel vmlinuz
    append initrd=initrd.img inst.stage2=hd:LABEL=CentOS\x207\x20x86_64 quiet

装载根文件系统，并启动anaconda
  默认界面是图形界面（至少512MB+ 内存空间）
  若显示启动tui接口: 向启动内核传递一个参数**text**即可
    ESC键之后输入 `boot: linux text`

注意：上述内容一般位于引导设备，例如可通过光盘、U盘或网络等；后续的anacona机器安装用到的程序包等可以来自于**程序包仓库**，此仓库的位置为：
  本地光盘
  本地硬盘
  ftp server
  http server
  nfs server

  手动指定安装仓库：
    ESC键之后输入 boot: linux method
```

## anaconda的工作过程

- 安装前配置阶段
- 安装阶段
- 首次启动

1. 安装配置阶段

``` config
安装过程中使用的语言
键盘类型
安装目标存储设备
  Basic Storage：本地磁盘
  Special Storage：iSCSI (网络磁盘)
设定主机名
配置网口接口
时区
管理员密码
设定分区方式以及MBR的安装位置
创建普通用户
设定安装的程序包
```

2. 安装阶段

``` config
在目标磁盘创建分区并执行格式化
将选定的程序包安装至目标位置
安装bootloader
```

3. 首次启动

``` config
iptables
selinux
core dump(核心转储,内核崩溃时存储在磁盘上)
```

## anaconda的配置方式

1. 交互式配置方式
2. 支持通过读取配置文件中事先定义好的配置项自动完成配置；遵循特定的语法格式，此文件即为kickstart文件（**kickstart文件放置在本地网络服务器上**）

## 安装引导选项

- 文本安装方式 `boot: linux text`
- 手动指定使用的安装方法 `boot: linux method`
- 与网络相关的引导选项：

``` shell
boot: linux method ip=172.16.7.1 netmask=255.255.0.0 gateway=172.16.1.1 dns=114.114.114.114 ifname=NAME:MAC_ADDR
```

- 远程访问功能相关的引导选项
  - `vnc vncpassword='PASSWORD'`

- 启动紧急救援模式
  - `boot: linux rescue`

- 装载额外驱动：driver disk
  - `boot: linux dd`

## 指明kickstart文件的位置

- DVD drive: ks=cdrom:/PATH/TO/KICKSTART_FILE
- Hard drive: ks=hd:/device/directory/KICKSTART_FILE
- HTTP server: ks=http://host:port/path/to/KICKSTART_FILE
- FTP server: ks=ftp://host:port/path/to/kickstart_FILE
- HTTPS server: ks=https:///host:port/path/to/KICKSTART_FILE

``` shell
boot: linux method ip=172.16.7.1 netmask=255.255.0.0 gateway=172.16.1.1 dns=114.114.114.114 ks=ftp://172.16.0.1/pub/sources/other/anaconda-ks.cfg
```

## kickstart文件的格式：

1. 命令段：指明各种安装前配置选项，如键盘类型等
2. 程序包段：指明要安装的程序包租或程序包，不安装的程序包等

``` config
%packages  程序包端开始标记

@group_name 包组
package 包
-package 不安装包，有可能安装，因为依赖关系

%end 程序包端结束标记
```

3. 脚本段：

``` config
%pre：安装前脚本
  运行环境：运行于安装介质上的微型Linux环境
%post：安装后脚本
  运行环境：安装完成的系统
```

### 命令段中的命令

- 必备命令：
  - authconfig: 认证方式配置 
    - `authconfig --usershadow --passalgo=sha512`
  - bootloader: bootloader的安装位置及相关配置
    - `bootloader --location=mbr --driverorder=sda --append="crashkernel=auto crashkernel=auto rhgb quiet"`
  - keyboard:设定键盘类型
    - `keyboard us`
  - lang：设定语言类型
    - `lang zh_CN.UTF-8`
    - zh: 中文
    - CN: 中国
  - part：创建分区
    - `part /boot -fstype=ext4 --size=500`
    - `part pv.008002 --size=51200`
  - clearpart：清除分区
    - `clearpart --none --drives=sda` 清空磁盘分区
  - volgroup：创建卷组
    - `volgroup myvg --pesize=4096 pv.008002` 创建卷组
  - logvol：创建逻辑卷
    - `logvol /home --fstype=ext4 --name=lv_home --vgname=myvg --size=5120`

  - rootpw：指明管理员的密码
    - `rootpw --iscrypted $6$029302k2k32lk32$aksjfjasoidjfoiajsfjoasjf`

  - 生成加密密码的方式：`# openssl passwd -1 -salt $(openssl rand -hex 4)`
    - -1：md5
    - -hex: 4byte * 2 = 8bytes
    - -base64 4

  - timezone：指明时区
    - `timezone Asia/Shanghai`

- 可选命令
  - `install` OR `upgrade` 安装或升级
  - `text`：安装界面类型，text为tui，默认为GUI
  - network 配置网络接口
    - `network --onboot yes --device eth0 --bootproto dhcp --noipv6`
  - firewall 防火墙
    - `firewall --disabled`
    - `firewall --service=ssh` 启动firewall，开放ssh服务
  -　selinux： SELinux
    -　`selinux --disabled`

  - halt,poweroff, reboot： 安装完成之后的行为

  - user：安装完成之后为系统创建新用户

  - repo：指明安装时使用的repository
    - `repo --name="CentOS" --baseurl=cdrom:sr0 --cost=100`
  - url：指明安装时使用的repository，URL格式, 比repo优先级更高
    - `url --url=http://IP/cobbler/ks_mirror/CentOS-6.7-x86_64/`

## 系统安装完成之后禁用防火墙：

- CentOS 6

``` shell
# service iptables stop
# chkconfig iptables off
```

- CentOS 7

``` shell
# systemctl stop firewalld.service
# systemctl disabled firewalld.service
```

## 警用SELinux

- 重启之后有效
  - 编辑`# /etc/sysconfig/selinux或/tc/selinux/config`文件，修改参数SELINUX=permissive或disabled
- 立即生效

``` shell
# setenforce 0
# getenforce
```

## 创建kickstart文件的方式：

1. 直接手动编辑，依据某模版修改
2. 使用创建工具：system-config-kickstart(CentOS 6)

`system-config-kickstart`依赖GUI
依据某模版修改并生成新配置
`# yum -y install system-config-kickstart`

- F2 => BIOS

`boot: linux ip=192.168.1.10 netmask=255.255.255.0 ks=http://192.168.1.71/kick.cfg`

## 检查ks文件中语法错误

`# ksvalidator ks.cfg`

## 创建引导光盘：

``` shell
# cp -r /media/cdrom/isolinux /tmp/myiso/
# cd /tmp/myiso/isolinux
# chmod u+w isolinux.cfg
# cp /root/ks.cfg /tmp/myiso/
# cd /tmp
# mkisofs -R -J -T -v --no-emul-boot --boot-load-size 4 --boot-info-table -V "CentOS 6.7 x86_64 boot" -b isolinux/isolinux.bin -c isolinux/boot.cat -o /root/boot.iso myiso/
# /tmp/myiso/isolinux/isolinux.cfg

label ks
menu label ^Install an existing system bases ks
menu default
kernel vmmlinuz
append initrd=initrd.img ks=cdrom:/ks.cfg

boot: linux ks=cdrom:/ks.cfg

如果菜单显示ks安装请修改上面代码，重新生成boot.iso文件
```