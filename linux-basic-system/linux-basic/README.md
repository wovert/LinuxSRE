# Linux 基础入门-[沃尔特](https://www.wovert.com)

## 终端

> 用户与主机进行交互的设备

早期的大型主机，想使用的用户有很多，但主机只有一个，也不可能做到人手一台，但是可以做到在主机上接上一个分屏器，分屏器的每一个端子上可以接上一套键盘鼠标显示器，就可以直接在主机上面进行一些操作，这就相当于每个人在独立的操作一台计算机一样，像把一个端子上面所接入的鼠标、键盘、显示器所组成的一个组合，称之为终端。

所谓操作系统的多用户概念，就是基于此种模式而诞生的。终端可以说是一个程序，但严格意义上来是一个设备，因为终端所表现的是一些物理设备，如键盘、鼠标、显示器等。

### 终端的类型

- 物理终端

> 将显示器、键盘鼠标直接接在主机的接口之上，即本机自带的，直接连入的，我们称之为物理终端。物理控制台 console 表示 `/dev/console`
在系统启动的时候，服务还没有全部起来，这个时候映射的是物理终端，在服务完成启动之后映射的是虚拟终端，当然还有图形终端。

- 虚拟终端

> 系统提供的6个虚拟终端，这些终端附加在物理终端之上的，用软件的方式虚拟实现的终端 centos 默认启用 6 个虚拟终端，可以使用快捷键来切换不同虚拟终端

切换方式：`Ctrl+Alt+F[1-6]`

虚拟终端路径文件设备： `/dev/tty/#`

系统启动之后通过虚拟终端来登录系统，即便是在物理设备上。

- 图形终端
> 附加在物理终端之上，用软件方式虚拟实现的终端，但额外会提供桌面环境，切换方式：`Ctrl+Alt+F7`

- 伪终端

> 图形界面下打开的命令行接口，还有基于ssh协议和telnet协议等远程打开的命令行界面

伪终端路径文件设备： `/dev/pts/#`

- 串行终端
> 伪终端路径文件设备：`/dev/ttyS[0-3]` 串口

- 查看当前的终端设备命令: `# tty`

终端实际上一个设备，一个设备要想与系统进行交互，必须有交互接口，当开启一个终端时，系统会自动在终端上运行一个交互式程序。

## 交互式程序

### GUI

