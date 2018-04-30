# 系统管理
- 磁盘分区及文件系统管理
- RAID
- LVM
- 网络属性管理
- 程序包管理
- 进程管理
- 内核管理
- 系统启动流程
- 定制、编译内核、busybox
- 系统安装：kickstart
- shell脚本编程

# 磁盘分区及文件系统管理

## 磁盘接口类型
- 并口：IDE,SCSI
- 串口：SATA, SAS, USB
- IDE(早期为ata，但并不相同)：并口
	+ 速率：133MB/s
	+ 接口名：/dev/hd[a-z]
- SCSI：并口
	+ 接口名：/dev/sd[a-z]
	+ UltraSCSI320, 320MB/s
	+ UltraSCSI640, 640MB/s
- SATA：串口
	+ 速率：6Gbps, 
	+ 接口名：/dev/sd[a-z]
- SAS：串口（SCSI），
	+ 速率：6Gbps 
	+ 接口名：/dev/sd[a-z]
- USB：串口
	+ 速率：3.1v 480MB/s
	+ 接口名：/dev/sd[a-z]
- 并口：同一线缆可以接多块设备
	+ IDE：两个，主设备，从设备
	+ SCSI：
		* 宽带：16-1
		* 窄带：8-1
+ 串口：同一线缆只可以接一个设备

> IOPS (Input/Output Operations Per Second)，即每秒进行读写（I/O）操作的次数，多用于数据库等场合，衡量随机访问的性能。存储端的IOPS性能和主机端的IO是不同的，IOPS是指存储每秒可接受多少次主机发出的访问，主机的一次IO需要多次访问存储才可以完成。例如，主机写入一个最小的数据块，也要经过“发送写入请求、写入数据、收到写入确认”等三个步骤，也就是3个存储端访问
		
## IOPS理论值
- IDE: 100
- SCSI: 150
- SATA: 100
- SAS: 150-200

## 硬盘结构
- 机械硬盘：电子设备
- 马达带动的轴上多个盘片，盘片划分成等同的同心圆，即磁道track
- 每个磁道划分成若干个等同的扇区sector，512bytes
- 不同盘面上的的同一个编号盘面，柱面，Cylinder
- 分区划分基于cylinder实现的
- 最外层的柱面速度最快
- 固定角速度
- 机械臂
- 磁头悬浮在盘面上
	
## 读取数据：
1. 挪动磁头固定到磁道上
2. 等待数据转过来
	
## 平均寻到时间
1. 磁头挪动时间
2. 盘片转速
	+ 5400rpm,笔记本
	+ 7200rpm, 10000rpm, 15000rpm(SCSI) PC
	+ 离心机：30000rpm/m


## 固态硬盘：多个并行的USB盘，电气设备
- IOPS: 400
- PIC-E：100000

## 设备类型：
- 块(block)：随机访问，数据交换单位是“块”
- 字符(character)：线性访问，数据交换单位是“字符”

## 设备文件：FHS
- 设备文件的作用：
	+ 关联至设备驱动程序（内核中的程序文件）；
	+ 设备的访问入口
- 设备号：
	+ major：主设备号，区分**设备类型**；用于标明设备所需要的驱动程序
	+ minor：次设备号，区分**同种类型下的不同的设备**;是特定设备的访问入口

## mknod 命令
> make block or charactoer special files

- `mknod [OPTION]... NAME TYPE [MAJOR MINOR]`
- 选项
	+ `TYPE: c | b`
	+ `-m, --mode` 创建设备文件的访问权限，**系统调用**来实现的

`~]# mknod /dev/testdev/ c 111 1`
`~]# ls -l /dev/testdev`
`~]# install -m` 复制同时修改权限

`~]# cp /usr/bin/chmod /tmp/`
`~]# chmod a-x /tmp/chmod`
`~]# install -m 755 /tmp/chmod /tmp/test/`

- 设备文件名：**ICANN** 机构分配

## 磁盘命令
- IDE: /dev/hd[a-z]
- SCSI,SATA,SAS,USB: /dev/sd[a-z]
- 分区：
	+ /dev/sda#
	+ /dev/sda1,...
- 注意：CentOS 6和7统统将硬盘设备文件标识为/dev/sd[a-z]#
- 引用设备的方式：
	+ 设备文件名
	+ 卷标
	+ UUID：128位的编号

## 磁盘分区：MBR，GPT
- MBR: Master Boot Recored,主引导记录
	+ 位置：0 sector，512byte, 0编号扇区

	+ 分为三部分：
		* 446byte: bootloader, 引导启动操作系统的程序
		* 64byte: 分表表，每16byte表示一个分区，一共只能有4个分区
			- 4主分区
			- 3主1扩展（n逻辑分区）
		* 2bytes: MBR区域的有效性校验；55AA为有效

	+ 主分区和扩展分区的表示：1-4
	+ 逻辑分区：5+

- 课外作业：GTP是什么，怎么使用？

## fdisk 
> manipulate disk partion table

1. 查看分区
- fdisk -l -u [device...] 列出指定磁盘设备上的分区情况
	+ 实际内核查看分区表：`# cat /proc/partitions `

- CentOS 7 扇区标识： Start End
- CentOS 6 柱面标识: Start End

