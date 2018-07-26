# 进程管理

内核功用：文件系统、内存管理、进程管理、网络管理、驱动硬件、安全机制

> 运行于用户空间，执行用户进程
> 运行于内核空间，处于进程上下文，代表某个特定的进程执行
> 运行于内核空间，处于中断上下文，与任何进程无关，处理某个特定的中断
> 内核把进程的列表存放在叫做任务队列（task list）的双向循环链表中。链表中的每一顶都是类型为task_struct、称为进程描述符（process descriptor）的结构，该结构定义在`<linux/sched.h>`文件中。进程描述符中包含一个具体进程的所有信息

1. 《鸟哥的Linux私房菜-基础学习篇第三版》
2. 《Linux内核设计与实现》
3. 《深入理解Linux内核》
4. 《Linux设备驱动》(开发内核)
5. 《深入Linux内核架构》

## 允许同时存在进程最大数目

> 默认为32768（short int），可以增加到400万个。修改内核文件`/proc/sys/kernel/pid_max`提高上限

## 进程的5种状态

### TASK_RUNNING

> 进程可执行的；或者正在执行，或者在运行队列中正在等会执行；用户空间中执行的唯一可能的状态

### TASK_INTERRUPTIBLE

> 进程正在睡眠（被阻塞），等会某些条件的达成。一旦这些条件达成，内核就把进程设置为运行。可以提前接受信号而被唤醒并随时准备投入执行

### TASK_UNINTERRUPTIBLE

> 除了就算是接收到信号也不会被唤醒或准备投入运行外，这个状态与可打断状态相同。这个状态通常在进程必须在等待时不受干扰或等侍事件很快就会发生时出现。由于处于此状态的任务对信号不做响应，所以较之可中断状态，使用得较少

### __TASK_TRACES

> 被其他进程跟踪的进程，例如通过ptrace对调试程序进行跟踪

### __TASK_STOPPED

> 进程停止执行；进得没有投入运行也不能投入运行。通常这种状态发生在接收到SIGSTOP,SIGTSTP,SIGTTIN,SIGTTOU等信号的时候。此外，在调试期间接收到任何信号，都会使进程 进入这种状态

## Process: 运行中的程序的一个副本，存在生命周期

## Linux 内核进程信息的固定格式：task struck

- 多个任务的task struct组件的链表：task list

## 创建进程

### init进程

- 父子关系
- 进程：都由其父进程创建
  - fork(), clone() 系统调用
- CoW：写时复制
- 由父进程销毁子进程

### 进程优先级

- Kernel 2.6：0-139 固定优先级
- 140个队列，每个队列有2个队列(运行队列和过期队列)

- 实时优先级：1-99
  - 数值越大优先级越高

- 静态优先级：100-139
  - 数值越小优先级越高

- Nice：-19~20
  - 100~139对应-19~20
  - 管理员有权限调整 Nice 值
  - 普通用户有降级权限，没有升级权限