> 图形化界面，是基于 [X 协议](https://baike.baidu.com/item/X%E8%A7%86%E7%AA%97%E7%B3%BB%E7%BB%9F%E5%8D%8F%E8%AE%AE)实现的窗口管理器（桌面、按钮的作用等）

- Linux 桌面系统
  - [Gnome](https://www.gnome.org/)(C 程序开发，GTK开发库)
  - [KDE](https://www.kde.org/)(C++ 程序开发，QT 开发库)
  - [xcfe](https://xfce.org/)(轻量级桌面)

### CLI

> 用户与系统交互，必须通过shell，不同的程序员开发的程序不一样。

- shell program：`bash, zsh, sh, csh, tcsh, ksh`

- 获取当前环境的shell: `# echo $SHELL`
- 显示当前系统使用的 shell 是哪种 shell : `# cat /etc/shells`

### TUI

- TUI：Text User Interface

`# nmtui`

- API：Application Program Interface 程序员面对的编程接口
- ABI：Application Binary Interface 程序应用者面对运行程序的接口
- POSIX：Portable Operating System 可移植操作系统

- 自动运行服务（不占接口，开机自动运行）：后台 daemon 程序
- 手动运行服务（占接口）：前台

## CLI 接口

### 命令行接口：

`[user@host ~]# COMMAND` prompt

[user@host ~] 称之为PS1, 靠环境变量定义，其组成部分可以使用 echo 命令来显示 echo $PS1

格式：[\u@\h\W]\$

- user: 当前登陆的用户名
- host: 当前主机的主机名，非完整格式；此处的完整格式为：host.lingyima.com
- ~: 用户当前所在的目录（current directory），也成为工作目录（working directory）；相对路径

`# 表示命令提示符，提示符有两种`

- #: 管理员账号，为 root；拥有最高权限，能执行所有操作

- $: 普通用户，非 root 用户；不具有管理权限，不能执行系统管理类操作

注意：使用非管理员账号登录；

执行管理操作临时切换至管理员，操作完成即退回

- 所谓命令提示符，就是提示用户可以在此输入命令，那么输入命令意味着什么？

输入命令，然后回车：shell程序找到键入的命令所对应的可执行程序或代码，并由其分析后提交给内核分配资源将其运行起来，表现为一个或多个进程。

如：键入 ls, 先查找 ls 对应的执行程序：

`# which ls` 可查看 ls 命令所对应的可执行程序

`# whereis ls` 也可以获得 ls 有哪些帮助文件
有些命令是找不到其对应的可执行程序的，如 `cd`

## 基础命令

- `tty` 查看当前的终端设备
- `ifconfig`或`ip addr list` 查看活动接口的IP地址
- `echo` 回显
- `ping` 探测网络上目标主机与当前主机之间的连通性

关机命令

``` sh
~]# systemctl poweroff
~]# systemctl reboot
```

``` sh
~]# poweroff
~]# hatl
~]# reboot
```

``` sh
shutdown [OPTIONS...] [TIME] [WALL...]
OPTIONS:
  -h: halt
  -c: cancle
  -r: reboot
TIME:
  now
  hh:mm
  +m
  +0=now
```

``` sh
WALL
向所有终端发送信息
```

``` sh
# shutdown -r +5 "after 5 minutes shutdown"
# wall "message information"
```

**自由含义：自由学习和修改；自由使用；自由分发；自由创建衍生版；**

## Linux 哲学思想

1. 一切皆文件；把几乎所有的资源统统抽象为文件形式；包括硬件设备，甚至通信接口等；open(), read(), write(), close(), delete(), create()
2. 由众多目的单一的小程序组成；一个程序只做一件事，且做好；组合目的单一的小程序完成复杂任务；
3. 尽量避免跟用户交互；易于以编程的方式实现自动化任务；
4. 使用文本文件保存配置信息；
5. 提供机制，而非策略；

## 文件是什么？众多文件如何有效组织起来？

### 文件

> 存储空间存储的一段流式数据，对数据可以做到按名存取；

文件必须有名字，文件名与文件内容没有关系，文件名是文件的外围属性。
所以文件是文件名、大小、属性这些外围属性所组成的

- 文件有两类数据
  - 元数据：metadata, 文件名，大小属性等
  - 数据：data

文件索引信息就是元数据，而元数据所指向的就相当于数据。目录也是一种文件，是一种特殊的文件。

### 目录

> 是路径映射

### 文件名使用法则

- 文件名严格区分字符大小写
- 目录也是文件，在同一路径下，两个文件不能同名；
- 文件名使用出了 / 以外的任意字符，但不建议使用特殊字符
- 文件名长度最长不能超过 255 个字符
- 所有 . 开头的文件都为隐藏文件
- . 当前目录
- .. 当前目录的上一级目录

### 文件系统： 层级结构；有索引；

- /: 原初起点，根目录
- 第二层结构，子目录
- 第三层结构，子目录
- 倒置树状结构

- /dev/pts/2:
  - 最左侧的`/`：表示**根目录**
  - 其他的`/`：表示**路径分隔符**
    - Linux 的路径分隔符是 `/`
    - Windows 的是 `\`

### 文件的路径表示：

- 绝对路径：从根开始表示出的路径
- 相对路径：从当前位置开始表示出的路径

### 用户家目录 home

> 用户的起始目录：普通用户管理文件的位置

### 工作目录

``` sh
/etc/sysconfig/network-scripts/ifcfg-eno16777736
`basename` 最右侧的文件或目录名
`dirname` basename 左侧的路径
```

`~]# basename /PATH/TO/SOMEFILE` **SOMEFILE**

`~]# dirname /PATH/TO/SOMEFILE` **/PATH/TO**

## 参考书籍

- 《穿越计算机的迷雾》
- 《量子物理史话》

## 命令格式

### 命令的语法通用格式

``` sh
COMMAND [OPTIONS...] [ARGUMENTS...]
命令     选项    参数
```

### COMMAND

> 发起一个命令，请求内核将某个二进制程序运行为一个进程：

- 程序转为进程
- 静态转为动态（有生命周期）

- 命令本身是一个可执行的程序文件：二进制格式的文件，有可能会调用共享库文件
  - 多数系统自带程序文件都存放在：**/bin, /sbin, /usr/bin, /usr/sbin**
  - 第三方程序文件：**/usr/local/bin, /usr/local/sbin**

  - 普通命令： **/bin, /usr/bin, /usr/local/bin**
  - 管理命令：**/sibn, /usr/sbin, /usr/local/sbin**

  - 注意：并非所有的命令都有一个在某目录与之对应的可执行程序文件（内置命令）

  - 共享库(公共功能性的二进制文件，只能被其他程序调用)：**/lib, /lib64, /usr/lib, /usr/lib64, /usr/local/lib, /usr/local/lib64**
    - 32bits 库：**/lib, /usr/lib, /usr/local/lib**
    - 64bits 库：**/lib64, /usr/lib64, /usr/local/lib64**

### 命令必须遵循特定格式规范

- Windows: **exe,msi**
- Linux: **ELF**

查看可执行文件格式: `~]# file /bin/ls`

### 命令分类

- __内置命令__(builtin)：由shell程序自带的命令
- __外部命令__：独立的可执行程序文件，文件名即命令名

注意：命令可以有别名，别名可以与原名相同，此时原名被隐藏；此时如果要运行**原命令**，则使用`\command`

### alias 命令别名

获取所有可用别名的定义：`~]# alias`

定义别名：仅对当前shell有效：`~]# alias COMMAND_ALIAS='COMMAND'`

更新补丁：`# yum update`

安装常用工具：`# yum -y install lrzsz telnet tree nmap nc`

### shell程序是独特的程序，负责解析用户提供的命令

- 环境变量
  - **PATH**：从哪些路径中查找用户键入的命令字符串所对应的命令文件
    - `~]# echo $PATH`
    - /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin
  - 查找次序：自左而右
  - 注意：只有**外部命令**根据环境变量`$PATH`查找命令文件

### 查看命令类型

`~]# type COMMAND`

### OPTIONS 选项

> 调整命令的运行特性

- 选项分类
  - 短选项：-C，例如：-l, -ld
    - 同一命令同时使用多个短选项，多数可合并：-l -d = -ld
    - 注意：有些命令的选项没有-

  - 长选项：-word, 例如：--help, --human-reable
    - 注意：长选项不能合并多个选项

  - 注意：有些选项可以带参数，称为**选项参数**

### ARGUMENTS 参数

> 命令的作用对象；命令对什么生效

`~]# ls -l /var`

- 注意：不同的命令的参数，有些命令可同时带**多个参数**，多个之间以空白字符分割

`~]# ls -l -l /var /etc` 命令 -选项 -选项 参数 参数

### 执行多个命令

`~]# command; command; command`

### 取消命令

`Ctrl+c` 终止命令执行

## 命令帮助

### 内建命令 `help COMMAND`

`~]# help cd`

### 外部命令

#### 1. 简要格式使用帮助

`~]# COMMAND --help`

#### 2. 使用手册：manual

系统手册路径：`/usr/share/man`

查看手册：`~]# man COMMAND`

- SECTION 章节
  - NAME: 简要功能性说明
  - SYNOPSIS: 命令使用格式; 概要；大纲
  - DESCRIPTION: 描述
  - OPTIONS: 选项
  - EXAMPLES: 使用示例
  - AUTHORS: 作者
  - BUGS: 报告程序bug的方式
  - SELL ALSO: 参见

##### SYNOPSIS

- **[]** 可选内容
- **<>** 必须提供的内容
- **a|b** 多选一
- **...** 同类内容可出现多个

#### 使用手册：压缩格式的文件，有章节之分

`/user/share/man`

man1, man2, ...

- **1: Executale programs or shell commands** 	普通用户和管理员可执行的命令
- **2: System calls** 	系统调用
- **3: Library calls** 	C库调用
- **4: device files and special files** 设备文件及特殊文件
- **5: file format;** 	配置文件格式
- **6: Game;**			游戏使用帮助
- **7: Miscellaneous** 	其他
- **8： Administrator command；** 管理工具及守护进程

`~]# man [1-8]? COMMAND`

- 注意：并非每个command在所有章节都有手册

查看命令有哪些章节

``` sh
~]# whatis COMMAND
~]# man -f Keyword 精确查找
```

- 注意：whatis 执行过程是查询数据库进行
- 手动更新数据：
  - CentOS 6: `~]# makewhatis`
  - CentOS 7: `~]# mandb`

- 指定目录下查找手册

``` sh
~]# man -M /PAHT/TO/SOMEDIR COMMAND
/usr/share/man 目录复制到其他目录下
man1, man5, man8 等
```

模糊查找: `~]# man -k Keyword`

##### man命令打开手册以后的操作方法：

- __翻屏__
  - `空格键` 向文件尾部翻一屏
  - `b` 向文件首部翻一屏

  - `Ctrl+d` 向文件尾部翻半屏
  - `Ctrl+u` 向文件首部翻半屏

  - `回车键` 向文件尾部翻一行
  - `k` 向文件首部翻一行

  - `G` 跳转至最后一行
  - `nG` 跳转至指定行
  - `1G` 跳转至文件首部

- __搜索__：查找时不分区大小写
  - `/keyword` 从文件首部向文件尾部依次查找
  - `?keyword` 从文件尾部向文件首部依次查找
  - `n` 同方向查找下一个
  - `N` 反方向查找下一个

- __退出__
  - `q` 退出

#### 3. `info COMMAND`

> 获取命令的在线文档

#### 4. 程序自带的帮助文件：`/usr/share/doc/APP-VERSION`

- __README__: 程序的相关的信息
- __INSTALL__: 安装帮助
- __CHANGES__: 版本迭代时的改动信息

#### 5. 主流发行版官方文档

- http://www.redhat.com/doc

#### 6. 程序的官方文档

- 官方站点上的 **Document**

#### 7. 搜索引擎

- google0
  - `filetype: pdf`
  - `................................0site:lingyima.com`  
    - domain.tld(top level domain)
  - `intitle:`
  - `inurl:`
  = `intext:`

#### 8. 书籍出版社

- 外文书籍
- O'reiley
- Wrox
- 机械工业、电子工业、人邮、清华大学、水利水电

### 练习：获取 useradd 命令的用法

1. 添加用户 gentoo

``` sh
~]# useradd gentoo
~]# id gentoo
```

2. 添加用户 slackware，要求指定其所用的 shell 为 /bin/tcsh

``` sh
~]# useradd -s /bin/tcsh slackware
~]# tail -1 /etc/passwd
```

## 常用命令

### 目录命令

#### 查看当前目录 - print working directory

`~]# pwd`

#### 切换工作目录 -  change directory

``` shell
~]# cd [/PATH/TO/SOMEDIR] 切换到自定目录
~]# cd ~` 切换到当前用户家目录
~]# cd ~USERNAME` 切换至指定用户的家目录
~]# cd -` 切换到上次目录
```

- 环境变量

``` sh
~]# echo $HOME
~]# echo $PWD
~]# echo $OLDPWD
```

#### 列出指定目录下的文件列表 - list

``` sh
ls [OPTIONS]... [FILE]...