- 分区类型：16进制
	+ Linux标识主分区：		83
	+ Extended标识主分区：	5
	+ Swap标识交换分区：		82

2. 管理分区
- `~]# fidsk device`
- fidsk提供了一个交互式接口管理分区，有很多子命令，分别用于不同的管理功能；
- 所有的操作均在内存中完成，没有直接同步到磁盘；
- 直到使用w命令保存至磁盘上；
		
## 常用命令
- n: add a new partition
	+ p(主分区) or e(扩展分区) or l(逻辑分区)
		* number {1-4}
	+ start sector
		* +10G
- d：delete partition
- t: modify partition type

- w: save and quite
- q: not save and quite

- p: print list partitions
- l：all partition type list
- m: help

- 注意：在**已经分区并且已经挂载**其中某个**分区**的磁盘设备上的**创建的新分区**，**内核**可能在完成之后**无法直接识别**
	+ 查看内核识别的分区：`~]# cat /proc/partitions`

### 通知内核强制重读分区表
- CentOS 5: `# partprob [device]`
- CentOS 6|7:
	+ `~]# partx -a device` 读取所有分区并添加分区（有时需要执行两次命令）
		* -a: Add the specified partitions, or read the disk and add all partitions
	+ `~]# kpartx -af device`
		* -a: append partition mapping
		* -f: force creations of mapping; overrides 'no_partitions' feature

- 分区创建工具：`parted, sfdisk`

# 创建文件系统
## 格式化
1. 低级格式化（分区之前进行 =>划分磁道）
2. 高级格式化（分区之后对分区进行 => 创建文件系统）

## 元数据和数据区
### 元数据区
- 文件元数据：大小、权限、属主属组、时间戳、数据块指针（占据了哪些数据块，单个文件大小有限）
	+ inode(index node) 是索引节点 
	+ inode 大小固定
	+ 文件名不在元数据存储，而是在目录当中保存文件名
	+ inode 数量少，浪费数据空间
	+ inode 数量多，浪费 inode 空间

- 元数据还包含
	+ inode data
	+ bitmap inode index
	+ bitmap block index
	
### 数据区
	+ block:磁盘块大小，n*512bytes
	+ 文件块不连续，说明有碎片

### 保留预留空间
- 用于当磁盘空间占满时，管理员可以管理的空间

- inode 与 block 比率？
- inode 和 block 怎么知道空闲？
- **Bitmap block index**：磁盘块位图索引（1bit,0：未使用，1：使用）
- **Bitmap inode index**：索引节点位图缩影（1bit,0：未使用，1：使用）

- 符号连接文件：存储数据指针的空间当中存储的是**真实文件的访问路径**
- 设备文件：存储数据指针的空间当中存储的设备号(major, minor)

### 磁盘块组（逻辑分区）
- 元数据区/每个块组
	+ inode table
	+ 磁盘块位图索引
	+ inode 位图索引
	+ 有超级块（所有块组）+ 块组描述符（当前块组的）
- 数据区/每个块组

- 超级块：管理磁盘块组
	+ 超级块也在块组当中
	+ 管理块分组
	+ 备份超级块便于某个超级快损坏时适应该超级快作为管理块组

- **先分块，然后分元数据块和数据块**


### 文件名存储在哪里？
- /var/log/messages

1. 根（/）查找inode，找到磁盘块（目录下所有的文件名和inode的对应关系）
	文件名	inode
	+ var		0x1023930
	+ bin		0x2093902
	+ sbin	0x2d92392
	+ ...
2. var 文件所对应的 inode 编号 0x1023930
3. var 文件磁盘块（目录下所有的文件名和 inode 对应关系）
	+ log 	0x2309230
	+ cache	0x2039203
4. log 文件的 inode 编号 0x2309230，在磁盘块中查找 log 磁盘块(目录下所有的文件名inode对应关系)
	+ message 0x2930239
5. message 文件的 inode 编号 0x2930239，在磁盘块中找到文件内容
	+ 文件名保存在目录上（即数据块上）

- 目录：文件路径映射

- 文件路径缓存到内存里以便日后快速查找
	+ free 命令的 cache 和 buffer
	+ free 命令
		Buffer（写）/cache（读）：有元数据和数据

## VFS
> Virtual File System, 虚拟文件系统
- 当两个层次不衔接时，加入中间层

- Linux的文件系统：ext2,ext3,ext4,xfs(CentOS 7,64位),btrfs(测试使用),reiserfx(查找功能,反删除功能强),jfs,swap
- 光驱文件系统：iso9669
- 网络文件系统：nfs, cifs,smbfs
- 集群文件系统：gffs2,ocfs2
- 内核级分布式式文件系统：ceph, 
- 用户空间的分布式文件系统：moosefs,gluster, mogilefs
- windows的文件系统：vfat,ntfs
- 伪文件系统：proc,sys,tmpfs,hugepagefs
- Unix文件系统：UFS, FFS, JFS
- 交换文件系统：swap
- 数据交换：内存不够时数据保存在交换文件系统内，内存使用时再次调用交换文件系统内的数据（虚拟内存）