- 时间复杂度：Big O
- O(1), O(logn), O(n), O(n^）， O(2^n)
- 恒定、跳跃、线性(对角线)、直线上升

### 进程内存

- Page Frame(4k)：页框，用于存储页面数据
  - 线性地址(虚拟内存)与物理地址(物理内存)
  - 每个进程认为自己有3G空间
  - 最近最少使用：LRU
    - MMU：Memory Management Unit,内存管理单元(虚拟内存与物理内存交换数据)

### IPC

> Inter Process Communication 进程间通信

#### 同一主机上

- signal：发信号
- SHM: shared memory
- Semaphore：发起号(飞机)

#### 不同主机上

- RPC：Remote Procedure Call 远程过程调用
- Socket: 一段文件数据发送到另一端

## Linux内核：抢占式多任务

> 时间片上枪任务

## 进程类型

### 守护进程(daemon)

> 由内核引导过程中启动的进程,跟终端无关的进程

### 前台进程

> 跟**终端**相关，通过终端启动的进程

注意：可以把在前台启动的进程送往后台，以守护模式运行

## 进程状态

- 运行态：running(有数据，进程在CPU运行)
- 就绪态：ready(有数据，CPU没有调用进程)
- 睡眠态：
  - uninterruptable: 不可中断（必须睡，阻塞）
  - interruptable: 可中断（可以叫醒）
- 停止态：stopped（暂停与内存中，但不会被调度，除非手动启动它）
- 僵尸态：zambie (子进程完成任务，需要父进程销毁子进程。当父进程已经销毁，子进程仍然存在时，此时进程为zambie状态)

### 一次 IO 过程

> 某一进程加载数据在内存中没有时，于是请求内核把数据从磁盘加载到内核空间中的内存里（此进程睡眠），在从内核空间复制复制到用户空间的内存（数据没有加载时此进程为不可中断），以便进程访问。

调度到CPU上时间耗尽了，这个时候此进程为可中断状态

###　中断：Interrupt Request

> 指当出现需要时，CPU暂时停止当前程序的执行转而执行处理新情况的程序和执行过程

## 进程的分类

- CPU-Bound: CPU 密集型，非交互式进程（高清蓝光电影）
- IO-Bound: IO 密集型，交互式进程

> CPU-Bouand多分给CPU处理，但IO-Bound优先级高于CPU-Bound或者CPU—Bound优先级降低

- 多核，Thread（并行运行）
- 单核，Thread（CPU调度，切换上下文，单核线程没有效果）

## Linux系统上的查解及管理工具

`pstree`, `ps`, `pidof`, `pgrep`, `top`, `htop`, `glance`,`pmap`,`vmstat`,`dstat`,`kill`,`pkill`,`job`,`bg`,`fg`,`nohup`,`nice`,`renice`,`killall`

### CentOS 5

- SysV Init 程序
  - 缺陷：系统启动和引导时，它创建各个子进程，借助于shell完成的，因此执行脚本来完成，有可能使用上千个进程)

### CentOS 6

- upstart 程序
  - 启动很多命令来启动系统启动，并行启动多个服务)

### CentOS 7

- systemd
  - systemctl，由 systemd 控制
  - /sbin/init

### pstree

> display a tree of process
> 包命: psmisc

### ps

> report a snapshot of the current processes.（静态状态进程，包括线程信息）

`/proc/`: 内核中的状态信息

- 内核参数：
  - 可设置其值从而调整内核运行特性的参数；/proc/sys/
  - 状态变量：其用于输出内核中统计信息或状态信息，仅用于查看；
- 参数：模拟成文件系统类型；
- 进程

``` PID
/proc/#
  #: PID
```

- PID 1：init or systemd process id
- /proc/1/cmdline：启动进程命令行程序
- /proc/1/maps 内存映射，物理内存空间分配

`# cat proc/1/maps`

- *.so 共享库文件
- [heap] 堆内存
- [stack] 栈内存

`ps` 只查看当前bash环境进程

选项有三个风格：

1. UNIX options: 必须带着-
2. BSD: 必须不带-
3. GNU: 长格式，两个横杠

### 启动进程的方式

- 系统启动过程中自动启动：与终端无关的进程
- 用户通过终端启动：与终端相关的集成，交互式进程
  - 父进程终止时，子进程自动终止

### 常用选项

``` OPTIONS
a：所有与终端相关的进程
x: 所有与终端无关的进程
  PID
  TTY
  STAT
  TIME：累计CPU占用时间)
  COMMAND: [内核线程]
u: 终端登录的用户的所有进程
  USER 用户名
  PID  进程号
  %CPU 累计CPU时间比率
  %MEM 累计内存占用比率
  VSZ Virtual Memory Set，占用虚拟内存集
  RSS Resident Memory Set，常驻内存集
  TTY 终端设备
  STAT 进程状态
    R: Running进程运行中
    S: interruptable sleeping进程睡眠状态(idle),但可以被唤醒(signal)
    D: uninterruptable sleeing,不可唤醒睡眠状态，此进程可能在等待I/O
    T: Stopped,停止状态，可能在工作控制（后台暂停）或除错(traced)状态
    Z: Zombie

    +: 前台进程，终端命令
    l: 多线程集成

    N: 低优先级进程
    <: 高优先级进程

    s: session leader(bash,可以声明子集成管理的进程)
    L: 有记忆体分页分配并锁在记忆体内 (即时系统或捱A I/O)
    W: 没有足够的记忆体分页可分配

  START 该进程触发启动时间  
  TIME 运行时间
  COMMAND 命令

f: 完整格式，进程树
j：工作的格式(jobs format)
```

`#ps auxs`

### Unix 选项