ls options
  -a : 显示所有文件，包括隐藏文件
  -A :  显示所有文件，除了.和..的所有隐藏文件
  -r,--reverse : 逆序显示
  -R,--recursive : 递归显示
  -i, --inode
  --file-type：/

  -lc ctime
  -lu atime
  -t : 按修改时间先后显示
  -m : 填满宽度的逗号分隔列表条目
  -S : 以文件大小排序显示

  -d, --directory : 查看目录自身属性信息，结合使用l选项，-ld
  -h, --human-readable : 人为可读的格式显示，换算后的结果会丢失精度
  -l，--long : 长格式列表，即显示文件的详细属性信息
```

- 文件类型：属主权限：属组权限：其他权限：隐藏属性：硬链接数：文件的属主:文件的属组：文件大小（字节）：最近一次被修改日期：文件名
- drwxr-xr-x. 2 root root    4096 Sep 17  2016 anaconda
- drwxr-x---. 2 root root      22 Sep 17  2016 audit
- -rw-r--r--  1 root root    8659 Jul  2 10:38 boot.log

---

#### mkdir：make directories

``` sh
mkdir [OPTION]... DIRECTORY...

-p 自动按需创建父目录
-v verbose，显示详细过程
-m MODE 直接给定权限
```

- 注意：路径基名方为命令的作用对象；基名之前的路径必须得存在；

---

#### rmdir：remove empty directories

``` sh
rmdir [OPTION]... DIRECTORY...