- 符号链接文件：存储数据指针的空间当中存储的是真实文件的访问路径
- 设备文件：存储数据指针的空间当中存储的是设备号（major,minor）

## 文件系统管理工具
- 创建文件系统：mkfs -t, mkfs.ext2, mke2fs -t
- 检测及修复文件系统：fsck,fsck.ext2,fsc.ext3....
- 查看属性：dumpe2fs
- 修改属性：tune2fs

## 创建文件系统工具
- mkfs -t ext2 ext3 ext4 xfs vfat
- mkfs.ext2, mkfs.ext3, mkfx.ex4, mkfs.xfs, mkfs.vfat
- mke2fs -t ext2 ext3 ext4 xfs

## 检测及修复文件系统的工具
- fsck
- fsck.ext2 fsck.ext3,..

## 查看其属性的工具
- dumpe2fs, tune2fs

## 调整文件系统特性
- tune2fs

## 内核及文件系统的组成部分
- 文件系统驱动：由内核提供
- 文件系统管理工具：由用户空间的应用程序提供

## 查看内核装载模块
1. 装载模块到内核：`# lsmod`
2. 编译进内核模块，内核一部分；`# lsmod命令看不到`

## 文件系统类型
- 日记型文件系统：journal, ext3, ext4, xfs
- 非日记型文件系统：ext2,vfat

## 日志文件系统
1. 元数据放到日志区
2. 数据存储完毕，数据没有存储，电源关闭。开机直接在日志区中修复。
3. 元数据放到元数据区

- 优势：数据保证
- 缺点：性能损失（IO读取）

## 链接文件：访问同一个文件, 观世音菩萨，路径
### 硬链接：多个文件路径指向同一个 inode
- 特性：
	1. 目录不支持硬链接（避免循环链接）
	2. 不能跨文件系统(不同的inode独立管理的)
	3. 创建硬链接会增加inode应用计数

- 用法：`# ln source link_file`

### 符号链接：指向一个文件路径的另一个文件路径
- Inode 当中指针不指向磁盘块，而是指向访问文件的路径
- 特性
	1. 符号链接与文件是各自独立的文件，各有自己的inode；对原文件创建符号不会增加inode引用计数
	2. 支持目录创建符号链接，可以跨文件系统
	3. 删除符号链接文件不影响原文件；但删除原文件，符号指定的路径不存在，此时会变成无效链接
	4. 符号链接大小是其指定的文件的路径字符串的字符数
	
- 用法：`# ln -sv source link_file`

## stat命令
- Regular file
- Symbolic file

## 文件系统的组织结构中的术语：
- block groups, block,inode tables, inode, inode bitmap, block bitmap,superblock, block group descriptor

## Linux信息：
- /etc/issue
	+ CentOS release 6.7 (Final)
- `uname -r`
	+ 2.6.32-573.el6.x86_64

# 文件系统管理工具

## ext系列文件系统的管理工具：
- mkfs.ext2, mkfs.ext3, mkfs.ext4
- mkfs -t ext2 = mkfs.ext2

## ext系列文件系统专用管理工具：mke2fs
- mke2fs [OPTIONS] device
	+ -t {ext2|ext3|ext4}：指明要创建的文件系统类型
		
- mkfs.ext4 = mkfs -t ext4 = mke2fs -t ext4
	+ -b {1024|2048|4096}:文件系统块大小，默认4096
	+ -L LABEL：指明卷标, blkid /dev/sda3
	+ -j：创建有日志功能的文件系统
			mke2fs -j = mke2fs -t ext3 = mkfs -t ext3 = mkfs.ext3 = mke2fs -O has_journal
	+ -i #：bytes-per-inode, inode与字节的比率，每多少字节创建一个inode
	+ -N #：直接指明给此文件系统创建的inode数量
	+ -m #：预留空间百分比

	+ -O [^]feature：特性,指定的特性创建目标文件系统，^取消特性

## e2label命令：查看与设定卷标
- 查看：`# e2label device`
- 设定：`# e2label device LABEL`

## tune2fs命令：查看或修改ext系列文件系统的某些属性；块大小创建后不可修改
- tune2fs [OPTIONS] device
	+ -l:查看超级块信息
		* FileSystem magic number: 文件系统类型标识
		* Filesystem state: clean(文件没有损坏状态) dirty

- 修改指定文件系统的属性
	+ -j: ext2 --> ext3
	+ -L LABEL：修改卷标
	+ -m #: 调整预留给百分比，默认5%
	+ -O [^]feather开启或关闭某种特性
	+ # tune2fs -O ^has_journal /dev/sda5
	+ -o [^]mount_options：开启或关闭某种默认挂载选项 
	+ acl：是否支持facl功能

## dumpe2fs命令：显示ext系列文件系统的属性详细信息
- dumpe2fs [-h] device 显示超级块信息

## fsck命令：系统突然断电，手动执行文件系统的检测，修复命令
> 因进程意外终止或系统崩溃等原因导致定稿操作非正常终止时，可能会造成文件损坏；此时，应该检测并修复文件系统；建议，离线进行；

## ext系列文件系统的专用工具：
- e2fsck - check a Linux ext2/ext3/ext4 file system
- e2fsck [OPTIONS] device
	+ -y：对所有问题自动回答为yes
	+ -f：即使文件系统处理clean状态，也要进行强制进行检查

