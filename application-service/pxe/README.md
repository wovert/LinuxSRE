# PXE

## PXE 介绍

> Preboot excution eviroment

没有安装OS的主机，能够完成网络引导启动安装操作

## pxe工作流程

客户端网卡支持网络引导机制（网卡芯片需要支持）。如果主机已经有OS的话，网络引导调整为第一引导启动设备。在主机被唤醒之后，开始加载网络引导应用时，此网卡会通过在本地局域网当中广播一个RARP协议获得一个IP地址；获得IP地址以后，还是会从DHCP 服务器获的文件名称和文件服务器地址。此时，请求文件所在服务器主机通过tftp协议获取加载此文件，加载完之后在内存中展开。而后，基于此文件可以实现加载一个内核文件，此内核文件也一样通过tftp文件服务器获取内核文件。一个内核依赖于initrd虚根完成对于真实根所在设备的驱动的加载，这一切都给予文件服务器实现。加载完以后，这个内核文件通常是专用于为系统所设定的，因此，如果配置了网络属性的话，接着这个内核文件还是需要基于网络配合到内核的IP地址，基于网络把自己扮演某种协议的客户端去加载一个能够启动安装的包，在本地安装并启动一个应用程序。而此程序在什么地方呢？已经不在文件服务器上。他的使命已经完成了。安装CentOS或Redhat系列时它应该安装过程中安装大量的RPM包。这些RPM包彼此之间有依赖关系的。

网络引导安装依赖基础镜像仓库。所以，基于ftp，Http或NFS 协议服务提供的yum仓库。还要通过yum仓库加载安装程序以及安装程序启动完以后，很可能会读取kickstart文件，并根据kickstart文件的内容解决依赖关系以后，基于这个yum仓库完成后续的所有安装过程。

- CentOS系列安装OS的工作模式
  - DHCP (ip/netmask, gw, dns, filename, next-server)
  - tftp server(bootloader, kernel, initrd)
  - yum repository(ftp, http, https, nfs)
  
  - kickstart 文件

## 服务设置

### tftp server

- tcp/69

- CentOS 6
  - chkconfig tftp on
  - service xinetd restart
- CentOS 7
  - systemctl start tftp.socket
  - systemctl enable tftp.socket

- 默认的文件根目录：`/var/lib/tftpboot`

- Node1:
  - IP: 192.168.10.9/24
  - GW: 192.168.10.1
  - DNS: 192.18.0.1

192.168.10.9主机

``` sh
# vim /etc/ssh/sshd_config
  UserDNS no
# systemtl reload sshd.service

# yum -y install tftp-server tftp-server
# systemctl restart network.service
# rpm -ql tftp-server
# systemctl start tftp.socket

客户端
# rpm -ql tftp
# tftp 192.168.10.9
tftp > ls
tftp > help
tftp > status

# ls /var/lib/tftpboot
# cp /etc/grub2.cfg /var/lib/tftpboot/
# cd /tmp
# tftp 192.168.10.9
tftp > get grub2.cfg

tmp # ls

```

### DHCP server 配置

192.168.10.9主机

``` sh
# cd /etc/dhcp/
# vim dhcpd.conf
  option routers 192.168.10.9;
  option domain-name-servers 192.18.0.1;

  subnet 192.168.10.0 netmask 255.255.255.0 {
    range 192.168.10.101 192.168.10.120;

    filename "pxelinux.0";
    next-server 192.168.10.9;
  }
# systemctl restart dhcpd.service
# ss -unl
 *:67

# grep -v "^#" /etc/dhcpd.conf
```

### 配置YUM仓库

192.168.10.9主机

``` sh
挂载CentOS 7
# mount /dev/cdrom /media
# ls /media

# rpm -q httpd
# mkdir /var/www/html/centos/7/x86_64 -pv
# mount -r /dev/cdrom /var/www/html/centos/7/x86_64
# ls /var/www/html/centos/7/x86_64
# systemctl start httpd.sevice
```

测试: http://192.168.10.9/centos/7/x86_64

### kickstart 文件

192.168.10.9主机

centos7.cfg文件内容