p 删除某目录后，如果其父目录为空，则一并删除之；
v verbose
```

---

#### mktemp 命令：create a temporary file or directory

``` sh
mktemp [OPTION]... [TEMPLATE]
-d, --directory` 创建临时目录
-u, --dry-run` do not create anything
```

`~]# mktemp XXX.ab`

注意：mktemp 会将创建的临时文件名直接返回，因此，可直接通过命令引用保存起来

---

### 文件查看工具

#### 查看文件内容类型

`file [FILE]...` ASCII, ELF

---

#### 查看文件内容

``` sh
cat [OPTION]... [FILE]..

options
-n, --number : 显示行号
-E, --show-ends : 显示行结束符
-v， --show-nonpriting : 显示非打印字符
-e = -vE : 显示行结束符及非打印字符
-s, --squeeze-blank suppress repeated empty output lines
~]# cat /etc/fstab /etc/issue
```

---

``` sh
tac [-n] [-E]
```

---

``` sh
more/less
```

---

``` sh
head
查看文件的前n行
n # 或者 -#
```

---

``` sh
tail
查看文件的后n行

n #  或者 -#
-f 查看文件尾部内容结束后不退出，跟随显示新增的行
```

#### 从标准输入获取内容创建和执行命令

``` sh
xargs -n 数字

一行显示列数(空白字符分割)
```