- fsck：check repare a Linux file system
	+ -t fstype：指明文件系统类型
	+ fsck -t ext4 = fsck.ext4
	+ -a：无需交互自动修复所有操作
	+ -r：交互式修复

## blkid命令：blkid [OPITONS] device
- blkid -L LABEL:根据LABEL定位设备
- blkid -U UUID：根据UUID定位设备

## CentOS 6默认不支持xfs文件系统，需要安装rpm包：
1. 修改yum源cd /etc/yum.repos.d/
```
# wget http://172.16.0.1/centos6.7.repo
# mv CentOS-Base.repo CentOS-Base.repo.bak
```
2. # yum install xfsprogs
`# yum -ql xfsprogs`
3. # mkfs.xfs -f DEVICE
	
## blkid DEVICE
- SEC_TYPE=安全类型

## swap文件系统
- Linux上的交换分区必须使用独立的文件系统
- 且文件系统上的System ID必须为82

- 创建swap设备：mkswap命令
```
mkswap [options] device
	-L LABEL：指明卷标
	-f：强制
```

- Windows无法识别Linux的文件系统； 因此，存储设备需要两种系统之间交叉使用时，应该使用windows和Linux同时支持的文件系统：fat32(vfat); 
`# mkfs.vfat device`

## 文件系统的使用
首先要"挂载"：mount命令和umount命令
		
根文件系统这外的其它文件系统要想能够被访问，都必须通过“关联”至根文件系统上的某个目录来实现，此关联操作即为“挂载”；此目录即为“挂载点”；
		
挂载点：mount_point，用于作为另一个文件系统的访问入口；
1. 事先存在；
2. 应该使用未被或不会被其它进程使用到的目录；
3. 挂载点下原有的文件将会被隐藏；
		
# mount命令
`mount  [-nrw]  [-t vfstype]  [-o options]  device  dir`
## 命令选项
- -r：readonly，只读挂载
- -w：read and write, 读写挂载
- -n：默认设备挂载或卸载的操作会同步更新至/etc/mtab文件中；用于禁止此特性
- -t vfstype：指明要挂载的设备上的文件系统的类型；多数情况下可省略，此时mount会通过blkid来判断要挂载的设备的文件系统类型

- -L LABEL：挂载时以卷标的方式指明设备
	+ # mount -L LABEL dir
- -U UUID：挂载时以UUID的方式指明设备
	+ # mount -U UUID dir
	
- -o options：挂载选项
	+ sync/async：同步/异步操作
	+	异步：进程中写入磁盘先存入内存，然后写入磁盘
	+	同步：立即写入到磁盘上
	+ atime/noatime(default)：文件或目录在被访问时是否更新其访问时间戳
	+ diratime/nodiratime(default)：目录在被访问时是否更新其访问时间戳		remount：不用卸载，重新挂载
	+ acl：支持使用facl功能
		* # mount -o acl device dir 
		* # tune2fs  -o  acl  device 
	+ ro：只读 
	+ rw：读写	
	+ dev/nodev：此设备上是否允许创建设备文件
	+ exec/noexec：是否允许运行此设备上的程序文件
	+ auto/noauto：自动挂载（写人/etc/fstab文件中才能自动挂载）
	+ user/nouser：是否允许普通用户挂载此文件系统
	+ suid/nosuid：是否允许程序文件上的suid和sgid特殊权限生效	
	+ relatime/norelatime：是否参考修改或更新来更新访问时间
	
	+ defaults：rw, suid, dev, exec, auto, nouser, async, and relatime.
				
- 可以实现将目录绑定至另一个目录上，作为其临时访问入口；
`# mount --bind  源目录  目标目录`
					
## 查看当前系统所有已挂载的设备：
```
# mount 
# cat  /etc/mtab
# cat  /proc/mounts
```				
- 挂载光盘：`# mount  -r  /dev/cdrom  mount_point`
- 光盘设备文件
	+ IDE：/dev/hdc
	+ SATA: /dev/sr0

- 符号链接文件：
	+ /dev/cdrom
	+ /dev/cdrw
	+ /dev/dvd
	+ /dev/dvdrw

```
# mount -r device mount_point
# mount /dev/cdrom
```

- 挂载U盘：事先识别U盘的设备文件
- 保证你的U盘的格式是fat格式
`# mount -t vfat /dev/sdb /mnt/usb`


## 挂载本地的回环设备：光盘镜像文件
```
# mount -o loop /PATH/TO/SOME_LOOP_FILE MOUNT_POINT 
# mount -o loop /XXX.iso或img	/media
```

## umount 命令
`umount  device|dir`
		
- 注意：正在被进程访问到的挂载点无法被卸载；
- 查看被哪个或哪些进程所战用：
`# lsof  MOUNT_POINT`
`# fuser -v  MOUNT_POINT`
			
- 终止所有正在访问某挂载点的进程：
	+ `# fuser  -km  MOUNT_POINT`
					
