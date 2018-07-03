# RAID

> 多块硬盘按照某种组织格式形成一个硬盘使用

- Redundant Arrays of Inexpensive Disks 廉价磁盘冗余阵列
- Redundant Arrays of Independent Disks 独立磁盘冗余陈列
- Berkeley: A case for Redundent Arrays of Inexpensive Disks RAID

## RAID 作用

- 提高IO能力：磁盘并行读写（内置raid内存,额外供电防止断电导致数据丢失）
- 提高耐用性：磁盘冗余来实现
- 级别：多块磁盘组织在一起的工作方式有所不同

## RAID 实现方式

- 外接式磁盘阵列：通过扩展卡适配能力
- 内接式 RAID：主板集成 RAID 控制器
- Software RAID（生产环境不建议使用）
- BIOS: 外界式/内接式，安装 OS 之前配置好

## RAID Level (0-6) 混合类型

> 磁盘组织形式不同，0-7

### RAID-0

> RAID0，又叫条带卷，strip

- 若干个 chunk(raid内部自组织的块) 平均分散不同的磁盘上存储
- 磁盘上一块由若干个地址连接的磁盘块构成的大小固定的区域

- 读、写性能提升
- 可用空间：N*min(S1, S2, ...) = 10G, 20G, 30G => 10G, 10G, 10G
- 无容错能力
- 最少磁盘数：2, 2+

- 优点：提供 IO 并行
- 缺点：减低耐用性，任何一块硬盘损坏全部损毁（断电）
- 用途：非关键性数据，临时文件系统、交互数据等

### RAID-1

> RAID1, 又叫镜像卷，mirror

- 若干个 chunk 分别在存储
- 读性能提升：不同的磁盘上读取
- 写性能略有下降：同一个数据分别在不同的磁盘上
- 可用空间：1*min(S1, S2, ...)=10G,20G => 10G最少硬盘决定可用空间
- 有冗余能力
- 最少磁盘数：2, 2+

### RAID-4

> 至少三个磁盘，2个数据盘，1个校验盘

- 2个数据盘(RAID0)
- 1个校验盘(2个数据盘上的数据^运算结果)
- 例如：
  - 1101(第一个磁盘chunk)^0110(第二个磁盘chunk) => 1011(校验盘chunk)
  - 一个硬盘损坏，降级工作模式；及时更换硬盘
  - 有灯来指示是否损坏
  - 监控工具监听数据
  - 硬件接口 API
  - 校验盘盘压力非常大

- 使用热备份(备胎)
- 总结：性能差、有冗余能力

### RAID-5

> 校验码轮流放入不同的磁盘上

- 数据布局：左对称线
- 读、写性能提升
- 可用空间：(N-1)*min(S1,S2,S3,...)
- 磁盘容量：10G 20G 30G
- 实际使用容量：10G
- 有容错能力：1块磁盘
- 最少磁盘数：3, 3+

### RAID-6

> 2个校验盘、2个数据盘

- 读、写性能提升
- 可用空间：（N-2*min(S1,S2,...)
- 有容错能力：2块磁盘
- 最少磁盘数：4，4+

### RAID-10

- 先做1，后做0（从下往上）先镜像，后平均分块
- 读、写性能提升
- 可用空间：N*min(S1,S2,...)/2
- 有容错能力：每组镜像最多只能坏一块
- 最少磁盘数：4, 4+

### RAID-01（不常用）

- 先做0，后做1（从下往上）先分块，在镜像

### RAID-50

- 至少6个
- 最多只能坏一个

### RAID-7（某公司专有技术，文件系统）

- IO 能力非常好，价格昂贵

### JBOD

> Just a Bunch Of Disks

- 单个文件3.5T
- 4个每个1T
- 功能：将多块磁盘的空间合并一个大的连续空间使用
- 可用空间：sum(S1,S2,...)

常用级别：RAID-0, RAID-1, RAID-5, RAID-10, RAID-50， JBOD

## CentOS 6上的软件 RAID 的实现

> 结合内核中的**md模块**（Multi Deviced）

`mdadm` 命令与内核中进行通信，与系统调用通信

## mdadm 命令

> 模式化的工具，CentOS 6,7 之后 md 有变化

### 命令语法格式：`mdadm [mode] <raiddevice> [options] <component-devices>`

- raiddevice: `/dev/md#`
- component-devices：任意块设备，整个磁盘或分区
- 支持的 RAID 级别：LINER, RAID0，RAID1，RAID4， RAID5， RAID6， RAID10

### mdadm 模式

``` shell
创建：-C
装配：-A
监控：-F follow
管理：-f, -r, -a
```

### -C：创建模式