``` sh
# echo 1 2 3 4 5 > file.txt
# xargs -n 4 < file.txt
```

---

#### 回显

``` sh
echo [SHORT-OPTION]... [STRING]...

echo OPTIONS

-n : do not output the trailing newline
-e : 转义符生效
  \r: 回车符
  \n： 换行符
  \t：制表符
  \v：纵向制表符
  \b：退格符
  \\：反斜线`
  `\033[31m  \033[0m


第一个 `#`
1 加粗
3 前景
4 背景色
5 闪烁
7 前景背景互换


第二个 `#`：颜色，1-7

`\033[0m` 控制结束符

#  echo -e "\033[31;1;42mHello\033[0m"

```

- STRING 可以使用引号，单引号和双引号
  - 单引号：**强引用**，变量不会被替换
  - 双引号：**弱引用**，变量引用会替换
  - 反引号：**命令解析**，$(COMMAND)=`COMMAND`

- 注意：变量引用的正规符号 `${变量名}`

---

### 日期相关命令

> 系统启动时从硬件读取日期和时间信息；读取完成以后，就不在与硬件相关联

- 系统时钟
- 硬件时钟

---

``` sh
date [OPTIONS]... [+FORMAT]

显示系统时钟

+FORMAT:
  %F fulldate
  %Y year
  %m month
  %d day
  %T time
  %H hour
  %M minute
  %S second
  %s unixtimestamp, unix元年 1970-1-1 0:0:0之后经过的秒数
```

`~]# date +"%F %T"`

设定日期时间：`date [-u|--utc|--universal] [MMDDhhmm[[CC]YY][.ss]]`

---

``` sh
clock 显示硬件时钟

是 hwclcok 的软链接
```
---

``` sh
hwclock - query or set the hardware clock(RTC)

-s, --hctosys : Set the System Time from the Hardware Clock.（硬件时钟是对的）
-w, --systohc : Set the Hardware Clock to the current System Time.(系统时钟是对的)
```

---

``` sh
cal [options] [[[day] month] year]
```

---

``` sh
which OPTIONS

OPTIONS:
  --skip-alias 忽略别名
```

---

``` sh
whereis OPTIONS

OPTIONS:
-b binary path
-m man path
```

---

``` sh
who options

options:
  -b 最近一次系统启动时间
  -r runlevel
  -u 显示进程号
```

---

``` sh
w 

增强版的 who 命令
```

