# 操作系统-[沃尔特](https://www.wovert.com)

操作系统时有两个主要部分组成的：硬件和软件。硬件是计算机的物理设备。软件则是使得硬件能够正常工作的程序的集合。计算机软件分成两大类：操作系统和应用程序。应用程序使用计算机硬件来解决用户的问题。操作系统则控制用户对硬件访问。

## 操作系统发展史

- 手工处理
- 批处理
  - 联机批处理系统
  - 脱机批处理系统
- 分时处理系统
- 实时处理系统

Multi tasks(Bell, MIT, GE) => Multics

KenThompson: Space Travel

DEC: PDP-11, VAX(VMS系统)

PDP-7: 汇编语言

1969: Unics => Unix

Unix: 1971, nroff

1972: Unix, 10台

B：Dennis Ritch, C

《美国计算机通信》：1974,开发发布 Unix 1.0版本

AT&T: System v, 1979

1978， SCO公司包装发行Unix, C编译器

1980， Microsoft , Xenix(Unix)系统

### Berkeley

- Ken in Berkeley
- Student: Bill Joy
- Build **BSRG**
- 1977, BSRG distribution BSD(Berkeley System Distribution) 

### 1980, DARPA => 实现 TCP/IP 

本来 VMS 系统上实现（商业）

BSD 上实现

1983 => Unix in TCP/IP

### 1981, Microsoft, Bill Gate

SCP 公司 程序员研发小系统 QDOS(Quick and Dirty Operating System)

IBM 发售 PC 机

DOS 2.0 => CP/M

1990: Unix 开发环境

VMS 领导入职微软 => 开发 Windows NT(New Technolegy)

### SUN： Bill Joy

workstation： 非常复杂的任务

BSD 系统：Solaris

### Apple

Xerox: park(star图形界面)

卖给 乔布斯

Bill Gates复制park系统(上成代码) => Windows(蓝屏问题)

### 1985: Unix 商业化

一份拷贝4万美元

### MIT: Richard Stallman

GNU: GNU is Not Unix

GPL: General Pulibc License(freedom 自由软件)

FSF：Free Software Foundation

X-Window: GPL

gcc: GNU C Compiler

vi: Visual interface

Andrew: Minix, 4000+行

### System V(Bell Lab)

AIX(IBM)

Solaris(SUN->Oracle)

HP-UX(HP)

### BSD(Berkeley System Distribution), BSRG 组织研发

NetBSD

OpenBSD

FreeBSD

### System V vs BSD

- 1990, BSD 完全独立
  - Jolitz, BSD 移植到 X86, 商业化后，推出项目
  - 386-BSD
- 1991-8: Linus Torvalds 宣布成立 Linux
  - GPL
- Larry Wall => diff, patch

## 完整的OS

- Kernel + Application
- 狭义上的OS: Kernel
- GNU/Linux

## OS 的功能

- 驱动程序
- 进程管理
- 安全
- 网络协议栈
- 内存管理
- 文件系统

## GNU

- 源码：编译为二进制格式
- gcc, glibc, vi, linux
- Linux 发行版：数百种之多
  - RedHat
    - RedHat 9.0
    - RHEL: RedHat Enterprise Linux
    - CentOS: Community Enterprise OS
    - Fedora Core: 6个月
  - Debian
    - Ubuntu
      - Mint
    - Knopix
  - Slackware
    - S.u.S.E(Novel)
      - SLES: Suse Linux Enterprise System
    - OpenSUSE
  - Gentoo
  - ArchLinux

## 软件程序：版本号

- major(架构).minor(功能).release(bug)-compile time
  - major: 主版本号，有结构性变化才更改
  - minor: 次版本号，新增功能是才变化，一般奇数表示测试版，偶数表示开发板
  - release: 对次版本的修订次数或补丁包数
  - compile time: 编译次数

- Linux 0.99, 2.2, 2.4, 2.6
  - Linux 3.0, 3.2, 3.4
  - Linux 4.0, 4.3
  - el: Enterprise Linux
  - pp: 测试版
  - fc: fedora core
  - rc: 候选版本
  - x86_64: 64位
- GNU: vi, gcc

- 发行版有自己的版本号
  - RHEL: 5.x, 6.x, 7.x

  - Fedora 23
  - Debian: 8.x
  - OpenSuSE: 13.x

- GPL, BSD, Apache, MIT
- GPL: General Public License
  - copyright, copyleft
  - LGPL: Lessor GPL
  - GPLv2, GPLv3
  - FSF: Ree

- BSD:
- Apache: 不以原作者名义宣传代码
  - ASF: Apache Software Foundation

- 双线授权：
  - Community: 遵循开源协定
  - Enterprise: 商业授权，附加功能

- 程序管理
  - 程序组成部分
    - 二进制程序
    - 配置文件
    - 库文件
    - 帮助文件
  - X, Y, Z 程序包
  - 程序包管理器：X
    - 程序的组成文件打包成一个或有限几个文件
    - 安装
    - 卸载
    - 查询

- Debian: dpkg(.deb), apt-get
- RedHat: rpm, yum -> dnf
- S.u.S.E: rpm, zypper
- ArchLinux: port
- LFS: Linux From Scratch

## 什么是操作系统

> 操作系统是计算机硬件和用户（程序和人）的一个接口，它使得其他程序更加方便有效运行，并能方便地对计算机和软件资源进行访问。

操作系统是介于计算机硬件和用户（程序或人）之间的接口。

操作系统是一种用来使得其他程序更加方便有效运行的程序（或一个程序集）

操作系统是通用管理程序管理着计算机系统中每个部件的活动，并确保计算机系统中的硬件和软件资源能够更加有效地使用。当出现资源使用冲突时，操作系统应进行仲裁，排除冲突。

### 操作系统主要目标

1. 有效地使用硬件
2. 容易的使用资源

### 操作系统自举过程