``` shell
-n #：使用#块设备来创建此 RAID
-l #：指明要创建的 RAID 的级别
-a {yes|no} 是否自动创建目标 RAID 设备的设备文件
-c CHUNK_SIZE：指明块大小，默认 512kb
-x #：指明空闲盘的个数；有冗余能力的；热备份，备胎

例如：创建一个 10G 可用空间的 RAID5
# fdisk /dev/sda{6,7,8,9}

# fidsk /dev/sda
n
+5G
n
+5G
n
+5G
n
+5G

设备类型：fd Linux raid auto
t
7
fd
t
8
fd
t
9
fd
t
10
fd
# partx -a /dev/sda
# partx -a /ev/sda
# fdisk /dev/sda

# cat /proc/mdstat
# ls /dev/ | grep "md"

磁盘3，空闲盘1， raid5
# mdsdm -C /dev/md0 -a yes -n 3 -x 1 -l 5 /dev/sda{7,8,9,10}
# cat /rpoc/mdstat
# mke2fs -t ext4 /dev/md0

# mkdir /mydata
# mount /dev/md0 /mydata
# mount
# df -lh
# blkid /dev/md0

md0 信息
# mdadm -D /dev/md0

搞坏磁盘(-f sda7 标记损坏)
# mdadm -f /dev/md0 /dev/sda7

# cat /proc/mdstat
# watch -n1 'cat /proc/mdstat'
# mdadm -D /dev/md0

# cp /etc/fstab /mydata/
# cd /mydata
# mdadm /dev/md0 -f /dev/sda8

# mdadm -D /dev/md0

移除
# mdadm /devmd0 -r /dev/sda7
# mdadm /dev/md0 -r /dev/sda8
# mdadm -D /dev/md0

# mdadm /dev/md0 -a /dev/sda7
# mdadm -D /dev/md0 正在修复操作


```

### -D：显示 raid 的详细信息

`$ mdadm -D /dev/md[0-9]+`

### 管理模式

``` shell
-f: 标记指定磁盘为损坏
-a：添加磁盘
-r：移动磁盘
```

### 观察 md 状态

``` shell
# cat /proc/mdstat
# watch -n1 'cat /proc/mdstat'
```

### 停止md设备：

`# mdadm -S /dev/md0`

#### 彻底删除raid设备文件

1. 卸载设备
2. 删除raid

``` shell
# mdadm /dev/md0 --fail /dev/sdb5 --remove /dev/sdb5
# mdadm /dev/md0 --fail /dev/sdb6 --remove /dev/sdb6
# mdadm /dev/md0 --fail /dev/sdb7 --remove /dev/sdb7
# mdadm /dev/md0 --fail /dev/sdb8 --remove /dev/sdb8
```

3. 停止运行raid

``` shell
# mdadm -S /dev/md0 停止
# mdadm --remove /dev/md0
# mdadm --misc --zero-superblock /dev/sdb5
# mdadm --misc --zero-superblock /dev/sdb6
# mdadm --misc --zero-superblock /dev/sdb7
# mdadm --misc --zero-superblock /dev/sdb8
```

- 先删除RAID中的所有设备，然后停止该RAID即可

- 为了防止系统启动时候启动raid

``` shell
# rm -f /etc/mdadm.conf
# rm -f /etc/raidtab
```

- 检查系统启动文件中是否还有其他mdad启动方式

``` shell
# vi /etc/rc.sysinit+/raid\c
```

### watch 命令

`watch options 'COMMAND'`

-n #：刷新间隔，单位是秒

`# watch -n1 'ifconfig eth0'`

#### 创建一个 10G 可用的 RAID5

> 3个5G或5个2.5G

- 磁盘个数越多浪费空间越小，当组织处理多
- 练习 10G 可用的 RAID5，还有一个冗余磁盘

``` shell
Raid 分区必须使用 System ID 为 fd

# cat /proc/mdstat 查看 md 设备
# ls -l /dev/ | grep md*`
# mdadm -C /dev/md0 -a yes -l 5 -x 1 -n 3 /dev/sdb{5,6,7,8}
# cat /proc/mdstat
# mke2fs -t ext /dev/md0
# mkdir /mydata
# mount /dev/md0 /mydata
# df -hl
# blkid /dev/md0

使用 UUID 或 LABEL 挂载到 /etc/fstab
# mdadm -D /dev/md0
```

#### 损坏磁盘：自动热备份

``` shell

标记为损坏
# mdadm /dev/md0 -f /dev/sdb5

每一秒钟刷新一次
# watch -n1 'cat /proc/mdstat'
# mdadm -D /dev/md0
```

#### 再次损坏磁盘

``` shell
# cat /etc/fstab /mydata
# mdadm /dev/md0 -f /dev/sdb7
# mdadm -D /dev/md0
# cat /mydata/fstab
```

#### 移除磁盘

``` shell
# mdadm /dev/md0 -r /dev/两个丢失的磁盘
# mdadm -D /dev/md0
  State: clean, degraded（降级状态）
  Layout: left-symmetric（左对称）
```

#### 添加磁盘

``` shell
# mdadm /dev/md0 -a /dev/sda
# mdadm -D /dev/md0
  State: clean, degraded, recovering
```

- 在添加磁盘成为空闲盘使用，做冗余磁盘

## 练习

1. 创建一个可用空间为10G的RAID0设备，要求其chunnk大小128k,文件系统为ext4，开机可自动挂载至/backup目录
2. 创建一个可用空间为10G的RAID10设备，要求其chunk大小为256k，文件系统为ext4，开机自动挂载至/my目录

## 磁盘损坏导致数据丢失，但备份数据不能少