- IDEL
- JCPU 与该tty终端连接的所有进程占用的时间，不包括过去的后台作业时间
- PCPU 当前进程(即w项中显示的)所占用的时间

---

### 文件管理

#### stat 命令

> 显示文件系统状态的文件

- 文件
  - 元数据：metadata，inode
  - 数据: data, block

- 时间戳：
  - access time
  - modify time(数据)
  - change time(元数据)

#### touch 命令 - change file timestamps

`touch` options

``` sh
-c : 指定的文件路径不存在时不予创建
-a : 修改access time
-m : 修改modify time
-t [[CC]YY]MMDDhhmm[.ss]
```

#### mv 命令

``` sh
mv [OPTION]... SOURCE... DIRECTORY
mv [OPTION]... -t DIRECTORY SOURCE...

options
  -i : interactive
  -f : force
```

---

``` sh
rm

options
 -i interactive
 -f force
 -r recursive

注意：所有不用的文件建议不要直接删除，而是移动至某个专用目录；（模拟回收站
```

---

``` sh
cp 命令 - copy
```

- 单源复制：`cp [OPTION]... [-T] SOURCE DEST`
- 多源复制：`cp [OPTION]... SOURCE... DIRECTORY`

`# cp [OPTION]... -t DIRECTORY SOURCE...`

- 源复制：`cp [OPTION]... [-T] SOURCE DEST`
  - 如果 **DEST**  不存在：则事先创建此文件，并复制源文件的数据流至 **DEST** 中；
  - 如果 **DEST** 存在：
    - 如果 **DEST** 是非目录文件：则覆盖目标文件；
    - 如果 **DEST** 是目录文件：则先在 **DEST** 目录下创建一个与源文件同名的文件，并复制其数据流；

- 多源复制：`cp [OPTION]... SOURCE... DIRECTORY
  - cp [OPTION]... -t DIRECTORY SOURCE...`
  - 如果 **DEST** 不存在：错误；
  - 如果 **DEST** 存在：
    - 如果 **DEST** 是非目录文件：错误；
    - 如果 **DEST** 是目录文件：分别复制每个文件至目标目录中，并保持原名；

**copy 常用选项**

``` shell
-i interactive : 覆盖文件时提醒信息
-f force : 强制覆盖目标文件
-r, -R recursive : 递归复制目录
-d : 复制符号链接文件本身，而非其指向的源文件；--preserver=links
-p： 连同档案的属性一起复制过去，而非使用默认属性
-a -pdR --preserve=all, archive 用于实现归档
  --preserve=
    mode：权限
    ownership：属主和属组
    timestamps: 时间戳
    context：安全标签
    xattr：扩展属性
    links：符号链接
    all：上述所有属性
```

---

``` sh
install 命令
```

- 单源复制 : `install [OPTION]... [-t] SOURCE DEST` 

- 多源复制
  - `install [OPTION]... SOURCE... DIRECTORY`
  - `install [OPTION]... -t DIRECTORY SOURCE...`

- 创建空目录：`install [OPTION]... -d DIRECTORY...`

**install 选项**

``` shell
-m, --mode=MODE : 设定目标文件权限，默认为 755
-o, --owner=OWNER : 设定文件的属主
-g, --group=GROUP : 设定文件的属组
-d : 创建空目录
-t : 指定目标目录
```

**注意**：`install` 命令不能复制目录

``` shell
# install -d demo demo3
# install -m 770 -o redhat -g linux -t /tmp/etc/ /etc/*
```

---

``` sh
dd 命令 - convert and copy a file

# dd if=/PATH/FROM/SRC of=/PATH/TO/DEST bs=block size count=数量`

bs=#，block size，复制单元大小，单位：byte

磁盘对考：`~]# dd if=/dev/sda of=/dev/sdb`
备份 MBR: `~]# dd if=/dev/sda of=/tmp/mbr.bak bs=512 count=1`
清除分区：`~]# dd if=/dev/zero of=/dev/sda bs=512 count=1`
破坏MBR中的Bootloader：`~]# dd if=/dev/zero of=/dev/sda bs=256 count=1`
```

- 两个特殊设备
  - `/dev/null` 数据黑洞
  - `/dev/zero` 吐零机