> 操作系统本身也是程序，它也需要被装入内存和运行，这个困境如何解决呢？
如果使用ROM技术把操作系统存储（有制造商完成）在内存中，这个问题就能解决。CPU的程序计数器可以被设置为这个ROM的开始处。当计算机被加电（Power-on Self-Test, POST）时，CPU从ROM中读取指令，执行它们。但这种解决方案是非常低效的，因为内存的很大一部分需要由ROM构成，而不能被其他程序使用。
在内存中很小一部分是ROM构成，其中存有称为自举程序的小程序。当计算机被加电时，CPU计数器被设置为自举程序的第一条指令，并执行程序中的指令。这个程序唯一的职责就是把操作系统本身（需要启动计算机的那部分）装入RAM内存。当装入完成后，CPU中的程序计数器就被设置为RAM中操作系统的第一条指令，操作系统就被执行。

- 自举过程
1. 自举程序运行
2. 操作系统被载入
3. 操作系统运行

## 操作系统分类

批处理操作系统

批处理操作系统设计于20世纪50年代，目的是为了控制大型计算机。但是，计算机十分庞大。用穿孔卡片进行输入数据，用行式打印机输出结果，用磁带设备作为辅助存储介质。
每个运行的程序发出作业请求。穿孔卡有操作员送入计算机。如果程序运行成功，打印结果将传给程序员，如果不成功，则报错。

分时系统

为了有效使用计算机资源，多道程序的概念被引入。它可以将多个作业同时装入内存，并且仅当该资源可用时分配给需要他的作业。例如，当一个程序正使用输入/输出设备时，CPU则处于空闲状态，并可以供其他程序使用。
多道程序带来了分时的概念：资源可以被不同的作业分享。每个作业可以分到一段时间来使用资源。因为计算机裕兴速度很快，所以分时系统对用户是隐藏的，每个用户都感觉整个系统为自己服务。
最终利用分时技术的多道程序极大地改进了计算机的使用效率。但是，它们需要有一个更加复杂的操作系统，它必须可以调度：给不同的程序分配资源，并决定哪一个程序什么时候使用哪一种资源。用户也可以直接与系统进行交互，而不必通过操作员。一个新的属于不也随之产生：进程。一个作业是一个要运行的程序，一个进程则是在内存中等待分配资源的程序。

个人系统

并行系统

分布式系统

实时系统

### 常见操作系统产品

- 桌面版操作系统
  - Windows
  - Ubuntu
- 手机版操作系统
  - iso
  - Android
- 服务器操作系统
  - Windows
  - Linux
  - Unix

## Unix 操作系统

> UNIX是多用户、多道程序、可移植的操作系统，它被设计来方便编程、文本处理、通信。

### UNIX 简史

1965年，Bell Labs、GE(General Electric)和MIT合作的计划要建立一套multi-user、multi-processor、multi-level的MULTICS操作系统。后来工作进度太慢而被停了下来。

Ken Thompson有一个"Space Travel"的程序在GE-635的机器上跑，但是反应非常慢，正巧被他发现了一部被闲置的PDP-7，使用汇编语言将此程序移植到PDP-7上。

1971年，Ken Thompson申请到了一台PDP-11/24的机器。于是Unix第一版出来了。这台电脑只有24KB的物理内存和500K磁盘空间。Unix占用了12KB的内存，剩下的一半内存可以支持两用户进行Space Travel的游戏。

1973年，用汇编语言做移植太困难想用高级语言来完成第三版，开始尝试用Fortran，可是失败了。后来用BCPL的语言开发形成B语言，后来Dennis Ritchie觉得B语言还是不能满足要求，于是就改良了B语言为C语言。于是用C语言重写了Unix的第三版内核。

1974年7月的Unix第五版就以“仅用于教育目的”的协议，提供给各大学作为教学之用。

20世纪70年代，AT&T公司开始注意到Unix所带来的商业价值。公司的律师开始寻找一些手段来保护Unix，并让其成为一种商业机密。从1979年Unix System V7开始，Unix的许可证开始禁止大学使用Unix的源码，包括在授课中学习。

1978年，第一家以商业方式包装发行的Unix系统，SCO公司。卖第一个商用C编译器。

1981年，Microsoft公司成立，销售XENIC Unix。

SCP：QDOS(Quick and Dirty Operating System)

DOS 2.0 胜过CP/M

1990： 在Unix平台上开发各种程序
Ken Thompson在Berkeley大学的任教，Berkeley Bill Joy组织BSRG工作小组在1977年开发了BSD(Berkeley System Distribution)。

1980年，美国国防部高级研究计划署DARPA、TCP/IP（在VAX，VMS操作系统），1983年，在BSD结合正式使用TCP/IP。

1980年，两个最主要的Unix的版本线，一个是Berkeley的BSD UNIX，另一个是AT&T的Unix，在这个时候竞争最终引发了Unix的战争。

1982年，Bill Joy创建了Sun Microsystems公司，开发了Solaris OS。

AT&T则在随后的几年中发布了Unix System V的第一版

1990年，BSD与UNIX完全隔离

Apple公司：XEROX系统：PARK实验室（mouse, 以太网），star（图形界面）

### UNIX 结构

- 内核、命令解释器、一组标准工具、应用程序

### UNIX 特性

1. 多用户，多任务的分时操作系统。

2. UNIX的系统结构可分为三部分：操作系统内核（是UNIX系统核心管理和控制中心，在系统启动或常驻内存），系统调用（供程序开发者开发应用程序时调用系统组件，包括进程管理，文件管理，设备状态等），应用程序（包括各种开发工具，编译器，网络通讯处理程序等，所有应用程序都在Shell的管理和控制下为用户服务）。

3. UNIX系统大部分是由C语言编写的，这使得系统易读，易修改，易移植。

4. UNIX提供了丰富的，精心挑选的系统调用，整个系统的实现十分紧凑，简洁。

5. UNIX提供了功能强大的可编程的Shell语言（外壳语言）作为用户界面具有简洁，高效的特点。

6. UNIX系统采用树状目录结构，具有良好的安全性，保密性和可维护性。

7. UNIX系统采用进程对换（Swapping）的内存管理机制和请求调页的存储方式，实现了虚拟内存管理，大大提高了内存的使用效率。