``` options
-e：显示所有进程
-f：显示完整格式的进程信息
  C: pcpu, cpu utilization CPU占用百分比
  STIME: 启动时间
-l：详细格式显示进程信息，必须使用UNIX格式
-F：显示完整格式的进程信息
- PSR：运行于哪颗CPU之上 (0开始)
-H：层级结构显示进程的相关信息
-o：选择字段
  o  field1, field2,...：自定义显示的字段列表，以逗号分隔
  
常用字段：pid, ni, pri, psr, pcpu, stat, comm, tty, ppid, rtprio
  ni: nice值
  pri: priority，优先级
  rtprio：real time priority，实时优先级
```


### BSD

1. 常用组合之一

``` OPTIONS
aux：显示所有进程
auxf：以进程树方式显示所有进程
axfj：进程数格式显示所有进程列表
  PGID, TPGID
不能与u选项一起使用
```

### UNIX

2. 常用组合之二：`-ef`

3. 常用组合之三：`-eFH`

4. 常用组合之四：`-eo`, `axo`

``` OPTIONS
pid, ni, pri, psr, pcpu, stat, comm, tty, ppid, rtprio
```

5. UNIX

``` OPTIONS
-eHo
-efl:显示长格式的所有进程，显示PPID
-Al,-Af:另一种显示所有进程，显示PPID
```

### PID 顺序显示

``` OPTIONS
F UID PID PPID PRI NI ADDR VSZ SZ RSS WCHAN STAT TTY TIME COMMAND
F: flags进程标志位
4：进程权限为root
1：次进程仅可可进行复制(fork)而无法实际执行(exec)
UUID/PID/PPID：此进程被UID所拥有/进程号/此进程的父进程PID

PRI/NI：进程优先级
PRI：内核动态调整的，用户无法干涩PRI
NI：用户可以调整，范围是：-19～20
root：可以调整其值
普通用户：只能降级，不能升级
# nice -n number COMMAND 执行命令给与nice值
# renice number PID 重新调整NICE值

SZ：此进程用掉多少内存
VSZ：此进程用掉多少虚拟内存（KB），线性地址空间(1G内核使用，3G自己使用)
RSS：进程占用常驻（Resident Size，不能做交换内存使用）的内存量（KB）
ADDR：kernel function,该进程在内存的哪个部分，running的进程显示”-”
WCHAN：此进程是否运行，-表示此进程正在运行
TTY：登录这的终端位置，远程登录/pts/n，与终端无关则显示?
TIME：CPU运行此进程时间
START: 该进程触发启动时间
COMMAND：触发进程的命令
[内核线程]
```

## `pgrep` 命令

> 进程过滤命令

``` SHELL
pgrep [options] pattern
  -u uid：effective user，显示指定用户进程，可有其其他身份运行
  -U uid：read user，是哪个用户运行
  -t  TERMINAL：与指定的终端相关的进程
  -l：显示进程名
  -a：显示完整格式的进程名
  -P pid：显示此进程的子进程
# pgrep ssh
# pgrep http* -al
```

## `pidof` 命令

> 根据进程名获取PID

`# pidof ssh`

## `uptime` 命令

> **系统时间**,**运行时长**，**登录用户数**、**平均负载**：1min,5min,15min（**等待运行队列长度**）

### Load average

> 某分钟平均队列长度，CPU等待运行的进程队列长度，等待的进程太多
超出3个，应付不了队列集成。除了多核CPU，总数量不能大于CPU核数

## top 命令

> 显示按照某种顺序显示进程

- %Cpu(s)
  - 3.9 us(User Space)
  - 2.3 sy(System Space)
  - 0.0 ni(nice占用%)
  - 99.9 id(idle,空闲百分比)
  - 0.0 wa(wait，等待IO消耗的时间)
  - 0.0 hi(hardware interrupt，处理硬件中断%)
  - 0.0 si(软中断)
  - 0.0 cs(context switch,上下文切换)
  - 0.0 st(stoler，被虚拟化偷走的%)

- KiB Mem(物理内存):total, free, used, buff/cache
- KiB Swa(交换分区):total, free, used, avail Mem
  - Free Mem = free mem + buffer mem
  - VSZ, RSS, SHM

- PID USER PR NI VIRT PES SHR(shared memory) S %CPU %MEM TIME+(运行时长) COMMAND

### top 排序

- P: 默认占用CPU排序
- M: 占据Memory排序
- T: CPU占用累计时间TIME

### top 首部信息