## 交换分区的启用和禁用：
- 创建交换分区的命令：mkswap		
- 启用：swapon
```
swapon  [OPTION]  [DEVICE]
	-a：定义在/etc/fstab文件中的所有swap设备；
```				
- 禁用：swapoff
`swapoff DEVICE`
			
	
## 设定除根文件系统以外的其它文件系统能够开机时自动挂载：/etc/fstab文件 
- 每行定义一个要挂载的文件系统及相关属性：6个字段
1. 要挂载的设备
	设备文件
	LABEL
	UUID
	伪文件系统：如sysfs, proc, tmpfs等

	LABEL=MYSAA
	UUID=209909sf0ad9f0asdf0a9sf

2. 挂载点 
	swap类型的设备的挂载点为swap
3. 文件系统类型
4. 挂载选项
	defaults：使用默认挂载选项；
	如果要同时指明多个挂载选项，彼此间以事情分隔；
		defaults,acl,noatime,noexec
5. 转储频率
	0：从不备份
	1：每天备份
	2：每隔一天备份
6. 自检次序（自检系统文件系统是否有损坏）
	0：不自检
	1：首先自检，通常只能是根文件系统可用1
	2：次级自检

`# mount -a` 可自动挂载定义在此文件中的所支持自动挂载的设备；
			
## df命令：disk free，磁盘挂载情况
```
df [OPTION]... [FILE]...
	-l：仅显示本地文件的相关信息，不现实网络文件系统
	-h：human-readable
	-i：显示inode的使用状态而非blocks
```		

## du命令：disk user磁盘使用状态，当前目录下所有文件大小
```
du [OPTION]... [FILE]...
	-s: 只显示总大小，sumary
	-h: human-readable
```

### 练习：
1. 创建一个10G的分区，并格式化为ext4文件系统； 
	1.1 block大小为2048；预留空间为2%，卷标为MYDATA；
	1.2 挂载至/mydata目录，要求挂载时禁止程序自动运行，且不更新文件的访问时间戳；
	1.3 可开机自动挂载；
		
2.创建一个大小为1G的swap分区，并启动之；
				
		
## 文件系统：
- 目录：文件
	+ 元数据：inode, inode table
	+ 数据：data blocks
		* 下级文件或目录的文件名与其inode对应关系
		* dentry
- 文件名：上级目录；

- 删除文件：将此文件指向的所有data block标记为未使用状态；将此文件的inode标记为未使用；
- 复制和移动文件：
	+ 复制：新建文件；
	+ 移动文件：
		* 在同一文件系统：改变的仅是其路径；
		* 在不同文件系统：复制数据至目标文件，并删除原文件；
		
- 符号链接：
	+ 权限：lrwxrwxrwx，其指向链接的文件
- 硬链接：指向同一个inode；


# RAID 
- Redundant Arrays of Inexpensive Disks 廉价磁盘冗余阵列
- Redundant Arrays of Independent Disks 独立磁盘冗余陈列
- Berkeley: A case for Redundent Arrays of Inexpensive Disks RAID
> 多块硬盘按照某种组织格式形成一个硬盘使用
- 作用
	+ 提高IO能力
		* 磁盘并行读写（内置raid内存,额外供电防止断电导致数据丢失）
	+ 提高耐用性
		* 磁盘冗余来实现

- 级别：多块磁盘组织在一起的工作方式有所不同

## RAID实现方式：
- 外界式磁盘阵列：通过扩展卡适配能力
- 内接式RAID：主板集成RAID控制器
- Software RAID
- BIOS:外界式/内接式，安装OS之前配置好

## 级别：level
>磁盘组织形式不同，0-7

### RAID-0：0，条带卷，strip
- 若干个chunk平均分散存储
- 磁盘上一块由若干个地址连接的磁盘块构成的大小固定的区域
- chunk：块

- 读、写性能提升
- 可用空间：N*min(S1,S2,...) 10G, 20G, 30G => 10G,10G,10G
- 无容错能力
- 最少磁盘数：2,2+

- 优点：提供IO并行
- 缺点：减低耐用性，任何一块硬盘损坏全部损毁
- 用途：非关键性数据，临时文件系统、交互数据等

### RAID-1: 1, 镜像卷，mirror
- 若干个chunk分别存储

- 读性能提升：不同的磁盘上读取
- 写性能略有下降：同一个数据分别不同的磁盘上
- 可用空间：1*min(S1,S2,S3,...)10G,20G => 10G最少硬盘决定可用空间
- 有冗余能力
- 最少磁盘数：2,2+

### RAID-4: 4
- 至少三个磁盘，2个数据盘，1个校验盘
- 2个数据盘(RAID0)
- 1个校验盘(2个数据盘上的数据^运算结果)
- 例如：
	+ 1101^0110 => 1011
	+ 一个硬盘损坏，降级工作模式；及时更换硬盘
	+ 有灯来指示是否损坏
	+ 监控工具监听数据
	+ 硬件接口API

- 使用热备份(备胎)
- 总结：性能差、有冗余能力

### RAID-5: 5
- 校验码轮流放入不同的磁盘上
- 数据布局：左称线

- 读、写性能提升
- 可用空间：(N-1)*min(S1,S2,S3,...) 
- 10G 20G 30G
- 10G
- 有容错能力：1块磁盘
- 最少磁盘数：3,3+