``` sh

# vim /var/www/html/kickstarts/centos7.cfg
  install
  xconfig --startxonboot
  keyboard --vckeymap=cn --xlayouts='cn'
  reboot
  rootpw --iscrypted $1$HDHf2v4i$Lmo.xGHfxQDOf8e043C.g/
  timezone Asia/Shanghai
  url --url="http://192.168.10.9/centos/9/x86_64/"
  lang zh_CN
  user --groups=wheel --name=wovert --password=$6$xxxxxx --iscrypted --gecos="wovert"
  firewall --disabled
  network --bootproto=dhcp --device=eth0
  auth --useshadow --passalgo=sha512
  text
  firstboot --disable
  selinux --permissive

  ignoredisk --only-use=sda
  bootloader --location=mbr --boot-drive=sda
  zerombr

  clearpart --all --initlabel

  part /boot --asprimary --fstype="xfs" --size=512
  part swap --fstype="swap" --size=2048
  part /usr --fstype="xfs" --size=20480
  part / --fstype="xfs" --size=20480

  %packages
  @base
  lftp
  wget
  tree

  @end

# yum /etc/yum.repos.d/CentOS-Base.repo
  baseurl=file:///var/www/html/centos/7/x86_64

# yum -y install syslinux
# rpm -ql syslinux
  /usr/share/syslinux/pxelinux.0

# cp /sur/share/syslinux/pxelinux.0 /var/lib/tftpboot/

内核文件和initrd
# ls /var/www/html/centos/7/x86_64/images/pxeboot/
  initrd.img
  vmlinuz
# ls /var/www/html/centos/7/x86_64/images/pxeboot/{vmlinuz, initrd.img} /var/lib/tftpboot/

可选择菜单选项：/usr/share/syslinux/menu.c32
图像界面: /usr/share/syslinux/vesamenu.c32
内存: /usr/share/syslinux/memdisk
# cp /usr/share/syslinux/{chain.c32, menu.c32, memdisk, mboot.c32} /var/lib/tftpboot/

提供目录 引导菜单显示的内容

# cd /var/lib/tftpboot/
# mkdir pxelinux.cfg
# cd pxelinux.cfg
# vim default
default menu.c32
        prompt 5
        timeout 5
        MENU TITLE CentOS 7 PXE Menu

        LABEL linux
        MENU LABEL Install CentOS 7 x86_64
        KERNEL vmlinuz
        APPEND initrd=initrd.img ip=192.168.10.11 netmask=255.255.255.0 inst.repo=http://192.168.10.9/centos/7/x86_64/
# systemctl start httpd.sevice
```

### 新建虚拟机

- CentOS 7
- use Host-Only
- 显示界面时 按 tab 键 或 附加在 APPEND 后面
- 配置文件设置的是网卡的IP

- 设置加载内核的IP地址

vmlinuz initrd=initrd.img ip=192.168.10.11 netmask=255.255.255.0 inst.repo=http://192.168.10.9/centos/7/x86_64/

自动运行配置

``` sh
最好使用DHCP获取地址

# vim /var/lib/tftpboot/ pxelinux.cfg/default
default menu.c32
        prompt 5
        timeout 5
        MENU TITLE CentOS 7 PXE Menu

        LABEL linux
        MENU LABEL Install CentOS 7 x86_64
        KERNEL vmlinuz
        APPEND initrd=initrd.img inst.repo=http://192.168.10.9/centos/7/x86_64/

        LABEL linux auto inst
        MENU LABEL Install CentOS 7 x86_64 auto
        KERNEL vmlinuz
        APPEND initrd=initrd.img inst.repo=http://192.168.10.9/centos/7/x86_64/ ks=http://192.168.10.9/kickstarts/centos7.cfg
```

再次启动虚拟机运行

## 配置怕PXE环境

### CentOS 7

```sh
# yum -y install syslinux
# cp /usr/share/syslinux/pxelinux.0 /var/lib/tftpboot/
# cp /media/cdrom/images/pxeboot/{vmlinuz,initrd.img] /var/lib/tftpboot
# cp /usr/share/syslinux/{chain.c32, mboot.c32, menu.c32, memdiskt} /var/lib/tftpboot

# mkdir /var/lib/tftpboot/pxelinux,cfg/
# vim /var/lib/tftpboot/pxelinux,cfg/default
  default menu.c32
    prompt 5
    timeout 5
    MENU TITLE CentOS 7 PXE Menu

    LABEL linux
    MENU LABEL Install CentOS 7 x86_64
    KERNEL vmlinuz
    APPEND initrd=initrd.img inst.repo=http://192.168.10.9/centos/7/x86_64/

    LABEL linux auto inst
    MENU LABEL Install CentOS 7 x86_64 auto
    KERNEL vmlinuz
    APPEND initrd=initrd.img inst.repo=http://192.168.10.9/centos/7/x86_64/ ks=http://192.168.10.9/kickstarts/centos7.cfg
```

### CentOS 6

```sh
# yum -y install dhcp tftp-server tftp syslinux vsftpd

获取kickstart文件
# wget http://182.18.0.1/centos6.cfg

主机配置：Host-Only

# cp /usr/share/syslinux/pxelinux.0 /var/lib/tftpboot/
# cp /media/cdrom/images/pxeboot/{vmlinuz,initrd.img] /var/lib/tftpboot/


# cp /media/cdrom/isolinux/{boot.cfg, vesamenu.c32, splash.png} /var/lib/tftpboot

# mkdir /var/lib/tftpboot/pxelinux.cfg/

# cp /media/cdrom/isolinux/isolinux.cfg /var/lib/tftpboot/pxelinux.cfg/default
# vim /var/lib/tftpboot/pxelinux,cfg/default

  default menu.c32
    prompt 5
    timeout 5
    MENU TITLE CentOS 7 PXE Menu

    LABEL linux
    MENU LABEL Install CentOS 7 x86_64
    KERNEL vmlinuz
    APPEND initrd=initrd.img inst.repo=http://192.168.10.9/centos/7/x86_64/

    LABEL linux auto inst
    MENU LABEL Install CentOS 7 x86_64 auto
    KERNEL vmlinuz
    APPEND initrd=initrd.img inst.repo=http://192.168.10.9/centos/7/x86_64/ ks=http://192.168.10.9/kickstarts/centos7.cfg
```