- l: uptime信息
- t: tasks及CPU
- m: 内存信息
- 1: 按CPU每核心数显示
- q: 退出命令
- s: 修改刷新时间间隔
- k: 终止指定的进程

### top 选项

- -d #: 刷新时间间隔(duration)
- -b: 以批次方式显示
- -n: 显示多少批次

## `htop` 命令

> 包命

``` OPTIONS
Options
  -d # ：duration
  -u username
  -s COLUME:以指定字段进行排序
```

### 子命令

1. 显示选定的进程打开的文件：l
2. 跟踪选定的进程的系统调用：s
3. 以层级关系显示各进程状态：t
4. 将选定的进程绑定在某指定的CPU核心：a

``` SHELL
Task: 39用户空间进程，18thr； 1 running
a: set CPU affinity（进程绑定在某个CPU核心）
l: list oprn files with lsof，进程打开的文件
s: trace syscalls with strace，跟踪进程系统调用
```

## `vmstat` 命令

> Report virtual memory statistics

`vmstat [options] [delay [count]]`

``` OPTIONS
Options:
  -d:delay 刷新, -d 2 3 2秒刷新，第3次结束
  -s：内存统计数据
```

### procs

`r`: 等待运行的进程个数；CPU上实时等待运行的任务队列长度

### load overage

`b`: 处于不可中断睡眠态的进程个数；被阻塞的任务队列长度

### memory

- swpd: 交换内存的使用总量
- free: 空闲的物理内存总量
- buff: 用于数据缓冲的内存总量
- cache: 用户数据缓存的内存总量

### swap

- si: 数据进入swap的数据速率(kb/s)
- so: 数据离开swap的数据速率(kb/s)

### io:

- bi: 从块设备读入数据到系统的速率(kb/s)
- bo: 保存数据至块设备的速率(kb/s)

### system:

- in: interrupts，中断速率，每秒中断次数
- cs: context switch,进程上下文切换速率

### cpu:

- us: user space在CPU的占用的%
- sy: system
- id: idle
- wa: wait
- st: stolen

## `pmap` 命令

> 一个进程的内存映射表

``` SHELL
pmap [options] pid [...]
Options:
  -x：详细信息
```

### 另一种查看方式

``` SHELL
# cat /proc/1/maps
```

### 一个文件在不同的内存空间中

- [ anon ]:匿名页
- [ stack ]:栈
- [ heap ]：堆

``` MAP
00007ff771a41000     16K r-x-- libuuid.so.1.3.0
00007ff771a45000   2044K ----- libuuid.so.1.3.0
00007ff771c44000      4K r---- libuuid.so.1.3.0
00007ff771c45000      4K rw--- libuuid.so.1.3.0
```

## glances命令：python语言开发,支持c/s架构模式

``` SHELL
常用选项
  -b：以byte为单位显示网卡速率
  -d：关闭磁盘I/O模块
  -m：关闭mount模块
  -n：关闭network模块
  -t #：刷新时间间隔
  -1：每个CPU核心的相关数据单独显示
  -o {html | csv}：输出格式
  -f dir：输出文件的位置
# yum -y install python-jinja2`
# glances -o HTML -f /tmp/
```

### C/S模式下运行glances命令

- 服务模式: `# glances -s -B IPADDR` IPADDR：本机的某地址，用于监听

- 客户端模式: `# glances -c IPADDR` IPADDR: 是远程服务器的地址

## dstat命令

`# dstat 2 5`

- c，--cpu：cpu相关信息
  - C 0,3,total
- d:disk/total，磁盘相关数据平均值
  - D sda,sdb,total
- n: network
- m：memory
- g: paging
- r: io
- s: swap stats(used, free)
- p: process(ruanable,uninterruptible,new)
- y：system
- --ipc：进程间通信（message queue, semaphores, shared memory）
- --tcp
- --udp
- --raw：raw socket
- --socket

- --top-cpu 占用资源量较大的进程
- --top-io：最占用IO进程
- --top-mem：最占用内存的进程
- --top-lantency：延迟最大的进程

## kill命令

> 用于向进程发送信号，以实现对进程进行管理

### 显示当前系统可用的信号

``` SHELL
kill -l [signal]
```

### 每个信号的标识方法有三种

1. 信号的数据标识
2. 信号的完整名称
3. 信号的简写名称

### 向进程发送信号：