8. UNIX系统提供多种通信机制，如：管道通信，软中断通信，消息通信，共享存储器通信，信号灯通信。

### UNNIX 标准

UNIX用户协会最早从20世纪80年代开始标准化工作，1984年颁布了试用标准。后来IEEE为此制定了POSIX标准（即IEEE1003标准）国际标准名称为ISO/IEC9945。它通过一组最小的功能定义了在UNIX操作系统和应用程序之间兼容的语言接口。POSIX是由Richard Stallman应IEEE的要求而提议的一个易于记忆的名称，含义是Portable Operating System Interface（可移植操作系统接口） ，而X表明其API的传承。

### UNIX 发行版

- SUN：Solaris, ultrasparc
  - OpenSolaris(PC)
- IBM: AIX, Powerpc
- HP: HP-UX, alpha
- BSD, AIX, HP-UX都是license有版权，付费才可使用。
- BSD：FreeBSD、OpenBSD(最安全)、NetBSD
- Unix：System V

## Linux 操作系统

Linux由芬兰赫尔辛基大学计算机系的林纳斯·托瓦兹（Linus Torvalds），根据荷兰一所大学Andrew 教授开发的Minix操作系统（便于不受AT&T许可协议的约束，为教学科研提供一个操作系统。免费给全世界的学生使用）具有较多UNⅨ的特点，但与UNⅨ不完全兼容。于是在1991年10月15日，Linus开发了基于POSIX和UNIX的多用户、多任务、支持多线程和支持多种平台的操作系统的一套完全免费使用的类Unix操作系统，即Linux内核。后来加入了GNU项目计划基于GPL开源协议，命名为GNU/Linux。其官网地址是http://kernel.org。

Linux组成由process management、timer、interrupt management、memory management、module management、VFS layer（接口）、file system、device driver、inter-process communication、network management、system init等操作系统功能的实现。

目前有许多基于Linux kernel开发的Linux发行版。常用的有RedHat系列(CentOS/Fedora)、Slackware(S.u.S.U)、Debain(Ubuntu、mint)、ArchLinux、Gentoo等主流发行版。

日常生活中的手机、平板电脑等系统使用的都是Linux系统。全世界的绝大多数超级计算机、股票交易、飞行航班控制系统、银行系统、国内BAT、谷歌、亚马逊和Facebook等互联网巨头都使用Linux来运行不同的网络和云服务等，而且甚至还运行着核潜艇系统。

Linux有不同的Linux版本，但都使用了Linux内核。Linux可安装在各种计算机硬件设备中，比如手机、平板电脑、路由器、视频游戏控制台、台式计算机、大型机和超级计算机。

Linux内核提供硬件抽象层、磁盘及文件系统控制、多任务等功能的系统软件。一个内核不是一套完整的操作系统。一套基于Linux内核的完整操作系统叫作Linux操作系统，或是GNU/Linux。设备驱动程序可以完全访问硬件。Linux内的设备驱动程序可以方便地以模块化（modularize）的形式设置，并在系统运行期间可直接装载或卸载。

- 预处理/编译/汇编/链接/执行
- 系统启动=内核+外壳
- 系统调用：任何只有内核才能执行的操作，通过接口的形式表现出来，这些接口称之为系统调用
- 库：把系统调用封装成更复杂的程序，以供别人使用，称之为库，又称重复造轮子
- so：Shared object共享对象
- DLL：Dynamic Link Libraries 动态链接库（windows）
- 总线的作用：将电气信号转换为数字信号
- 集成开发环境（IDE，Integrated Development Environment）：包括文本编写，gcc编译，库链接等
- 内核通过任务结构管理进程
- 进程：由父进程fork自身而来（由父进程申请，内核完成）

- 版本号

Linux内核使用三种不同的版本编号方式。
第一种方式用于1.0版本之前（包括1.0）。第一个版本是0.01，紧接着是0.02、0.03、0.10、0.11、0.12、0.95、0.96、0.97、0.98、0.99和之后的1.0。

第二种方式用于1.0之后到2.6，数字由三部分“A.B.C”，A代表主版本号，B代表次主版本号，C代表较小的末版本号。只有在内核发生很大变化时（历史上只发生过两次，1994年的1.0,1996年的2.0），A才变化。可以通过数字B来判断Linux是否稳定，偶数的B代表稳定版，奇数的B代表开发版。C代表一些bug修复，安全更新，新特性和驱动的次数。以版本2.4.0为例，2代表主版本号，4代表次版本号，0代表改动较小的末版本号。在版本号中，序号的第二位为偶数的版本表明这是一个可以使用的稳定版本，如2.2.5，而序号的第二位为奇数的版本一般有一些新的东西加入，是个不一定很稳定的测试版本，如2.3.1。这样稳定版本来源于上一个测试版升级版本号，而一个稳定版本发展到完全成熟后就不再发展。

第三种方式从2004年2.6.0版本开始，使用一种“time-based”的方式。3.0版本之前，是一种“A.B.C.D”的格式。七年里，前两个数字A.B即“2.6”保持不变，C随着新版本的发布而增加,D代表一些bug修复，安全更新，添加新特性和驱动的次数。3.0版本之后是“A.B.C”格式，B随着新版本的发布而增加,C代表一些bug修复，安全更新，新特性和驱动的次数。第三种方式中不再使用偶数代表稳定版，奇数代表开发版这样的命名方式。举个例子：3.7.0代表的不是开发版，而是稳定版！

### Linux 发展简史

Linux最早是由芬兰人Linus Torvalds设计的。当时由于UNⅨ的商业化，Andrew Tannebaum教授开发了Minix操作系统以便于不受AT&T许可协议的约束，为教学科研提供一个操作系统。当时发布在Internet上，免费给全世界的学生使用。Minix具有较多UNⅨ的特点，但与UNⅨ不完全兼容。1991年10月5日，Linus为了给Minix用户设计一个比较有效的UNⅨ PC版本，自己动手写了一个“类Minix”的操作系统。整个故事从两个在终端上打印AAAA...和BBBB...的进程开始的，当时最初的内核版本是0.02。Linus Torvalds将它发到了Minix新闻组，很快就得到了反应。Linus Torvalds在这种简单的任务切换机制上进行扩展，并在很多热心支持者的帮助下开发和推出了Linux的第一个稳定的工作版本。1991年11月，Linux0.10版本推出，0.11版本随后在1991年12月推出，当时将它发布在Internet上，免费供人们使用。当Linux非常接近于一种可靠的/稳定的系统时，Linus决定将0.13版本称为0.95版本。1994年3月，正式的Linux 1.0出现了，这差不多是一种正式的独立宣言。截至那时为止，它的用户基数已经发展得很大，而且Linux的核心开发队伍也建立起来了。