### RAID-6: 6
- 2个校验盘、2个数据盘
- 读、写性能提升
- 可用空间：（N-2）*min(S1,S2,...)
- 有容错能力：2块磁盘
- 最少磁盘数：4，4+

### RAID-10
- 先做1，后做0（从下往上）
- 读、写性能提升
- 可用空间：N*min(S1,S2,...)/2
- 有容错能力：每组镜像最多只能坏一块
- 最少磁盘数：4,4+

### RAID-01:
- 先做0，后做1（从下往上）

### RAID-50:
- 先做0，后做1（从下往上）
- 至少6个
- 最多只能坏一个

### RAID-7:
- IO能力非常好，价格昂贵

### JBOD: Just a Bunch Of Disks
- 单个文件3.5T
- 4个每个1T
- 功能：将多块磁盘的空间合并一个大的连续空间使用
- 可用空间：sum(S1,S2,...)

### 常用级别：RAID-0, RAID-1, RAID-5, RAID-10, RAID-50， JBOD
### 实现方式：
- 硬件实现方式
- 软件实现方式

# CentOS 6上的软件 RAID 的实现
> 结合内核中的**md模块**（multi deviced）

- mdadm命令与内核中进行通信，与系统调用通信

## mdadm：模式化的工具，CentOS 6,7之后md有变化
- 命令语法格式：`mdadm [mode] <raiddevice> [options] <component-devices>`
		
- 支持的RAID级别：LINER,RAID0，RAID1，RAID4， RAID5， RAID6， RAID10
- 模式：
	+ 创建：-C
	+ 装配：-A
	+ 监控：-F follow
	+ 管理：-f, -r, -a 
- raiddevice: /dev/md#
- component-devices：任意块设备，整个磁盘或分区

### -C：创建模式
- -n #：使用#块设备来创建此RAID
- -l #：指明要创建的RAID的级别
- -a {yes|no} 是否自动创建目标RAID设备的设备文件
- -c CHUNK_SIZE：指明块大小，默认512kb
- -x #：指明空闲盘的个数；有冗余能力的；热备份，备胎
- 例如：创建一个10G可用空间的RAID5
	+ $ fdisk /dev/sda{6,7,8,9}
	+ 设备类型：fd Linux raid auto

### -D：显示raid的详细信息
- `$ mdadm -D /dev/md[0-9]+`

### 管理模式：
- -f: 标记指定磁盘为损坏
- -a：添加磁盘
- -r：移动磁盘

### 观察md状态：
- `$ cat /proc/mdstat`
- `$ watch -n1 'cat /proc/mdstat'`

### 停止md设备：
- `$ mdadm -S /dev/md0`

#### 彻底删除raid设备文件
1. 卸载设备
2. 删除raid
```
$ mdadm /dev/md0 --fail /dev/sdb5 --remove /dev/sdb5
$ mdadm /dev/md0 --fail /dev/sdb6 --remove /dev/sdb6
$ mdadm /dev/md0 --fail /dev/sdb7 --remove /dev/sdb7
$ mdadm /dev/md0 --fail /dev/sdb8 --remove /dev/sdb8
```
3. 停止运行raid
```
$ mdadm -S /dev/md0
$ mdadm --remove /dev/md0
$ mdadm --misc --zero-superblock /dev/sdb5
$ mdadm --misc --zero-superblock /dev/sdb6
$ mdadm --misc --zero-superblock /dev/sdb7
$ mdadm --misc --zero-superblock /dev/sdb8
```

- 先删除RAID中的所有设备，然后停止该RAID即可

- 为了防止系统启动时候启动raid
```
$ rm -f /etc/mdadm.conf
$ rm -f /etc/raidtab
```

- 检查系统启动文件中是否还有其他mdad启动方式
```
$ vi /etc/rc.sysinit+/raid\c
```

## watch options 'COMMAND'
- -n #：刷新间隔，单位是秒

#### 创建一个 10G 可用的 RAID5
> 3个5G或5个2.5G
- 磁盘个数越多浪费空间越小，当组织处理多
- 练习 10G 可用的 RAID5，还有一个冗余磁盘

1. Raid 分区必须使用 System ID 为 fd
2. $ cat /proc/mdstat 查看 md 设备
`$ ls -l /dev/ | grep md*`
3. $ mdadm -C /dev/md0 -a yes -l 5 -x 1 -n 3 /dev/sdb{5,6,7,8}
4. $ cat /proc/mdstat
5. $ mke2fs -t ext /dev/md0
6. $ mkdir /mydata
7. $ mount /dev/md0 /mydata
8. $ df -hl
9. $ blkid /dev/md0
10. 使用 UUID 或 LABEL 挂载到 /etc/fstab
11. $ mdadm -D /dev/md0
- D:Detail 信息

#### 损坏磁盘：自动热备份
1. $ mdadm /dev/md0 -f /dev/sdb5 标记为损坏
2. 每一秒钟刷新一次
`$ watch -n1 'cat /proc/mdstat'`
3. $ mdadm -D /dev/md0

#### 再次损坏磁盘
1. $ cat /etc/fstab /mydata
2. $ mdadm /dev/md0 -f /dev/sdb7
3. $ mdadm -D /dev/md0
4. $ cat /mydata/fstab