``` SHELL
kill [-s signal] [-SIGNAL] PID...

# ps auxf | grep httpd
# kill -s 15 3045
```

### 常用信号

1 SIGHUP：无需关闭进程进程而让其重读配置文件

``` SHELL
# kill -1 42333
# kill -HUP 42333
# kill -SIGHUP 42333
# kill -s SIGHUP 42333
```

2 SIGINT：终止正在运行的进程结束，相当于Ctrl+c(ping-> Ctrl+c）

9 SIGKILL：杀死运行中的进程,残暴杀害

15 SIGTERM：terminate，终止运行中的进程并删除进程（后台进程）；默认信号
优雅杀死

18 SIGCONT：继续(停止进程继续执行)

19 SIGSTOP：停止（送往后台进程）

### killall命令：关闭服务所有进程

``` SHELL
killall [-SIGNAL] program
```

## 作业控制

### Job:

- foreground前台作业：通过终端启动且启动后会一直占用终端
- background后台作业：通过终端启动，启动后转入后台运行（释放终端）

### 如何让作业运行后台？

1. 运行中的作业：`Ctrl+z`, 送往后台之后，作业会转换为**停止态**
2. 尚未启动的作业: `# COMMAND &`

注意：此类作业虽然被送往后台，但其依然与终端相关；如果希望把送往后台的作业剥离与终端的关系

`# nohup COMMAND &`

### 查看所有作业：`# jobs`

### 可实现作业控制的命令：

``` SHELL
# fg [[%]JOB_NUM]：指定的作业调回前台，+:默认，-:
# bg [[%]JOB_NUM]：让送往后台的作业在后台继续运行
# kill %JOB_NUM：终止指定的作业
```

> kill %不能省略，因为没有%的后面数字代表进程号

### 调整进程优先级：

> 通过Nice值调整的优先级范围：100-139，数字越小优先级越高

分别对应于：-20,19

### 进程启动时，其nice值得默认为0，其优先级是120

##　nice命令：

> 以指定的nice值启动并运行命令

``` SHELL
nice [OPTIONS] COMMAND [ARG]...
options
  -n NICE
# nice -n number COMMAND
```

注意：只有管理员可调低nice值

## renice命令

``` SELLL
# renice -n NICE PID
```

##　查看nice值和优先级

``` SHELL
# ps axo pid,ni,priority,comm
```

- sar,tsar,iostat,iftop,nethog命令

- 博客作业：htop/dstat/top/ps命令的使用

## 网络客户端工具：

ping/lftp/ftp/traceroute/wget等

### ping命令

>探测目标网络连通性

``` SHELL
ping [OPTIONS] destination
OPTIONS
  -c count：发送ping包个数
  -I interface：从哪个接口发送请求
   -W timeout：一次ping操作中，等待对方响应的超时时长
   -w second：ping命令超时时长(ping命令最多命令多长时间)
   -s 128：指定包大小

ICMP：Internet Control Message Protocol
echo request, type:8
echo reply, type:0
```

## hping命令

> package: hping3

`# yum list all | grep hping`

> send (almost) arbitrary TCP/IP packets to network hosts
> 发送TCP/IP 包到网络主机

``` SHELL
OPTIONS:
  --fast destination
  --faster destination
  -i u10000，一秒钟发送10个包
```

## traceroute命令

> 跟踪从源主机到目标主机之间经过的网关

``` SHELL
# traceroute www.lingyima.com
```

## ftp 命令

> file Transfer Protocol，文件传输协议

### ftp服务的命令行客户端工具

- get 下载一个文件
- mget 下载多个文件
- put 上传单个文件
- mput 上传多个文件
- delete 删除文件
- mdelete 删除多个文件

- bi：binary mode
- Ha: hash print message

## lftp命令

``` SHELL
# lftp -u username -p port[21，默认端口]
```

### 命令补全

- get,mget,put,mput,rm -r,mrm -r

### lftpget命令

``` SHELL
# lftpget URL 下载指明的URL
OPTIONS:
  -c：继续此前的下载
```

## wget命令

> 非交互式的网络下载工具
> 只能下载文件，不能下载目录

``` SHELL
# wget [OPTIONS] URL
OPTIONS:
  -O file URL
  -b,--background：后台进行下载操作(脚本中)
  -q,--quiet：静默，不显示下载进度
  -c,--continue：续传
  --progress=type(dot|bar)
  --limit-rate=amount:义指定的速率传输文件
```