Linux 操作系统的诞生、发展和成长过程始终依赖着五个重要支柱：UNIX操作系统、MINIX操作系统、GNU计划、POSIX标准和Internet网络。

1987年，荷兰阿姆斯特丹的Vrije大学计算机科学系的Andrew教授编写Minix系统用于教学用途。全部的程序码共约12,000行。

1991年的10月5日，林纳斯·托瓦兹正式向外宣布Linux内核的诞生

1993年，发布了Linux 0.99，代码大约有十万行，用户大约有10万左右。

1994年3月，Linux1.0发布，代码量17万行，当时是按照完全自由免费的协议发布，随后正式采用GPL协议。

1995年1月，Bob Young创办了RedHat，以GNU/Linux为核心，集成了400多个源代码开放的程序模块，搞出了一种冠以品牌的Linux，即RedHat Linux,称为Linux发行版，在市场上出售。这在经营模式上是一种创举。

1996年6月，Linux 2.0内核发布，此内核有大约40万行代码，并可以支持多个处理器。此时的Linux 已经进入了实用阶段，全球大约有350万人使用。

1998年2月，以Eric Raymond为首的一批年轻的"老牛羚骨干分子"终于认识到GNU/Linux体系的产业化道路的本质，并非是什么自由哲学，而是市场竞争的驱动，创办了"Open Source Intiative"（开放源代码促进会）"复兴"的大旗，在互联网世界里展开了一场历史性的Linux产业化运动。

2001年1月，Linux 2.4发布，它进一步地提升了SMP系统的扩展性，同时它也集成了很多用于支持桌面系统的特性：USB，PC卡（PCMCIA）的支持，内置的即插即用，等等功能。

2003年12月，Linux 2.6版内核发布

Larray Wall: diff, patch（协同开发工具）

### GNU/Linux

GNU是“GNU is Not Unix”的递归缩写，Richard Stallman在1983年9月27日公开发起创建一套完全自由的操作系统。UNIX是一种广泛使用的商业操作系统的名称。由于GNU将要实现UNIX系统的接口标准，因此GNU计划可以分别开发不同的操作系统部件。GNU计划采用了部分当时已经可自由使用的软件，例如TeX排版系统、X Window视窗系统, GCC编译器、Emac和nano文本编辑器等。