#### 移除磁盘
1. $ mdadm /dev/md0 -r /dev/两个丢失的磁盘
2. $ mdadm -D /dev/md0
	State: clean, degraded（降级状态）
	Layout: left-symmetric（左对称）

#### 添加磁盘
1. $ mdadm /dev/md0 -a /dev/sda?
2. $ mdadm -D /dev/md0
	State: clean, degraded, recovering

- 在添加磁盘成为空闲盘使用，做冗余磁盘

## 练习
1. 创建一个可用空间为10G的RAID0设备，要求其chunnk大小128k,文件系统为ext4，开机可自动挂载至/backup目录
2. 创建一个可用空间为10G的RAID10设备，要求其chunk大小为256k，文件系统为ext4，开机自动挂载至/my目录

## 磁盘损坏导致数据丢失，但备份数据不能少

# LVM
- **LVM**：Logical Volume Manager, Version: 2
- **dm模块**：device mapper，将一个或多个底层设备组织成一个逻辑设备的模块
- 设备文件：/dev/md-#

- LV(Logical Volume) 
	+ LE (Logic Extend)
- VG(Volume Group)包含
	+ PE(Physical extend)，默认4MB
- PV(physical Volume)，逻辑卷，多个分区

/dev/mapper/VG_NAME-LV_NAME 
	<-- /dev/VG_NAME/LV_NAME
/dev/mapper/vol0-root 
	<-- /dev/vol0/root
    <-- /dev/dm-0

## 创建步骤
1. create pv(pe)
2. create vg
3. create lv(le)

## LVM系统分区ID：**8e, Linux LVM**

## pvcreate：创建 pv
- `$ pvcreate /dev/DEVICE`
	+ `-v:verbose`
	+ `-f:force 覆盖数据`

## pvremove：移除pv
- `$ pvremove /dev/DEVICE`

## pvs,pvdisplay：查看pv
- `$ pvs /dev/DEVICE` 		简要显示信息
- `$ pvdisplay /dev/DEVICE` 详细显示信息
		
## 其他pv管理工具
- pvmove
- pvscan
- pvresize
- pvck
- pvchange

## vgs,vgdisplay: 查看vg
`$ vgs`
`$ vgdisplay [vgName]`

## vgcreate: 创建vg, 默认PE 4MB
`$ vgcreate -s #[kKmMgGtTpPeE] vgName /dev/DEVICE ...`

## vgremove: 移除vg
`$ vgremove -s #[kKmMgGtTpPeE] vgName /dev/DEVICE`

## vgextend: 扩展vg
`$ vgextend vgname /dev/DEVICES`

## vgreduce: 缩减vg
`$ pvmove /dev/DEVICE`			移动数据
`$ vgreduce vgname /dev/DEVICE` 后缩减vg

## lvs,lvdisplay: 查看lv
`$ lvs`
`$ lvdisplay [/dev/vg0/root]`
`$ lvdisplay [/dev/mapper/vg0-root]`

## lvcreate, 创建lv
`$ lvcreate -L #[mMgGtTpPeE] -n lvName vgName`
`$ lcreate -L 8G -n lv0 vg0`
`$ ls -l /dev/mapper/vg0-lv0 --> ../dm-0`

## lvremove，移除lv
`$ lvremove lvName vgName`

## lextend, 扩展lv
```
`$ lvextend -L +#[mMgGtT] /dev/vg0/lv0`
`$ lvextend -L +2G /dev/vg0/lv0`
+加多少
目标大小直接写大小
`$ umount /lvdata`
`$ mount /dev/vg0/lv0 /lvdata`
大小还是没有变化？
文件系统没有扩展，所以没有显示增加的大小
`$ resize2fs /dev/vg0/lv0` 扩展文件系统占用空间
`$ df -hl`
```

## 缩减逻辑卷
1. `# umount /dev/VG_NAME/LV_NAME`
2. `# e2fsck -f /dev/VG_NAME/LV_NAME` 文件系统强制检测
3. `# resize2fs /dev/VG_NAME/LV_NAME #[mMgGtT]` 缩减文件系统大小
4. `# lvreduce -L [-]#[mMgGtT] /dev/VG_NAME/LV_NAME`
5. `# mount`

#　快照：snapshot
- 访问原卷的路径
- 原卷发生变化时，把数据存储到快照卷上，然后修改原数据
- 目的：文件的另一个访问路径，与硬链接相似

## 创建快照,r只读
`# lvcreate -L sieze -p r -s -n snapshot_lv_name orginal_lv_name`
`# lvcreate -s -L 512M -n lv0-snap -p r /dev/vg0/lv0` 
`# mount /dev/vg0/lv0-snap /mnt`

## 删除快照：
`# umount /mnt`
`# lvremove /dev/vg0/lv0-snap`

## 练习：
1. 创建一个至少有两个PV组成的大小为20G的名为testvg的VG；要求PE大小为16MB，而后在卷组中创建大小为5G的逻辑卷testlv；挂载至/users目录
2. 新建用户archlinux，其家目录为/users/archlinux，而后su切换至archlinux用户，复制/etc/pam.d目录至自己的家目录
3. 扩展testlv至7G，要求archlinux用户的文件不能丢失
4. 收缩testlv至3G，要求archilnux用户的文件不能丢失
5. 对testlv创建快照，并尝试基于快照备份数据，验证快照的功能；