FSF: (Free Software Foundation，自由软件基金会）1985年Richard Stallman创立了来为GNU计划提供技术、法律以及财政支持。

自由软件是什么？“自由软件”是权利问题，不是价格问题。要理解这个概念，自由应该是“言论自由”中的“自由”，而不是“免费啤酒”中的“免费”。自由软件关乎使用者运行、复制、发布、研究、修改和改进该软件的自由。

- 自由软件自由赋予软件使用者四种自由：
  - 不论目的为何，有运行该软件的自由。
  - 有研究该软件如何运行，以及按需改写该软件的自由。取得该软件的源代码为达成此目的之前提。
  - 有重新发布拷贝的自由。
  - 有改进该软件，以及向公众发布改进的自由，这样这个社群都可受惠。取得该软件源码为达成此目的之前提。

- 自由：freedom, 免费：free
- Free含义：
  - Free use；
  - Free study and modify；
  - Free distribute;
  - Free create derivative；

#### GNU通用公共许可协议（GNU General Public License，简称：GNU GPL、GPL）

自由软件许可协议条款，保证终端用户有使用、学习、修改、发布和重新发布自由软件的源代码。

- GPL协定授予程序接受人以下权利，或称“自由”，或称“copyleft”：
  - 以任何目的运行此程序的自由；
  - 再发行复制件的自由；
  - 改进此程序，并公开发布改进的自由；

#### GPL 开源许可协议最大的 4 个特点

- 允许把软件复制到任何人的电脑中，并且不限制复制的数量。
- 允许软件以各种形式进行传播。
- 允许在各种媒介上出售该软件，但必须提前让买家知道这个软件是可以免费获得的；因此，一般来讲，开源软件都是通过为用户提供有偿服务的形式来盈利的。
- 允许开发人员增加或删除软件的功能，但软件修改后必须依然基于GPL 许可协议授权。

#### GPL与BSD比较

主要区别就在于GPL程序的演绎作品也要在 GPL之下（LGPL：可以库调用打包成自己的可以卖）。相反，BSD 许可证并不禁止演绎作品变成专有软件（修改 BSD 的一部分代码，然后打包封装之后自己开发的没问题。不要保留别的的公司的商标和版权声明）。

GPLv1

发布于1989年一月，其目的是防止那些阻碍自由软件的行为，而这些阻碍软件开源的行为主要有两种（一种是软件发布者只发布可执行的二进制代码而不发布具体源代码，一种是软件发布者在软件许可加入限制性条款）。因此按照 GPLv1，如果发布了可执行的二进制代码，就必须同时发布可读的源代码，并且在发布任何基于GPL许可的软件时，不能添加任何限制性的条款。

GPLv2

为了保障和尊重其它一些人的自由和权益，如果哪个人在发布源于GPL的软件的时候，同时添加强制的条款（在一些国家里，只能以二进制代码的形式发布软件，以保护开发软件者的版权），那么他将根本无权发布该软件。

1991年6月发布 GPL 的第二个版本同时第二个许可证程序库 GNU 通用公共许可证（LGPL, Library General Public License）也被发布出来并且一开始就将其版本定为第2版本以表示其和 GPLv2 的互补性。这个版本一直延续到 1999年，并分支出一个派生的 LGPL 版本号为2.1，并将其重命名为轻量级通用公共许可证（又称宽通用公共许可证，Lesser General Public License）

GPLv3

2005年，GPL 版本3正由斯托曼起草。在所有的改动中，最重要的四个是：

1. 解决软件专利问题；
2. 与其他许可证的兼容性；
3. 源代码分区和组成的定义；
4. 解决数位版权管理问题；

2007年6月29日，自由软件基金会正式发布了GPL第3版。
但是Linux社区的领导者林纳斯·托瓦兹等人决定不让Linux使用GPLv3授权，仍然使用GPLv2授权。

BSD 许可证

BSD 许可证原先是用在加州大学柏克利分校发表的各个4.4BSD/4.4BSD-Lite版本上面（BSD是Berkly Software Distribution的简写）的，后来也就逐渐沿用下来。1979年加州大学伯克利分校发布了BSD Unix，被称为开放源代码的先驱，BSD许可证就是随着BSD Unix发展起来的。BSD 许可证现在被Apache和BSD操作系统等开源软件所采纳。

#### Apache

Apache许可证(Apache License)，是一个在Apache软件基金会发布的自由软件许可证，最初为Apache http服务器而撰写。Apache许可证要求被授权者保留版权和放弃权利的申明，但它不是一个反版权的许可证。

与 GPL 的兼容

Apache 软件基金会与自由软件基金会都同意Apache许可证属于自由软件许可证，且兼容于第三版的GNU通用公共许可证  ；第一版与第二版的GNU通用公共许可证并不兼容于Apache许可证。

五种开源协议的比较(BSD，Apache，GPL，LGPL，MIT)

BSD开源协议（original BSD license、FreeBSD license、
Original BSD license）

BSD开源协议是使用者可以自由的使用，修改源代码，也可以将修改后的代码作为开源或者专有软件再发布。

#### 当发布使用了BSD协议的代码，或则以BSD协议代码为基础做二次开发自己的产品时，需要满足三个条件：

1. 如果再发布的产品中包含源代码，则在源代码中必须带有原来代码中的BSD协议。

2. 如果再发布的只是二进制类库或软件，则需要在类库或软件的文档和版权声明中包含原来代码中的BSD协议。

3. 可以用开源代码的作者或者机构名字和原来产品的名字做市场推广。

BSD 代码鼓励代码共享，但需要尊重代码作者的著作权。BSD由于允许使用者修改和重新发布代码，也允许使用或在BSD代码上开发商业软件发布和销售，因此是对商业集成很友好的协议。而很多的公司企业在选用开源产品的时候都首选BSD协议，因为可以完全控制这些第三方的代码，在必要的时候可以修改或者二次开发。

#### Apache Licence 2.0（Apache License, Version 2.0、Apache License, Version 1.1、Apache License, Version 1.0）

ASF: Apache Software Foundation(Hadoop, spark)

许可的同时，允许用户拥有修改代码及再发布的自由。该许可协议适用于商业软件，现
在热门的 Hadoop、Apache HTTP Server、MongoDB 等项目都是基于该许可协议研发的

著名的非盈利开源组织Apache采用的协议。该协议鼓励代码共享和尊重原作者的著作权，同样允许代码修改，再发布（作为开源或商业软件）。需要满足的条件也和BSD类似：

1. 需要给代码的用户一份Apache Licence
2. 如果你修改了代码，需要再被修改的文件中说明。
3. 在延伸的代码中（修改和有源代码衍生的代码中）需要带有原来代码中的协议，商标，专利声明和其他原来作者规定需要包含的说明。
4. 如果再发布的产品中包含一个Notice文件，则在Notice文件中需要带有Apache Licence。你可以在Notice中增加自己的许可，但不可以表现为对Apache Licence构成更改。

Apache Licence也是对商业应用友好的许可。使用者也可以在需要的时候修改代码来满足需要并作为开源或商业产品发布/销售。

GPL（GNU General Public License）
我们很熟悉的Linux就是采用了GPL。GPL协议和BSD, Apache Licence等鼓励代码重用的许可很不一样。GPL的出发点是代码的开源/免费使用和引用/修改/衍生代码的开源/免费使用，但不允许修改后和衍生的代码做为闭源的商业软件发布和销售。这也就是为什么我们能用免费的各种linux，包括商业公司的linux和linux上各种各样的由个人，组织，以及商业软件公司开发的免费软件了。

GPL协议的主要内容是只要在一个软件中使用(“使用”指类库引用，修改后的代码或者衍生代码)GPL 协议的产品，则该软件产品必须也采用GPL协议，既必须也是开源和免费。这就是所谓的”传染性”。GPL协议的产品作为一个单独的产品使用没有任何问题，还可以享受免费的优势。
由于GPL严格要求使用了GPL类库的软件产品必须使用GPL协议，对于使用GPL协议的开源代码，商业软件或者对代码有保密要求的部门就不适合集成/采用作为类库和二次开发的基础。

其它细节如再发布的时候需要伴随GPL协议等和BSD/Apache等类似。

LGPL（GNU Lesser General Public License）
LGPL是GPL的一个为主要为类库使用设计的开源协议。和GPL要求任何使用/修改/衍生之GPL类库的的软件必须采用GPL协议不同。LGPL允许商业软件通过类库引用(link)方式使用LGPL类库而不需要开源商业软件的代码。这使得采用LGPL协议的开源代码可以被商业软件作为类库引用并发布和销售。
但是如果修改LGPL协议的代码或者衍生，则所有修改的代码，涉及修改部分的额外代码和衍生的代码都必须采用LGPL协议。因此LGPL协议的开源代码很适合作为第三方类库被商业软件引用，但不适合希望以LGPL协议代码为基础，通过修改和衍生的方式做二次开发的商业软件采用。

GPL/LGPL都保障原作者的知识产权，避免有人利用开源代码复制并开发类似的产品

**MPL(Mozilla Public License, Mozilla公共许可)许可协议** 相较于 GPL 许可协议，MPL 更加注重对开发者的源代码需求和收益之间的平衡。

**MIT（Massachusetts Institute of Technology)许可协议** 目前限制最少的开源许可协
议之一，只要程序的开发者在修改后的源代码中保留原作者的许可信息即可，因此普
遍被商业软件所使用。