## BRTFS 文件系统
- BTRfs(B-tree, Butter FS, Better FS), GPL,2007年 Oracle, 支持CoW(写时复制)
- 支持大容量单文件
- 支持快照（累计快照），对文件快照
- 支持raid功能
- 子卷管理功能

### 核心特性
1. 多物理卷支持：btrfs可有多个底层物理卷组成；支持RAID,以联机”添加”、”移除”、“修改”
2. 写时复制更新机制(CoW)：复制、更新及替换指针，而非“就地”更新
3. 数据及元数据校验码：checksum,读取时通过校验码是否受损
4. 子卷：sub_volume
5. 快照：支持快照的快照
6. 透明压缩：保存时自动压缩，读取时接压缩

### mkfs.btrfs命令
`# btrfs --help`
`# man mkfs.btrfs`

- OPTIONS
	+ -L lablel
	+ -m, --metadata <type> 元数据是否跨越底层物理卷 	
		raid0, raid1, raid5, raid6, raid10,single, dup(冗余,热备份)
	+ -d, --data <profile> 数据是否跨设备存放
		raid0,raid1,raid5,raid6,raid10,single
	+ -O：features

### 查看特定命令, 列出支持的所有 features
`# mkfs.btrfs -O list-all`

### 关闭图形界面
`# systemctl set-default multi-user.target`

### 创建3个磁盘，并创建 BTRFS
> 不建议同一磁盘上使用raid，使用多块硬盘使用raid
`# fdisk -l`
`# mkfs.btrfs -L BTRDATA /dev/sdc /dev/sdd`

### 显示 btrfs 文件系统
`# man btrfs-filesystem 子命令`
`# btrfs filesystem show	--all-devices(默认)`
`# btrfs filesystem show	LABEL	`
`# btrfs filesystem show	/dev/sdc`
`# btrfs filesystem show	/dev/sdd`	

### Label: 'BTRDATA'
`# btrfs /dev/sdc`
`# btr /dev/sdd`
`/dev/sdc和/dev/sdd的UUID是一样，UUID_SUB不一样`

### 查看卷标名
`# btrfs filessytem label /dev/sdd`

### 挂载文件系统
`# mkdir /btrdata`
`# mount -t btrfs /dev/sdd /btrdata`

### 透明压缩机制：
`# mount -o compress={lzo|zlib} DEVICE MOUNT_POINT`

### 扩展/缩减设备空间大小：
`# btrfs filesystem resize +10G /btrdata`
`# btrfs filesystem resize -10G /btrdata`

### 查看
`# btrfs filesystem df /btrdata`

### 添加物理卷
`# btrfs device add|delete|scan|stat 挂载点`

### 均衡分摊：把已有数新增硬盘数据均衡操作
`# btrfs balance start /btrdata`
`# btrfs balance pause /btrdata`
`# Btrfs balance resume /btrdata`
`# btrfs balance cancle /btrdata`
`# btrfs balance status /btrdata`
 
`# btrfs balance start -mconvert=raid5 /btrdata`
 > m:metadata
- 磁盘不够时不能修改

## 创建子卷
`# man btrfs-subvolume`
`# btrfs subvolume <subcommand>`
`#　btrfs subvolum delete /btrdata/logs 删除子卷`
`#　btrfs subvolume list /btrdata 显示子卷列表`

###　创建子卷,生成子卷ID
`#　btrfs subvoluem create /btrdata/logs `
`#　btrfs subvoluem create /btrdata/cache`

### 挂载子卷：单独挂在子卷，父卷不能访问
`# umount /btrdata	卸载父卷`
`# mount -o subvol=logs /dev/sdc /mnt`
`# mount -o subvol=子卷ID /dev/sdc /mnt`
`# cp /etc/fstab `
`# btrfs subvolume show /mnt	详细子卷`

### 挂载父卷，子卷不能访问
`# umount /mnt`
`# mount /dev/sdc /btrdata`
`# ls /btrdata/logs`

`#　btrfs subvolume create /btrdata/data`
`# cp /etc/gruf.conf /btrdata/data`

### 快照必须在原卷中(/btrdata/data)，也就是同一个卷组中，父卷中
`# btrfs subvolume snapshot /btrdata/data /btrdata/data_snap 必须在父卷中`
`# btrfs subvolume list /btrdata`
`# cd /btrdata/data`
`# vim /btrdata/data/grub.conf`

### 添加 how are you?
`# cat grub2.conf`
`# btrfs subvolume delete /btrdata/data_snap`

### 单个文件快照：
`# cd /btrdata/data`
`# cp --reflink grub2.cfg grub2.cfg_snap 单独文件快照`
`# vim grub2.cfg`
> 修改内容

### ext文件系统转换成btrfs文件系统
`# btrfs balance start -dconvert=single /btrdata`
`# btrfs device delete /dev/sdd /btrdata`

`# fsck -f /dev/sdd1`
`# btrfs-conver /dev/sdd1` 
`# btrfs filesystem show`
`# btrfs-conver -r /dev/sdd1 (rollback)`