MIT是和BSD一样宽范的许可协议,作者只想保留版权,而无任何其他了限制.也就是说,你必须在你的发行版里包含原许可协议的声明,无论你是以二进制发布的还是以源代码发布的.

### 为什么学习Linux

早在 20 世纪 70 年代，UNIX 系统是开源而且免费的。但是在 1979 年时，AT&T 公司宣
布了对 UNIX 系统的商业化计划，随之开源软件业转变成了版权式软件产业，源代码被当作
商业机密，成为专利产品，人们再也不能自由地享受科技成果。

于是在 1984 年，Richard Stallman 面对于如此封闭的软件创作环境，发起了 GNU 源代码
开放计划并制定了著名的 GPL 许可协议。1987 年时，GNU 计划获得了一项重大突破 — gcc
编译器发布，这使得程序员可以基于该编译器编写出属于自己的开源软件。随之，在 1991 年
10 月，芬兰赫尔辛基大学的在校生 Linus Torvalds 编写了一款名为 Linux 的操作系统。该系统因其较高的代码质量且基于 GNU GPL 许可协议的开放源代码特性，迅速得到了 GNU 计划和
一大批黑客程序员的支持。随后 Linux 系统便进入了如火如荼的发展阶段。

1994 年 1 月，Bob Young 在 Linux 系统内核的基础之上，集成了众多的源代码和程序软
件，发布了红帽系统并开始出售技术服务，这进一步推动了 Linux 系统的普及。1998 年以后，
随着 GNU 源代码开放计划和 Linux 系统的继续火热，以 IBM 和 Intel 为首的多家 IT 企业巨头开始大力推动开放源代码软件的发展。到了 2017 年年底，Linux 内核已经发展到了4.13 版本，并且 Linux 系统版本也有数百个之多，但它们依然都使用 Linus Torvalds 开发、维护的Linux 系统内核。RedHat 公司也成为了开源行业及 Linux 系统的带头公司。

开源的操作系统少说有 100 个，开源的软件至少也有十万个，为什么不去逐个学习？所以上面谈到的开源特性只是一部分优势，并不足以成为您付出精力去努力学习的理由。

对于用户来讲，开源精神仅具备锦上添花的效果，因此正确的学习动力应该源自于：Linux
系统是一款优秀的软件产品，具有类似 UNIX 的程序界面，而且继承了 UNIX 的稳定性，能
够较好地满足工作需求。

大多数读者应该都是从微软的 Windows 系统开始了解计算机和网络的，因此肯定会有这
样的想法“Windows 系统很好用啊，而且也可足以满足日常工作需求呀”。客观来讲，Windows
系统确实很优秀，但是在安全性、高可用性与高性能方面却难以让人满意。

为什么要在需要长期稳定运行的网站服务器上、在处理大数
据的集群系统中以及需要协同工作的环境中采用 Linux 系统了。通过下图也可以看出 Linux 系
统相较于 Windows 系统的具体优势

### Linux 特性

可移植性

尽管Linus Torvalds的初衷不是使Linux成为一个可移植的操作系统，今天的Linux却是全球被最广泛移植的操作系统内核。从掌上电脑iPad到巨型电脑IBM S/390，甚至于微软出品的游戏机XBOX都可以看到Linux内核的踪迹。Linux也是IBM超级计算机Blue Gene的操作系统。

- Linux可以在以下CPU架构上运行：
  - X86,x64, amd64(CISC)
  - m6800, m68k摩托罗拉
  - ARM系列(移动终端设备、功耗相对低，三星、华为、高通）
  - SPARC和UltraSPARC：太阳微系统的工作站, solaris
  - Power(IBM, aix, RISC指令集)
  - PowerPC,ppc：(简装版的Power)所有较新的苹果电脑
  - 康柏：Alpha， hp-ux
  - MIPS
  - 惠普：PA-RISC
  - 索尼公司: PlayStation 2
  - 微软公司: Xbox
  - Hitachi SuperH: SEGA Dreamcast
  - Acorn：Archimedes,A5000和RiscPC系列

网络支持

作为一个生产操作系统和开源软件，Linux 是测试新协议及其增强的良好平台。Linux 支持大量网络协议，包括典型的 TCP/IP，以及高速网络的扩展（大于 1 Gigabit Ethernet [GbE] 和 10 GbE）。Linux 也可以支持诸如流控制传输协议（SCTP）之类的协议，它提供了很多比 TCP 更高级的特性（是传输层协议的接替者）。

动态内核

Linux 还是一个动态内核，支持动态添加或删除软件组件。被称为动态可加载内核模块，它们可以在引导时根据需要（当前特定设备需要这个模块）或在任何时候由用户插入。

系统管理程序

Linux 最新的一个增强是可以用作其他操作系统的操作系统（称为系统管理程序）。该系统对内核进行了修改，称为基于内核的虚拟机（KVM）。这个修改为用户空间启用了一个新的接口，它可以允许其他操作系统在启用了 KVM 的内核之上运行。除了运行 Linux 的其他实例之外， Microsoft&reg; Windows&reg; 也可以进行虚拟化。惟一的限制是底层处理器必须支持新的虚拟化指令

### Linux 子系统

系统调用接口

SCI 层提供了某些机制执行从用户空间到内核的函数调用。正如前面讨论的一样，这个接口依赖于体系结构，甚至在相同的处理器家族内也是如此。SCI 实际上是一个非常有用的函数调用多路复用和多路分解服务。在 ./linux/kernel 中您可以找到 SCI 的实现，并在 ./linux/arch 中找到依赖于体系结构的部分。

进程管理

进程管理的重点是进程的执行。在内核中，这些进程称为线程，代表了单独的处理器虚拟化（线程代码、数据、堆栈和 CPU寄存器）。在用户空间，通常使用进程 这个术语，不过 Linux 实现并没有区分这两个概念（进程和线程）。内核通过 SCI 提供了一个应用程序编程接口（API）来创建一个新进程（fork、exec 或 Portable Operating System Interface [POSⅨ] 函数），停止进程（kill、exit），并在它们之间进行通信和同步（signal 或者 POSⅨ 机制）。
进程管理还包括处理活动进程之间共享 CPU 的需求。内核实现了一种新型的调度算法，不管有多少个线程在竞争 CPU，这种算法都可以在固定时间内进行操作。这种算法就称为 O⑴ 调度程序，这个名字就表示它调度多个线程所使用的时间和调度一个线程所使用的时间是相同的。O⑴ 调度程序也可以支持多处理器（称为对称多处理器或 SMP）。您可以在 ./linux/kernel 中找到进程管理的源代码，在 ./linux/arch 中可以找到依赖于体系结构的源代码。

内存管理

内核所管理的另外一个重要资源是内存。为了提高效率，如果由硬件管理虚拟内存，内存是按照所谓的内存页 方式进行管理的（对于大部分体系结构来说都是 4KB）。Linux 包括了管理可用内存的方式，以及物理和虚拟映射所使用的硬件机制。
不过内存管理要管理的可不止 4KB缓冲区。Linux 提供了对 4KB缓冲区的抽象，例如 slab 分配器。这种内存管理模式使用 4KB缓冲区为基数，然后从中分配结构，并跟踪内存页使用情况，比如哪些内存页是满的，哪些页面没有完全使用，哪些页面为空。这样就允许该模式根据系统需要来动态调整内存使用。
为了支持多个用户使用内存，有时会出现可用内存被消耗光的情况。由于这个原因，页面可以移出内存并放入磁盘中。这个过程称为交换，因为页面会被从内存交换到硬盘上。内存管理的源代码可以在 ./linux/mm 中找到

虚拟文件系统

虚拟文件系统（VFS）是 Linux 内核中非常有用的一个方面，因为它为文件系统提供了一个通用的接口抽象。VFS 在 SCI 和内核所支持的文件系统之间提供了一个交换层。
VFS 在用户和文件系统之间提供了一个交换层
在 VFS 上面，是对诸如 open、close、read 和 write 之类的函数的一个通用 API 抽象。在 VFS 下面是文件系统抽象，它定义了上层函数的实现方式。它们是给定文件系统（超过 50 个）的插件。文件系统的源代码可以在 ./linux/fs 中找到。
文件系统层之下是缓冲区缓存，它为文件系统层提供了一个通用函数集（与具体文件系统无关）。这个缓存层通过将数据保留一段时间（或者随即预先读取数据以便在需要是就可用）优化了对物理设备的访问。缓冲区缓存之下是设备驱动程序，它实现了特定物理设备的接口。

### Linux 版本号

什么Linux发行版？

> 由 GNU 项目提供的 Linux 内核 GNU/Linux 源代码、各个商业发行商开发的各种应用程序源代码和可安装操作系统的程序源代码编译成不同平台架构的完整的操作系统程序进行打包发行，提供给用户。

在介绍常见的 Linux 系统版本之前，首先需要区分 Linux 系统内核与 Linux 发行套件系
统的不同

- Linux 系统内核指的是一个由 Linus Torvalds 负责维护，提供硬件抽象层、硬盘及文件系统控制及多任务功能的系统核心程序。
- Linux 发行套件系统是我们常说的 Linux 操作系统，也即是由 Linux 内核与各种常用软件的集合产品

- 开源收入来源？
1. 双线授权：

Community：遵循开源授权

Enterprise：商业授权(付费)，额外功能,买服务(提供bug编译代码之后提供，如RedHat)

2. 捐赠：自由捐赠

- 版本
  - Alpha：内测版
  - Beta：公测版
  - Mainline：主线
  - rc：Release Candidate,候选版（准备发行正式版）
  - Stable：稳定版
  - Longterm：长期维护版

major.minor.release主版本(架构).次版本(功能).发行号(bug) 0.99, 2.0, 2.4, 2.6, 3.0, 4.0

- Linux kernel 版本号：
  - 1.3 系列的开发板稳定在 2.0
  - 2.5 稳定在 2.6
  - 主版本号.从版本号.修订版本号.稳定版本号
  - 修订版：BUG修复、新的驱动、新特性

### Linux 发行版

- RHEL：5.x, 6.x, 7.x
- Fedora 23
- Debian: 8.x
- OpeSuSE: 13.x

- Linux操作系统 = kernel + 系统软件 + 应用软件（系统版本，内核版本）
- Linux发行版：slackware, Redhat, Debian, Fedora, TurboLinux, Mandrake, SUSE, CentOS, Ubunte, 红旗（挂），麒麟

#### 主流Linux发行版

全球大约有数百款的 Linux 系统版本，每个系统版本都有自己的特性和目标人群，下面
将可以从用户的角度选出最热门的几款进行介绍

- 红包企业版 Linux(RedHat Enerprise Linux, RHEL)
  - 自由但不免费，提供源代码，不提供编译后的代码。
  - 红帽公司是全球最大的开源技术厂商，RHEL 是全世界内使用最广泛的 Linux 系统。RHEL 系统具有极强的性能与稳定性，并且在全球范围内拥有完善的技术支持。RHEL 系统也是本书、红帽认证以及众多生产环境中使用的系统。

- 社区企业操作系统（Community Enterprise Operating System, CentOS）
  - 通过把 RHEL 系统重新编译并发布给用户免费使用的 Linux 系统，具有广泛的使用人群。CentOS 当前已被红帽公司“收编”

- Fedora Core: 由红帽公司发布的桌面版系统套件（目前已经不限于桌面版）。用户可免费体验到最新的技术或工具，这些技术或工具在成熟后会被加入到 RHEL 系统中，因此 Fedora 也称为 RHEL系统的“试验田”。运维人员如果想时刻保持自己的技术领先，就应该多关注此类 Linux 系统的发展变化及新特性，不断改变自己的学习方向。每6月发行一次，新技术、新功能用于RedHat测试版或预发布版
  - Debian (.deb包命)：社区办，没有商业公司支持；8.x版本
    - 稳定性、安全性强，提供了免费的基础支持，可以良好地支持各种硬件架构，以及提供近十万种不同的开源软件，在国外拥有很高的认可度和使用率
    - dpkg包管理器
    - apt-get前段工具
  - Ubuntu：是一款派生自 Debian 的操作系统，对新款硬件具有极强的兼容能力。Ubuntu 与 Fedora 都是极其出色的 Linux 桌面系统，而且 Ubuntu 也可用于服务器领域
    - mint(笔记本)
    - knopix(安全)

- rpm包管理器
  - yum前段工具(事务有问题) =>dnf(参考zypper)
  - CentOS redhat商标和版权去掉，重新编译生成。CentOS已经被RedHat收购。

- Slackware
  - S.u.S.E 数据库高级服务和电子邮件网络应用的用户，商业公司支持（Novell）S.u.S.U: rpm包管理器
    - zypper前段工具
  - SLES
  - OpenSUSE(13.x版本)
    - 源自德国的一款著名的 Linux 系统，在全球范围内有着不错的声誉及市场占有率

- ArchLinux
  - 使用简单、系统轻量、软件更新速度快的GNU/Linux发行版
  - 特点：
    - 软件更新速度快
    - 包管理简易高效
  - 包管理器
    - pacman
- Gentoo：具有极高的自定制性，操作复杂，因此适合有经验的人员使用。读者可以在学习完本书后尝试一下该系统
  - 边编译边安装，自由操作系统
  - Gentoo的哲学是自由和选择
  - Portage软件包管理系统

- Kali

Kali Linux是前身是BackTrack基于Debian的Linux发行版，设计用于数字取证和渗透测试和黑客攻防。

Kali Linux预装了许多渗透测试软件，包括nmap(端口扫描器)、Wireshark(数据包分析器)、John the Ripper(密码破解器),以及Aircrack-ng(一套用于对无线局域网进行渗透测试的软件)用户可通过硬盘、live CD或live USB运行Kali Linux。

LFS：Linux From Scratch编译安装指南

就是一种从网上直接下载源码，从头编译LINUX的安装方式。它不是发行版，只是一个菜谱，告诉你到哪里去买菜（下载源码），怎么把这些生东西( raw code) 作成符合自己口味的菜肴──个性化的linux，不单单是个性的桌面。

Android：Linux kernel + busybox + jvm(java) + android(GUI)

### Linux 程序包管理器

- Linux内核：
  - Kernel+Application
  - GNU/Linux：通常以源码（文本格式）方式提供
  - 自由、灵活

- GCC(GNU Compiler Collection,编译器套装)：
  - C版本 gcc命令行选项
  - GNU 89 无，-std=gnu89
  - ANSI,ISO 90 -ansi, -std=c89
  - ISO 90 -std=c99
  - GNU 99 -std=gnu99

- rpm
  - redhat package manager --> perl语言开发
  - rpm package manager（工业标准） --> C语言开发

- 选择系统
  - Ubuntu（桌面开发系统）
  - CentOS（服务器系统）

- 程序的组成部分：bin、etc、lib64、man

- 程序包管理器: 有数据库列表统一管理
  - 程序名、配置文件、库文件等
    - X: 程序的组成文件打包成一个或有限几个文件
    - 安装；卸载；查询；升级；
  - X86-64, CentOS 6.4 32bits, test-1.3.2.el5.x86_64.rpm

- 程序包管理器种类：
  - Redhat: rpm, yum => dnf
  - S.u.S.E: rpm, zypper
  - Debian: deb(.dpkg), apt-get
  - ArchLinux: pacman
  - Gentoo: portage

## 查看32位于64位

``` shell
# uname -a
# ls -ld /lib64
# cat /etc/redhat-release 操作系统
# uname -r 内核版本
# uname -r 查看系统位数
```

## IT 技术岗位

### 研发技术

- 硬件：机器语言（二进制的指令和数据）开发的接口代码
- 软件：程序写的程序代码
  - 低级语言：汇编语言(机器(CPU能够执行的指令)相关的指令)，汇编器
  - 高级语言：C/C++, 编译器
    - 系统级别(接近机器，机器执行性能更好)：C/C++ 性能服务类程序：操作系统, 数据库
    - 应用级(接近人类，人类易于编写)：Java, Python, Go 应用程序：ansible, puppet

### 应用技术

- 运维：Linux 生态圈中的各应用程序的应用
  - Shell 脚本编程：某些应用工作能自动完成
  - Python：专业编程语言
    - Ansible Openstack
- DevOps: 开发运维

### Linux运维工程师

- 运维工程师在国内又称为运维开发工程师(Devops)，在国外称为 SRE（Site Reliability Engineering）。

负责维护并确保整个服务的高可用性，同时不断优化系统架构、提升部署效率、优化资源利用率提高整体的ROI. return on investment(投资回报率) 
运维工程师面对的最大挑战是大规模集群的管理问题，如何管理好几十万台服务器上的服务，同时保障服务的高可用性
规模较大的公司(比如：Google、FaceBook、百度、阿里、腾讯等)，运维工程师和系统管理员是有一定的区别：

- 系统管理员：主要负责机房网络、服务器等硬件基础设施的运行和维护。
- 运维工程师：主要负责管理并维护在运行在海量服务器上的软件服务。

### RedHat 认证

- 认证考试 认证培训课程编号 认证培训课程名称
- RHCSA RH124,RH135 红帽认证系统管理员
- RHCE RH254 红帽认证工程师
- RHCA RH401,RH436,RH423,RH442,RHS333 红帽认证架构师
- RHCSS RedHat Certified Security Specialist 红帽认证安全专家
- RHCDCS RedHat Certified Datacenter Specialist 红帽认证数据中心专家
- RHVA RedHat Certified Virtualization Administrator 红帽认证虚拟化管理

- RH033 基础
- RH133 操作系统管理
- RH253 服务管理
- RH401
- RH423 (ldap)
- RH442
- RH436 集群和存储
- RHS333

