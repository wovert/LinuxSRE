# Bash

## 1. 命令别名 alias

获取所有可用别名的定义：`~]# alias`

定义别名：`~]# alias NAME='COMMAND'`

注意：仅对当前shell进程有效

永久生效修改：`~]# vim ~/.bashrc`

撤销别名：`~]# unalias NAME`

`unalias -a` 撤销所有的命令别名

使用原命令：`\COMMAND`

## 2. 命令历史 history

> shell进程会其会话中保存此前用户提交执行过的命令(在内存)

### 定制 history 的功能，可通过环境变量实现：

- `HISTSIZE`：shell进程可保留的命令历史的条数
- `HISTFILE`：持久保存命令历史的文件；
  - `.bash_history`
- `HISTFILESIZE`：命令历史文件的大小

### 命令用法：

- `history [-c] [-d] [n]`
- `history -anrw [文件名]`
- `history -ps 参数 [参数...]`
  - `-c`: clear
  - `-d offset`：delete
  - `-r`: 从文件读取命令历史至历史列表中（内存）
  - `-w`：把历史列表中的命令追加至历史文件中
- `history #`：显示最近的#条命令

### 调用命令历史列表中的命令：

- `!#`：再一次执行历史列表中的第#条命令
- `!!`：再一次执行上一条命令
- `!STRING`：再一次执行命令历史列表中最近一个以STRING开头的命令

- 注意：命令的重复执行有时候需要依赖于幂等性

### 调用上一条命令的最后一个参数：

- 快捷键：`ESC, .`
- 字符串：`!$`

### 控制命令历史记录的方式：

- 环境变量：`HISTCONTROL`
  -`ignoredups`：忽略重复的命令；
  - `ignorespace`：忽略以空白字符开头的命令；
  - `ignoreboth`：以上两者同时生效；
- 修改变量的值：
  - `NAME='VALUE'`

## 3. 补全功能

### 命令补全

> shell程序在接收到用户执行命令的请求，分析完成之后最左侧的字符串会被当作命令

### 命令查找机制

1. 查找内部命令
2. 根据PATH环境变量中设定的目录，自左而右逐个搜索目录下的文件名
3. 给定的打头字符串如果能惟一标识某命令程序文件，则直接补全
4. 不能惟一标识某命令程序文件，再击 tab 键一次，会给出列表

### 路径补全

> 在给定的起始路径下，以对应路径下的打头字串来逐一匹配起始路径下的每个文件：

`tab` 如果能惟一标识，则直接补全；否则，再一次tab，
给出列表；

## 4. 命令行展开

`~ [UERNAME]`：自动展开为用户的家目录，或指定的用户的家目录

`{}`：可承载一个以逗号分隔的路径列表，并能够将其展开为多个路径；

例如：`/tmp/{a,b}` 相当于 /tmp/a /tmp/b

###　tree命令：

- `tree [options] [directory]`
  - `-L level`：指定要显示的层级
  - `-d`：只显示目录
  - `-P pattern`：只显示指定pattern匹配到的路径

## 5. 命令的执行状态结果

### bash通过状态返回值来输出此结果：

- 成功：`0`
- 失败：`1-255`

- 命令执行完成之后，其状态返回值保存于bash的特殊变量`$?`中；
- 命令正常执行时，有的还回有命令返回值：
- 根据命令及其功能不同，结果各不相同；

### 引用命令的执行结果：

`$(COMMAND)` 或 `COMMAND`

## 6. 引用

强引用：`''`，字符串理变量不会被替换

弱引用：`""`，字符串理变量不会被解析

命令引用：`COMMAND`, `$(COMMAND)`

## 7. 快捷键

`Ctrl+a`：跳转至命令行行首

`Ctrl+e`：跳转至命令行行尾

`Ctrl+u`：删除行首至光标所在处之间的所有字符；

`Ctrl+k`：删除光标所在处至行尾的所有字符；

`Ctrl+l`：清屏，相当于clear

## 8. 命令哈希

### 缓存此前命令的查找结果

- key：搜索键
- value：值

### hash 命令

- `hash` 列出
- `hash -d COMMAND`：删除
- `hash -r`：清空

## 9. 变量

> 命名的内存空间

- 程序：指令+数据
- 指令：有程序文件提供
- 数据：IO设备、文件、管道、变量
- 程序：算法+数据结构
- 算法：设计解决问题的路径

- 变量：变量名+指向的内存空间
- 变量赋值：name=value

### 数据类型

- 字符
- 数值
  - 精确数值
  - 近似数值
- 存储格式、数据范围、参与的运算
- 变量的赋值操作：
  - name=value

### 浮点数如何存储

- 单精度浮点数
- 双精度浮点数

### 编程语言：

- 强类型变量：Java、C/C++
- 弱类型变量：bash、javascript、PHP、Ruby、Python
  - **bash 把所有变量统统视作 字符型**
  - **bash不支持浮点型数据**，除非使用外在工具
  - **bash中的变量无需事先声明**；把声明和赋值过程同时实现

- 声明：类型，变量名
- 变量替换：把变量名出现的位置替换为其所指向的内存空间中数据
- 变量引用：${var_name}， $var_name

### 变量名

1. 变量名只能包含**数字、字母和下划线**，而其**不能以数字开头**
2. **见名知义**，命名机制遵循某种法则;chicken_total, chickenTotal
3. **不能使用程序的保留字**，例如if, else, then, while等等

### bash变量类型

- 本地变量：作用域为当前shell进程
- 环境变量：作用域为当前shell进程及其子进程
- 局部变量：作用域为某代码片段（函数上下文）
- 只读变量：重新赋值并且不支持撤销；当前 shell 进程的生命周期随 shell 进程终止而终止
- 位置参数变量：执行脚本的 shell 进程传递的参数
- 特殊变量: shell 内置的特殊功用的变量

### 本地变量

- 作用域：当前 shell 进程
- 变量赋值：`name=value`
- 变量引用：`${name}, $name`
- 查看变量：`set`
- 撤销变量：`unset name`
  - 注意：此处非变量引用

### 环境变量

- 作用域：当前 shell 进程及其子进程
- 变量赋值：
  - `export name=value`
  - `name=value`
    - `export name`
  - `declare -x name=value`
  - `name=value`
    - `declare -x name`

注意：bash内嵌了许多环境变量（通常为大写字母），用于定义 bash 的工作环境

`PATH, HISTFILE, HISTSIZE, HISTFILESIZE, HISTCONTROL, SHELL, HOME, PWD,OLDPWD,UID`

- 查看环境变量：`export, declare -x, printenv, env`
- 撤销环境变量：`unset name`

### 局部变量

- 作用域：某个代码片段（函数上下文）

### 位置参数变量：当执行脚本的shell进程传递的参数

`$0 $# $@ $*`

### 特殊变量：shell内置的有特殊公用的变量；

- `$?`：上一个命令的执行状态结果
  -`0`：succes
  -`1-255`: failue

### 只读变量

- `declare -r name`
- `readonly name`

只读变量无法重新赋值，并且不支持撤销；存活时间为当前shell进程的生命周期，随shell进程终止而终止

## 10. globbing: 文件名通配

- 注意：**整体文件名匹配，而非部分**
  - 显示包括目录下的文件名

### 匹配模式：meta character

- `*` 匹配**任意长度的任意字符**
  - `pa*, *pa*, *pa, *p*a*`
  - pa, paa, passwd
- `?`：匹配任意单个字符
  - pa?, ??pa, p?a, p?a?
  - pa, paa, passwd
- `[]`：匹配指定范围内的**任意单个字符**
  - `[a-z]=[A-Z]`(不区分大小写), [0-9], [a-z0-9]=[A-Z0-9]
  - `[[:digit:]]`：所有数字 [0-9]
  - `[[:upper:]]`：所有大写字母
  - `[[:lower:]]`：所有小写字母
  - `[[:alpha:]]`：所有字母 [a-z], [A-Z]
  - `[[:alnum:]]`：所有的字母和数字 [0-9a-z],[0-9A-Z]
  - `[[:space:]]`：所有空白字符
  - `[[:punct:]]`：所有标点符号
  - `[^]`：匹配指定范围外的任意单个字符
  - `[^a-z]=[^A-Z]`(不区分大小写), [^0-9], [^a-z0-9]=[^A-Z0-9]
  - `[^[:digit:]]`：非数字
  - `[^[:upper:]]`：非大写字母
  - `[^[:lower:]]`：非小写字母
  - `[^[:alpha:]]`：非字母
  - `[^[:alnum:]]`：非字母和数字
  - `[^[:space:]]`：非空白字符
  - `[^[:punct:]]`：非标点符号

### 练习

1. 显示/var目录所有以l开头，以一个小写字母结尾，且中间出现一位任意字符的文件或目录；`# ls -d /var/l?[[:lower:]]`

2. 显示/etc目录下，以任意一位数字开头，且以非数字结尾的文件或目录 `# ls -d /etc/[0-9]*[^0-9]`

3. 显示/etc目录下，以非字母开头，后面跟一个字母及其他任意长度任意字符的文件或目录 `# ls -d /etc/[^a-z][a-z]*`

4. 复制/etc目录下，所有以m开头，以非数字结尾的文件或目录至/tmp/lingyima.com目录

``` sh
# ls -d /tmp/lingyima.com &> /dev/null \
|| mkdir /tmp/lingyima.com &> /dev/null \
&& \cp -rfv /etc/m*[^0-9] /tmp/lingyima.com
```

5. 复制/usr/share/man目录下，所有以man开头，后跟一个数字结尾的文件或目录至/tmp/man/目录下

``` sh
# ls -d /tmp/man &> /dev/null \
|| mkdir /tmp/man \
&& \cp -rfv /usr/share/man/man[0-9] /tmp/man/
```

6. 复制/etc/目录下，所有以.conf结尾，且m,n,r,p开头的文件或目录至/tmp/conf.d/目录下

``` sh
# ls -d /tmp/conf.d &> /dev/null \
|| mkdir /tmp/conf.d &> /dev/null \
&& cp -rfv /etc/[mnrp]*.conf /tmp/conf.d/
```

## 11. IO重定向及管道

- 可用于输入的设备：文件
  - 键盘设备、文件系统上的常规文件、网卡等
- 可用于输出的设备：文件
  - 显示器、文件系统上的常规文件、网卡等

### 程序的数据流有三种

- 输入的数据流；<-- 标准输入(stdin)， 键盘
- 输出的数据流：--> 标准输出(stdout)，显示器
- 错误输出流：  --> 错误输出(stderr)，显示器

- fd: file descriptor，文件描述符

### IO 重定向

- 输出重定向：[1]>
  - 特性：覆盖输出
  - `# set -C` 禁止覆盖输出重定向至已存在的文件；
  - 此时可使用强制覆盖输出：`[1]>|`

- `# set +C` 关闭上述特性
- `# cat /etc/issue > /dev/tty1`
- 输出重定向：`[1]>>`
  - 特性：追加输出

- 错误输出流重定向：`2>, 2>>`
- 合并正常输出流和错误输出流：
  - `&>, &>>`
  - `COMMAND > /path/to/somefile 2>&1`(&1前面不能有空白字符)
  - `COMMAND >> /path/to/somefile 2>&1`
  - 特殊设备：`/dev/null`, 执行结果输出(包括错误输出)重定向到/dev/null
- 输入重定向：[0]<，  <<(Here Document)

### tr 命令

`tr [OPTION]... SET1 [SET2]`
> 把输入的数据当中的字符，凡是在SET1定义范围内出现的，通通对位转换为SET2出现的字符

- 用法1：`tr "SET1" "SET2" < /PATH/FROM/SOMEFILE`
- 用法2：`tr -d "SET1" < /PATH/FROM/SOMEFILE`

- 注意：不修改原文件

``` sh
SET: [:lower:] [:upper:] [:digit:] [:alpha:] [:alnum:]
[:punct:] [:space:] [:blank:] [CHAR1-CHAR2]
```

### Here Document：<<

``` sh
cat << EOF
cat > /PATH/TO/SOMEFILE << EOF
```

### 管道

> 连接程序，实现将前一个命令的输出直接定向后一个程序当作输入数据流

`~]# COMMAND1 | COMMAND2 | COMMAND3 | ...`

### tee

> read from standard input and write to standard output and files

- `~]# COMMAND | tee /PATH/TO/SOMEFILE | tr 'a-z' 'A-Z'`
- 练习：把 `/etc/passwwd` 文件的前6行的信息转换为大写字符后输出
- `~]# head -6 /etc/passwd | tr [a-z] [A-Z]`
- `~]# head -6 /etc/passwd | tr 'a-z' 'A-Z'`
- `~]# head -6 /etc/passwd | tr [:lower:] [:upper:]`

## 12. 多命令执行

`# COMMAND1; COMMAND2; COMMAND3; ...`

### 逻辑运算

- 真(true,yes,on,1)
- 假(false,no,off,0)

- &&：与
  - 1 && 1 = 1
  - 1 && 0 = 0
  - 0 && 1 = 0
  - 0 && 0 = 0
- ||：或
  - 1 || 1 = 1
  - 1 || 0 = 1
  - 0 || 1 = 1
  - 0 || 0 = 0
- !：非
  - ! 1 = 0
  - ! 0 = 1

- ^：异或
  - 1 ^ 1 = 0
  - 1 ^ 0 = 1
  - 0 ^ 1 = 1
  - 0 ^ 0 = 0

### 短路法则：执行命令状态结果

`~]# COMMAND1 && COMMAND2`

- COMMAND1为假，则COMMAND2不会再执行；
- 否则，COMMAND1为真，则COMMAND2必须执行；

`~]# COMMAND1 || COMMAND2`

- COMMAND1为真，则COMMAND2不会再执行；
- 否则，COMMAND1为假，则COMMAND2必须执行；

`~]# id $username &> /dev/null || useradd $username`

## 13. shell scirpt

### 编程语言的分类：根据运行方式	

- 编译运行：
  - 源代码用编译器转换为汇编文件
  - 汇编文件转用汇编器转换成机器代码
  - 项目管理构建工具，编译一部分代码

- 解释运行：
  - 源代码运行时启动解释器，有解释器边解释边运行
  - 注意：词法分析、语法分析

- 根据其编程过程中功能的实现是调用库还是调用外部的库文件
  - shell编程:
    - 利用系统上的命令及编程组件进行编程
  - 完整编程
    - 利用库和编程组件进行编程

### 编程模型

- **过程式编程语言**：以指令为中心来组织的代码，数据服务于代码
  - 顺序执行
  - 选择执行
  - 循环执行
  - 代表：C, Bash
- **面向对象编程语言**：以数据位中心来组织代码，围绕数据来组织指令
  - class：实例化对象，method；
  - 代表：Java, C++, Python

### shell脚本编程特点

- 过程是编程、解释运行、依赖于外部程序文件运行

### 如何写shell脚本：

- 脚本文件的第一行,顶格；给出shellbang，解释器路径，用于指明解释执行当前脚本的解释器程序文件

- 常见的解释器：
  -`#!/bin/bash`
  - `#!/usr/bin/python`
  - `#!/usr/bin/env python`
  - `#!/usr/bin/perl`

### 文本编辑器：`nano`

行编辑器：`sed`

全屏幕编辑器：`nano, vi/vim`

### What is shell script？

命令的堆积；

很多命令不具有幂等性，需要用程序逻辑来判断运行条件是否满足，以避免其运行中发生错误

### 运行脚本

1. 赋予执行权限，并直接运行此程序文件；`~]# chmod u+x /PATH/TO/SCRIPT_FILE`
2. 直接运行解释器，将脚本以命令行参数传递给解释器程序 `~]# bash /PATH/TO/SCRIPT_FILE`

### 注意：脚本中空白行会被解释器忽略

- 脚本中，除了 shell bang，余下所有以`#`开头的行，都会被视作注释行而被忽略；此即为注释行；
- shell 脚本的运行时通过运行一个子shell进程实现的；

### shell配置文件

- `profile` 类：为交互式登陆的 shell 进程提供配置
- `bashrc` 类：为非交互式登陆的 shell 进程提供配置

### 登录类型

- 交互式登录 shell 进程：
  - 直接通过某终端输入账号和密码后登录打开的 `shell` 进程；
  - 使用 su 命令：`su - USERNAME`, 或者使用 `su -l USERNAME`执行的登录切换；

- 非交互式登录 `shell` 进程
  - `su USERNAME` 执行的登录切换
  - 图像界面下打开的终端
  - 运行脚本

### profile类

- 全局：对所有用户都生效；
  - `/etc/profile`
  - `/etc/profile.d/*.sh`
- 用户个人：仅对当前用户有效；
  - `~/.bash_profile`

- 功用

1. 用于定义环境变量
2. 运行命令或脚本

### bashrc类

- 全局：`/etc/bashrc`
- 用户个人：`~/.bashrc`
- 功用：

1. 定义本地变量；
2. 定义命令别名；

注意：仅管理员可修改全局配置文件；

- 交互式登录shell进程：
  - `/etc/profile --> /etc/profile.d/*.sh --> ~/.bash_profile --> ~/.bashrc --> /etc/bashrc`

- 非交互式登录shell进程：
  - `~/.bashrc --> /etc/bashrc --> /etc/profile.d/*.sh`

命令行中定义的特性，例如变量和别名作用域为当前shell进程的声明周期；

配置文件定义的特性，只对随后新启动的shell进程有效；

### 让通过配置文件定义的特性立即生效：

1. 通过命令行重新定义一次；
2. 让shell进程重读配置文件；

`~]# source /PATH/TO/SOMEFILE`

`~]# . /PATH/TO/SOMEFILE`

## 算术运算

- `+, -, *, /, %, **`

- `let VAR=expression`

- `VAR=$[expression]`

- `VAR=$((expression))`

- `VAR=$(expr argu1 $op argu2)`

- 注意：乘法符号有些场景中需要使用转义符

### 增强型赋值：变量做某种算术运算后回存至此变量中；

``` sh
let i=$i+#
let i+=#
+=，-=，*=, /=, %=
```

### 自增

``` sh
VAR=$[$VAR+1]
let VAR+=1
let VAR++
```

### 自减

``` sh
VAR=$[$VAR-1]
let VAR-=1
let VAR--
```

写一个脚本: 计算 `/etc/passwd`文件中的第10个用户和第20个用户的id号之和；

- `id1=$(head -10  /etc/passwd | tail -1  | cut  -d:  -f3)`

- `id2=$(head -20   /etc/passwd | tail -1  | cut  -d:  -f3)`

写一个脚本: 计算/etc/rc.d/init.d/functions和/etc/inittab文件的空白行数之和；

`grep "^[[:space:]]*$"   /etc/rc.d/init.d/functions | wc -l`

##　条件测试

> 判断某需求是否满足，需要由测试机制来实现

### 如何编写测试表达式以实现所需的测试：

1. 执行命令并利用命令状态返回值来判断

- `0：成功`
- `1-255：失败`

2. 测试表达式

- `test  EXPRESSION`
- `[ EXPRESSION ]`
- `[[ EXPRESSION ]]`
- 注意：`EXPRESSION` 两端必须有空白字符，否则为语法错误

### bash的测试类型

数值比较测试：`-eq, -ne, -gt, -ge, -lt, -le, `

字符串测试：`==, >, <, !=, =~, -z, -n`

文件测试

``` SHELL
-a or-e
-f, -d, -h or -L, -b, -c, -S, -p
-r, -w, -x
-u, -g, -k
-s, -N, -O, -G,-ef, -nt, -ot
```

###　数值测试：数值比较

- `-eq`：是否等于； [ $num1 -eq $num2 ]

- `-ne`：是否不等于；

- `-gt`：是否大于；

- `-ge`：是否大于等于；

- `-lt`：是否小于；

- `-le`：是否小于等于；

### 字符串测试：`[[ "STRING" ]]`

- `==`：是否等于；

- `>`：是否大于；

- `<`：是否小于；

- `!=`：是否不等于；

- `=~`：左侧字符串是否能够被右侧的PATTERN所匹配

- `-z "STRING"`：判断指定的字串是否为空；空则为真，不空则假；

- `-n "STRING"`：判断指定的字符串是否不空；不空则真，空则为假;

- 注意：

字符串一定要加**引用**；

要使用**[[ ]]**； 使用`[]`的`<,>`需要转移,`\>`,`\<`

`"a" > "b" > "1"`

### 文件测试

- 存在性测试
  - `-a  FILE`，`-e  FILE`
  - 文件的存在性测试，存在则为真，否则则为假；

- 存在性及类型测试
  - `-b  FILE`：是否存在并且为 块设备 文件；
  - `-c  FILE`：是否存在并且为 字符设备 文件；
  - `-d  FILE`：是否存在并且为 目录文件；
  - `-f  FILE`：是否存在并且为 普通文件；
  - `-h  FILE`或`-L  FILE`：是否存在并且为 符号链接文件；
  - `-p FILE`：是否存在且为 命名管道文件；
  - `-S  FILE`：是否存在且为 套接字文件；

- 文件权限测试
  - `-r  FILE`：是否存在并且 对当前用户可读；
  - `-w  FILE`：是否存在并且 对当前用户可写；
  - `-x  FILE`：是否存在并且 对当前用户可执行；

- 特殊权限测试
  - `-u  FILE`：是否存在并且 拥有suid权限；
  - `-g  FILE`：是否存在并且 拥有sgid权限；
  - `-k  FILE`：是否存在并且 拥有sticky权限；

- 文件是否有内容：
  - `-s  FILE`：是否有内容；有内容为真，否则为假；

- 时间戳：
  - `-N FILE`：文件自从上一次读操作后是否被修改过；修改为真，否则为假；
- 从属关系测试：
  - `-O  FILE`：当前用户是否为文件的属主；
  - `-G  FILE`：当前用户是否属于文件的属组；

- 双目测试：
  - `FILE1  -ef  FILE2`：FILE1与FILE2是否指向同一个文件系统的相同 inode的硬链接；
  - `FILE1  -nt  FILE2`：FILE1是否新于FILE2；
  - `FILE1  -ot  FILE2`：FILE1是否旧于FILE2；

- 组合测试条件：
  - 逻辑运算： 第一种方式
    - `COMMAND1 && COMMAND2`
    - `COMMAND1 || COMMAND2`
    - `! COMMAND`
    - `[ -O FILE ] && [ -r FILE ]`

  - 逻辑运算：第二种方式
    - `EXPRESSION1  -a  EXPRESSION2`
    - `EXPRESSION1  -o  EXPRESSION2`
    - `! EXPRESSION`
    - `[ -O FILE -a -x FILE ]`

### 练习：将当前主机名称保存至 hostName 变量中

``` SHELL
# 主机名如果为空，或者为localhost.localdomain，则将其设置为www.magedu.com
hostName=$(hostname)
[ -z "$hostName" -o "$hostName" == "localhost.localdomain" -o "$hostName" == "localhost" ] && hostname www.magedu.com
```

## 脚本的状态返回值

> 默认是脚本中执行的最后一条件命令的状态返回值；

自定义状态退出状态码：exit  [n]：n为自己指定的状态码；

注意：shell进程遇到exit时，即会终止，因此，整个脚本执行即为结束；

## 向脚本传递参数

位置参数变量

`myscript.sh  argu1 argu2`

引用方式：`$1,  $2, ..., ${10}, ${11}, ...`	

轮替：`shift  [n]`：位置参数轮替；

### 练习：写一脚本，通过命令传递两个文本文件路径给脚本，计算其空白行数之和；

``` SHELL
#!/bin/bash
file1_lines=$(grep "^$" $1 | wc -l)
file2_lines=$(grep "^$" $2 | wc -l)
echo "Total blank lines: $[$file1_lines+$file2_lines]"
```

- 特殊变量：
  - `$0`：脚本文件路径本身
  - `$#`：脚本参数的个数
  - `$*`：所有参数
  - `$@`：所有参数

## 过程式编程语言的代码执行顺序：

- 顺序执行：逐条运行；
- 选择执行：
  - 代码有一个分支：条件满足时才会执行；
  - 两个或以上的分支：只会执行其中一个满足条件的分支；
- 循环执行：
  - 代码片断（循环体）要执行0、1或多个来回；

## 选择执行

### 单分支的 if 语句

``` SHELL
if  测试条件
then
  代码分支
fi
```

### 双分支的if语句

``` SHELL
if  测试条件; then
  条件为真时执行的分支
else
  条件为假时执行的分支
fi
```

### 示例：通过参数传递一个用户名给脚本，此用户不存时，则添加之；

``` SHELL
#!/bin/bash
if ! grep "^$1\>" /etc/passwd &> /dev/null; then
  useradd $1
  echo $1 | passwd --stdin $1 &> /dev/null
  echo "Add user $1 finished."
fi
```

``` SHELL
#!/bin/bash
  if [ $# -lt 1 ]; then
    echo "At least one username."
    exit 2
fi
if ! grep "^$1\>" /etc/passwd &> /dev/null; then
  useradd $1
  echo $1 | passwd --stdin $1 &> /dev/null
  echo "Add user $1 finished."
fi
```

``` SHELL
#!/bin/bash
if [ $# -lt 1 ]; then
  echo "At least one username."
  exit 2
fi
if grep "^$1\>" /etc/passwd &> /dev/null; then
  echo "User $1 exists."
else
  useradd $1
  echo $1 | passwd --stdin $1 &> /dev/null
  echo "Add user $1 finished."
fi
```

### 练习：通过命令行参数给定两个数字，输出其中较大的数值；

``` SHELL
#!/bin/bash
if [ $# -lt 2 ]; then
  echo "Two integers."
  exit 2
fi

if [ $1 -ge $2 ]; then
  echo "Max number: $1."
else
  echo "Max number: $2."
fi
```

``` SHELL
#!/bin/bash
if [ $# -lt 2 ]; then
  echo "Two integers."
  exit 2
fi
declare -i max=$1
if [ $1 -lt $2 ]; then
  max=$2
fi
echo "Max number: $max."
```

### 练习2：通过命令行参数给定一个用户名，判断其ID号是偶数还是奇数

### 练习3：通过命令行参数给定两个文本文件名，如果某文件不存在，则结束脚本执行；都存在时返回每个文件的行数，并说明其中行数较多的文件

### 练习其他

1. 创建一个 20G 的文件系统，块大小为 2048，文件系统 ext4，卷标为 TEST，要求此分区开机后自动挂载至 /testing 目录，且默认有 acl 挂载选项；

创建 20G 分区

格式化：mke2fs -t ext4 -b 2048 -L 'TEST' /dev/DEVICE

编辑 /etc/fstab 文件

LABEL='TEST' 	/testing 	ext4 	defaults,acl 	0 0

2. 创建一个 5G 的文件系统，卷标HUGE，要求此分区开机自动挂载至 /mogdata 目录，文件系统类型为ext3；

3. 写一个脚本，完成如下功能：

列出当前系统识别到的所有磁盘设备；

如磁盘数量为1，则显示其空间使用信息；否则，则显示最后一个磁盘上的空间使用信息；

``` SHELL
if [ $disks -eq 1 ]; then
  fdisk -l /dev/[hs]da
else
  fdisk -l $(fdisk -l /dev/[sh]d[a-z] | grep -o "^Disk /dev/[sh]d[a-]" | tail -1 | cut -d' ' -f2)
fi
```

## bash脚本编程之用户交互

### read [option]... [name ...]

``` sh
-p 'PROMPT
-t TIMEOUT
```

检测脚本中的语法错误 `$ bash -n /path/to/some_script`

调试执行 `$ bash -x /path/to/some_script`

### 示例

``` sh
#!/bin/bash
# Version: 0.0.1
# Author: MageEdu
# Description: read testing
read -p "Enter a disk special file: " diskfile
[ -z "$diskfile" ] && echo "Fool" && exit 1
if fdisk -l | grep "^Disk $diskfile" &> /dev/null; then
  fdisk -l $diskfile
else
  echo "Wrong disk special file."
  exit 2
fi
```

### 脚本参数

> 用户交互：通过键盘输入数据，从而完成变量赋值操作

``` sh
#!/bin/bash
read -p "Enter a username: " name
[ -z "$name" ] && echo "a username is needed." && exit 2
read -p "Enter password for $name, [password]: " password
[ -z "$password" ] && password="password"
if id $name &> /dev/null; then
  echo "$name exists."
else
  useradd $name
  echo "$password" | passwd --stdin $name &> /dev/null
  echo "Add user $name finished."
fi
```

### 选择执行符号

- &&, ||
- if语句
- case语句

### if语句：三种格式

- 单分支的if语句

``` sh
if  CONDITION; then
if-true-分支
fi
```

- 双分支的if语句

``` sh
if  CONDITION; then
  if-true-分支
else
  if-false-分支
fi
```

- 多分支的if语句

``` sh
if  CONDITION1; then
  条件1为真分支
elif  CONDITION2; then
  条件2为真分支
else
  所有条件均不满足时的分支
fi
```

**注意**：即便多个条件可能同时都能满足，分支只会执行中其中一个，首先测试为“真”；

### 示例：脚本参数传递一个文件路径给脚本，判断此文件的类型

``` sh
#!/bin/bash
if [ $# -lt 1 ]; then
  echo "At least on path."
  exit 1
fi

if ! [ -e $1 ]; then
  echo "No such file."
  exit 2
fi

if [ -f $1 ]; then
  echo "Common file."
elif [ -d $1 ]; then
  echo "Directory."
elif [ -L $1 ]; then
  echo "Symbolic link."
elif [ -b $1 ]; then
  echo "block special file."
elif [ -c $1 ]; then
  echo "character special file."
elif [ -S $1 ]; then
  echo "Socket file."
else
  echo "Unkown."
fi
```

### 写一个脚本

1. 传递一个参数给脚本，此参数为用户名；
2. 根据其ID号来判断用户类型：

0： 管理员

1-999：系统用户

1000+：登录用户

``` shell
#!/bin/bash
[ $# -lt 1 ] && echo "At least on user name." && exit 1
! id $1 &> /dev/null && echo "No such user." && exit 2
userid=$(id -u $1)
if [ $userid -eq 0 ]; then
  echo "root"
elif [ $userid -ge 1000 ]; then
  echo "login user."
else
  echo "System user."
fi
```

### 写一个脚本

1. 列出如下菜单给用户

``` shell
disk) show disks info;
mem) show memory info;
cpu) show cpu info;
*) quit;
```

2. 提示用户给出自己的选择，而后显示对应其选择的相应系统信息；

``` shell
#!/bin/bash
cat << EOF
  disk) show disks info
  mem) show memory info
  cpu) show cpu info
  *) QUIT
EOF
read -p "Your choice: " option
if [[ "$option" == "disk" ]]; then
  fdisk -l /dev/[sh]d[a-z]
elif [[ "$option" == "mem" ]]; then
  free -m
elif [[ "$option" == "cpu" ]];then
  lscpu
else
  echo "Unkown option."
exit 3
fi
```

### 循环执行： 将一段代码重复执行0、1或多次；

- 进入条件：条件满足时才进入循环；
- 退出条件：每个循环都应该有退出条件，以有机会退出循环；

### bash脚本

- for循环
- while循环
- until循环

- for循环：两种格式：
  - 遍历列表
  - 控制变量

- 遍历列表

``` sh
for  VARAIBLE  in  LIST; do
  循环体
done
```

- 进入条件：只要列表有元素，即可进入循环
- 退出条件：列表中的元素遍历完成

### LIST的生成方式：列表过大是影响性能

- 直接给出
- 整数列表
  - {start..end}
  - seq [start  [incremtal]] last
    - only last (1-last)
- 返回列表的命令
- glob
- 变量引用: $@, $*

### 直接给出列表

``` sh
#!/bin/bash
for username in user21 user22 user23; do
  if id $username &> /dev/null; then
    echo "$username exists."
  else
    useradd $username && echo "Add user $username finished."
  fi
done
```

### 求100以内所有正整数之和；

``` sh
#!/bin/bash
declare -i sum=0
for i in {1..100}; do
  echo "\$sum is $sum, \$i is $i"
  sum=$[$sum+$i]
done
echo $sum
```

### 判断/var/log目录下的每一个文件的内容类型

``` sh
#!/bin/bash
for filename in /var/log/*; do
  if [ -f $filename ]; then
    echo "Common file."
  elif [ -d $filename ]; then
    echo "Directory."
  elif [ -L $filename ]; then
    echo "Symbolic link."
  elif [ -b $filename ]; then
    echo "block special file."
  elif [ -c $filename ]; then
    echo "character special file."
  elif [ -S $filename ]; then
    echo "Socket file."
  else
    echo "Unkown."
  fi
done
```

### 练习：

1. 分别求100以内所有偶数之和，以及所有奇数之和；
2. 计算当前系统上的所有用的id之和；
3. 通过脚本参数传递一个目录给脚本，而后计算此目录下所有文本文件的行数之和；并说明此类文件的总数；

- 选择执行： if, case
- 循环执行：for, while, until
- for循环格式：

``` sh
for VARAIBLE in LIST; do
  循环体
don
```

- while循环

``` sh
while  CONDITION; do
  循环体
  循环控制变量修正表达式
done
进入条件：CONDITION测试为”真“
退出条件：CONDITION测试为”假“
```

- until循环

``` sh
until  CONDITION; do
  循环体
  循环控制变量修正表达式
done
进入条件：CONDITION测试为”假“
退出条件：CONDITION测试为”真“
```

### 示例：求100以内所有正整数之和

``` sh
#!/bin/bash
#
declare -i sum=0
declare -i i=1

until [ $i -gt 100 ]; do
  let sum+=$i
  let i++
done
echo $sum
```

``` sh
#!/bin/bash
#
declare -i sum=0
declare -i i=1

while [ $i -le 100 ]; do
  let sum+=$i
  let i++
done
echo $sum
```

### 练习：分别使用for, while, until实现

1. 分别求100以内所有偶数之和，100以内所奇数之和；
2. 创建10个用户，user101-user110；密码同用户名；
3. 打印九九乘法表；
4. 打印逆序的九九乘法表；

``` sh
1X1=1
1X2=2  2X2=4
1X3=3  2X3=6  3X3=9
```

- 外循环控制乘数，内循环控制被乘数；

``` sh
#!/bin/bash
for j in {1..9}; do
  for i in $(seq 1 $j); do
    echo -n -e "${i}X${j}=$[${i}*${j}]\t"
  done
  echo
done
```

- for：列表元素非空；
- while：条件测试结果为“真”
- unitl：条件测试结果为“假”
- 退出条件：
  - for：列表元素遍历完成；
  - while：条件测试结果为“假”
  - until：条件测试结果为“真”

- 循环控制语句：

``` shell
continue：提前结束本轮循环，而直接进入下一轮循环判断；
```

``` shell
while  CONDITION1; do
  CMD1
    ...
  if  CONDITION2; then
    continue
  fi
  CMDn
  ...
done
```

### 示例：求100以内所有偶数之和

``` shell
#!/bin/bash
declare -i evensum=0
declare -i i=0
while [ $i -le 100 ]; do
  let i++
  if [ $[$i%2] -eq 1 ]; then
    continue
  fi
  let evensum+=$i
done
echo "Even sum: $evensum"

break：提前跳出循环, break n (层次)
while  CONDITION1; do
  CMD1
  ...
  if  CONDITION2; then
    break
  fi
done
```

## 创建死循环

``` shell
while true; do
  循环体
done
```

退出方式：

某个测试条件满足时，让循环体执行break命令；

### 示例：求100以内所奇数之和

``` shell
#!/bin/bash
declare -i oddsum=0
declare -i i=1
while true; do
let oddsum+=$i
  let i+=2
  if [ $i -gt 100 ]; then
    break
  fi
Done
```

### sleep命令：delay for a specified amount of time

`sleep NUMBER`

### 练习：每隔3秒钟到系统上获取已经登录用户的用户的信息；其中，如果logstash用户登录了系统，则记录于日志中，并退出；

``` shell
#!/bin/bash
while true; do
  if who | grep "^logstash\>" &> /dev/null; then
    break
  fi
  sleep 3
done
echo "$(date +"%F %T") logstash logged on" >> /tmp/users.log
```

``` shell
#!/bin/bash
until who | grep "^logstash\>" &> /dev/null; do
sleep 3
done

echo "$(date +"%F %T") logstash logged on" >> /tmp/users.log
while循环的特殊用法（遍历文件的行）：
while  read  VARIABLE; do
  循环体；
done  <  /PATH/FROM/SOMEFILE
依次读取/PATH/FROM/SOMEFILE文件中的每一行，且将基赋值给VARIABLE变量；
```

### 示例：找出ID号为偶数的用户，显示其用户名、ID及默认shell；

``` shell
#!/bin/bash
while read line; do
  userid=$(echo $line | cut -d: -f3)
  username=$(echo $line | cut -d: -f1)
  usershell=$(echo $line | cut -d: -f7)
  if [ $[$userid%2] -eq 0 ]; then
    echo "$username, $userid, $usershell."
  fi
done < /etc/passwd
```

- for循环的特殊用法

``` shell
for  ((控制变量初始化;条件判断表达式;控制变量的修正语句)); do
  循环体
done
控制变量初始化：仅在循环代码开始运行时执行一次；
控制变量的修正语句：每轮循环结束会先进行控制变量修正运算，而后再做条件判断；
```

### 求100以内所有正整数之和

``` shell
#!/bin/bash
declare -i sum=0
for ((i=1;i<=100;i++)); do
  let sum+=$i
done
echo "Sum: $sum."
```

### 示例：打印九九乘法表

``` shell
#!/bin/bash
for ((j=1;j<=9;j++)); do
  for ((i=1;i<=j;i++)); do
    echo -e -n "${i}X${j}=$[${i}*${j}]\t"
  done
  echo 22
done

case语句：
多分支if语句：
  if CONDITION1; then
   分支1
  elif  CONDITION2; then
    分支2
    ...
  else CONDITION; then
    分支n
  fi
```

### 示例1：显示一个菜单给用户

``` shell
cpu) display cpu information
mem) display memory information
disk) display disks information
quit) quit
```

## 要求

1. 提示用户给出自己的选择；

2. 正确的选择则给出相应的信息；否则，则提示重新选择正确的选项

``` shell
#!/bin/bash
cat << EOF
cpu) display cpu information
mem) display memory infomation
disk) display disks information
quit) quit
===============================
EOF

read -p "Enter your option: " option

while [ "$option" != "cpu" -a "$option" != "mem" -a "$option" != "disk" -a "$option" != "quit" ]; do
  echo "cpu, mem, disk, quit"
  read -p "Enter your option again: " option
done

if [ "$option" == "cpu" ]; then
  lscpu
elif [ "$option" == "mem" ]; then
  free -m
elif [ "$option" == "disk" ]; then
  fdisk -l /dev/[hs]d[a-z]
else
  echo "quit"
  exit 0
fi
```

### case语句的语法格式

``` shell
case  $VARAIBLE  in
PAT1)
  分支1
  ;;
PAT2)
  分支2
  ;;
...
*)
  分支n
  ;;
esac
```

### case支持glob风格的通配符：

- *：任意长度的任意字符；
- ?：任意单个字符；
- []：范围内任意单个字符；
- a|b：a或b；

### 示例：写一个服务框架脚本

- `$lockfile,  值/var/lock/subsys/SCRIPT_NAME`

1. 此脚本可接受start, stop, restart, status四个参数之一；
2. 如果参数非此四者，则提示使用帮助后退出；
3. start，则创建 lockfile，并显示启动；stop，则删除lockfile，并显示停止；restart，则先删除此文件再创建此文件，而后显示重启完成；status，如果lockfile存在，则显示running，否则，则显示为stopped.

``` shell
#!/bin/bash
#
# chkconfig: - 50 50
# description: test service script
#
prog=$(basename $0)
lockfile=/var/lock/subsys/$prog

case $1  in
start)
  if [ -f $lockfile ]; then
    echo "$prog is running yet."
  else
    touch $lockfile
    [ $? -eq 0 ] && echo "start $prog finshed."
  fi
  ;;
stop)
  if [ -f $lockfile ]; then
    rm -f $lockfile
    [ $? -eq 0 ] && echo "stop $prog finished."
  else
    echo "$prog is not running."
  fi
  ;;
restart)
  if [ -f $lockfile ]; then
    rm -f $lockfile
    touch $lockfile
    echo "restart $prog finished."
  else
    touch -f $lockfile
    echo "start $prog finished."
  fi
  ;;
status)
  if [ -f $lockfile ]; then
    echo "$prog is running"
  else
    echo "$prog is stopped."
  fi
  ;;
*)
  echo "Usage: $prog {start|stop|restart|status}"
  exit 1
esac
```

## 函数：function

> 把一段独立功能的代码当作一个整体，并为之一个名字；命名的代码段，此即为函数；

- 过程式编程：代码重用
  - 模块化编程
  - 结构化编程

- 注意：定义函数的代码段不会自动执行，在调用时执行；所谓调用函数，在代码中给定函数名即可；
- 函数名出现的任何位置，在代码执行时，都会被自动替换为函数代码

### 语法一

``` shell
function  f_name  {
  ...函数体...
}
```

### 语法二

``` shell
f_name()  {
  ...函数体...
}
```

- 函数的生命周期：每次被调用时创建，返回时终止；
- 其状态返回结果为函数体中运行的最后一条命令的状态结果；
- 自定义状态返回值，需要使用：return
  - return [0-255]
    - 0: 成功
    - 1-255: 失败

### 示例：给定一个用户名，取得用户的id号和默认shell

``` shell
#!/bin/bash
userinfo() {
  if id "$username" &> /dev/null; then
    grep "^$username\>" /etc/passwd | cut -d: -f3,7
  else
    echo "No such user."
  fi
}
username=$1
userinfo
username=$2
userinfo
```

### 示例2：服务脚本框架

``` shell
#!/bin/bash
#
# chkconfig: - 50 50
# description: test service script
#
prog=$(basename $0)
lockfile=/var/lock/subsys/$prog

start() {
  if [ -f $lockfile ]; then
    echo "$prog is running yet."
  else
    touch $lockfile
    [ $? -eq 0 ] && echo "start $prog finshed."
  fi
}

stop() {
  if [ -f $lockfile ]; then
    rm -f $lockfile
    [ $? -eq 0 ] && echo "stop $prog finished."
  else
    echo "$prog is not running."
  fi
}
status() {
  if [ -f $lockfile ]; then
    echo "$prog is running"
  else
    echo "$prog is stopped."
  fi
}

usage() {
  echo "Usage: $prog {start|stop|restart|status}"
}

case $1 in
start)
  start ;;
stop)
  stop ;;
restart)
  stop
  start ;;
status)
  status ;;
*)
  usage
  exit 1 ;;
esac
```

### 函数返回值

- 函数的执行结果返回值：
  - (1) 使用echo或printf命令进行输出；
  - (2) 函数体中调用的命令的执行结果；
- 函数的退出状态码：
  - (1) 默认取决于函数体中执行的最后一条命令的退出状态码；
  - (2) 自定义：return

### 函数可以接受参数：

- 传递参数给函数：
  - 在函数体中当中，可以使用$1，$2, ...引用传递给函数的参数；还可以函数中使用$*或$@引用所有参数，$#引用传递的参数的个数；
  - 在调用函数时，在函数名后面以空白符分隔给定参数列表即可，例如，testfunc  arg1 arg2 arg3 ...

### 示例：添加10个用户，

> 添加用户的功能使用函数实现，用户名做为参数传递给函数；

``` shell
#!/bin/bash
# 5: user exists

addusers() {
  if id $1 &> /dev/null; then
    return 5
  else
    useradd $1
    retval=$?
    return $retval
  fi
}

for i in {1..10}; do
  addusers ${1}${i}
  retval=$?
  if [ $retval -eq 0 ]; then
    echo "Add user ${1}${i} finished."
  elif [ $retval -eq 5 ]; then
    echo "user ${1}${i} exists."
  else
    echo "Unkown Error."
  fi
done
```

### 练习：写一个脚本

- 使用函数实现ping一个主机来测试主机的在线状态；主机地址通过参数传递给函数；
- 主程序：测试172.16.1.1-172.16.67.1范围内各主机的在线状态；

### 变量作用域

- 局部变量：作用域是函数的生命周期；在函数结束时被自动销毁；
  - 定义局部变量的方法：local VARIABLE=VALUE
- 本地变量：作用域是运行脚本的shell进程的生命周期；因此，其作用范围为当前shell脚本程序文件；

### 示例程序

``` shell
#!/bin/bash
name=tom

setname() {
  local name=jerry
  echo "Function: $name"
}
setname
echo "Shell: $name"
```

### 函数递归：

> 函数直接或间接调用自身

``` SHELL
#!/bin/bash
fact() {
  if [ $1 -eq 0 -o $1 -eq 1 ]; then
    echo 1
  else
    echo $[$1*$(fact $[$1-1])]
  fi
}

fact $1
```

``` SHELL
#!/bin/bash
fab() {
  if [ $1 -eq 1 ]; then
    echo -n "1 "
  elif [ $1 -eq 2 ]; then
    echo -n "1 "
  else
    echo -n "$[$(fab $[$1-1])+$(fab $[$1-2])] "
  fi
}

for i in $(seq 1 $1); do
  fab $i
done
```

## 数组

- 变量：存储单个元素的内存空间；
- 数组：存储多个元素的连续的内存空间；
- 数组名：整个数组只有一个名字；
- 数组索引：编号从0开始；
- 数组名[索引]
- ${ARRAY_NAME[INDEX]}

- 注意：bash-4及之后的版本，支持自定义索引格式，而不仅仅是0，1,2，...数字格式；此类数组称之为“关联数组”

### 声明数组

- `declare  -a  NAME`：声明索引数组；
- `declare  -A  NAME`：声明关联数组；

###　数组中元素的赋值方式：

一次只赋值一个元素；`ARRAY_NAME[INDEX]=value`

一次赋值全部元素；`ARRAY_NAME=("VAL1"  "VAL2"  "VAL3"  ...)`

只赋值特定元素；

`ARRAY_NAME=([0]="VAL1"  [3]="VAL4" ...)`

注意：bash支持稀疏格式的数组；

`read -a ARRAY_NAME`

### 引用数组中的元素：${ARRAY_NAME[INDEX]}

- 注意：引用时，只给数组名，表示引用下标为0的元素；

### 数组的长度（数组中元素的个数）:

`${#ARRAY_NAME[*]}`

`${#ARRAY_NAME[@]}`

### 示例：生成10个随机数，并找出其中的最大值和最小值；

``` SHELL
#!/bin/bash
declare -a  rand
declare -i max=0

for i in {0..9}; do
  rand[$i]=$RANDOM
  echo ${rand[$i]}
  [ ${rand[$i]} -gt $max ] && max=${rand[$i]}
done
echo "MAX: $max"
```

练习：生成10个随机数，而后由小到大进行排序

定义一个数组，数组中的元素是/var/log目录下所有以.log结尾的文件；统计其下标为偶数的文件中的行数之和

``` SHELL
#!/bin/bash
declare -a files
files=(/var/log/*.log)

declare -i lines=0

for i in $(seq 0 $[${#files[*]}-1]); do
  if [ $[$i%2] -eq 0 ]; then
    let lines+=$(wc -l ${files[$i]} | cut -d' ' -f1)
  fi
done
echo "Lines: $lines."
```

### 引用数组中的所有元素：

`${ARRAY_NAME[*]}`

`${ARRAY_NAME[@]}`

### 数组元素切片： `${ARRAY_NAME[@]:offset:number}`

offset：要路过的元素个数；

number：要取出的元素个数；省略number时，表示取偏移量之后的所有元素；

### 向非稀疏格式数组中追加元素：

`ARRAY_NAME[${#ARRAY_NAME[*]}]=`

### 删除数组中的某元素：

`unset  ARRAY[INDEX]`

### 关联数组：

`declare  -A  ARRAY_NAME`

`ARRAY_NAME=([index_name1]="value1"  [index_name2]="value2" ...`

## bash的内置字符串处理工具

### 字符串切片

``` SHELL
${var:offset:number}
取字符串的子串
取字符串的最右侧的几个字符：${var: -length}
注意：冒号后必须有一个空白字符；
```

### 基于模式取子串：

${var#*word}：其中word是指定的分隔符；功能：自左而右，查找var变量所存储的字符串中，第一次出现的word分隔符，删除字符串开头至此分隔符之间的所有字符；

${var##*word}：其中word是指定的分隔符；功能：自左而右，查找var变量所存储的字符串中，最后一次出现的word分隔符，删除字符串开头至此分隔符之间的所有字符；

``` shell
mypath="/etc/init.d/functions"
${mypath##*/}:   functions
${mypath#*/}:  etc/init.d/functions
```

${var%word*}：其中word是指定的分隔符；功能：自右而左，查找var变量所存储的字符串中，第一次出现的word分隔符，删除此分隔符至字符串尾部之间的所有字符；

${var%%word*}：其中word是指定的分隔符；功能：自右而左，查找var变量所存储的字符串中，最后一次出现的word分隔符，删除此分隔符至字符串尾部之间的所有字符；

``` shell
mypath="/etc/init.d/functions"
${mypath%/*}:  /etc/init.d
url=http://www.magedu.com:80
${url##*:}
${url%%:*}
```

### 查找替换

${var/PATTERN/SUBSTI}：查找var所表示的字符串中，第一次被PATTERN所匹配到的字符串，将其替换为SUBSTI所表示的字符串；

${var//PATTERN/SUBSTI}：查找var所表示的字符串中，所有被PATTERN所匹配到的字符串，并将其全部替换为SUBSTI所表示的字符串；

${var/#PATTERN/SUBSTI}：查找var所表示的字符串中，行首被PATTERN所匹配到的字符串，将其替换为SUBSTI所表示的字符串；

${var/%PATTERN/SUBSTI}：查找var所表示的字符串中，行尾被PATTERN所匹配到的字符串，将其替换为SUBSTI所表示的字符串；

注意：PATTERN中使用glob风格和通配符；

### 查找删除

${var/PATTERN}：以PATTERN为模式查找var字符串中第一次的匹配，并删除之；

${var//PATERN}

${var/#PATTERN}

${var/%PATTERN}

### 字符大小写转换

${var^^}：把var中的所有小写字符转换为大写

${var,,}：把var中的所有大写字符转换为小写

### 变量赋值

${var:-VALUE}：如果var变量为空或未设置，那么返回VALUE；否则，则返回var变量的值；

${var:=VALUE}：如果var变量为空或未设置，那么返回VALUE，并将VALUE赋值给var变量；否则，则返回var变量的值；

${var:+VALUE}：如果var变量不空，则返回VALUE；
${var:?ERROR_INFO}：如果var为空或未设置，那么返回ERROR_INFO为错误提示；否则，返回var值；

### 练习：写一个脚本，完成如下功能

1. 提示用户输入一个可执 行命令的名称；
2. 获取此命令所依赖到的所有库文件列表；
3. 复制命令至某目标目录（例如/mnt/sysroot，即把此目录当作根）下的对应的路径中

``` shell
bash,  /bin/bash  ==> /mnt/sysroot/bin/bash
useradd, /usr/sbin/useradd  ==>  /mnt/sysroot/usr/sbin/useradd
```

4. 复制此命令依赖到的所有库文件至目标目录下的对应路径下；
`/lib64/ld-linux-x8664.so.2  ==>  /mnt/sysroot/lib64/ld-linux-x8664.so.2`

### 进一步

- 每次复制完成一个命令后，不要退出，而是提示用户继续输入要复制的其它命令，并重复完成如上所描述的功能；直到用户输入“quit”退出脚本；

ping命令去查看172.16.1.1-172.16.67.1范围内的所有主机是否在线；在线的显示为up, 不在线的显示down，分别统计在线主机，及不在线主机数；

- 分别使用for, while和until循环实现。

``` shell
#!/bin/bash

declare -i uphosts=0
declare -i downhosts=0

for i in {1..17}; do
  if ping -W 1 -c 1 172.16.$i.1 &> /dev/null; then
    echo "172.16.$i.1 is up."
    let uphosts+=1
  else
    echo "172.16.$i.1 is down."
    let downhosts+=1
  fi
done
echo "Up hosts: $uphosts, Down hosts: $downhosts."
```

``` shell
#!/bin/bash
declare -i uphosts=0
declare -i downhosts=0
declare -i i=1

hostping() {
  if ping -W 1 -c 1 $1 &> /dev/null; then
    echo "$1 is up."
    return 0
  else
    echo "$1 is down."
    return 1
  fi
}

while [ $i -le 67 ]; do
  hostping 172.16.$i.1
  [ $? -eq 0 ] && let uphosts++ || let downhosts++
  let i++
done

echo "Up hosts: $uphosts, Down hosts: $downhosts."
```

### 写一个脚本，实现：能探测C类、B类或A类网络中的所有主机是否在线

``` shell
#!/bin/bash
cping() {
  local i=1
  while [ $i -le 5 ]; do
    if ping -W 1 -c 1 $1.$i &> /dev/null; then
      echo "$1.$i is up"
    else
      echo "$1.$i is down."
    fi
    let i++
  done
}
bping() {
  local j=0
  while [ $j -le 5 ]; do
    cping $1.$j
    let j++
  done
}
aping() {
  local x=0
  while [ $x -le 255 ]; do
    bping $1.$x
    let x++
  done
}
```

### 提示用户输入一个IP地址或网络地址；获取其网络，并扫描其网段

### 信号捕捉

>信号：进程间通信

- 列出信号

``` shell
# trap  -l
# kill  -l
# man  7  signal
# trap  'COMMAND'  SIGNALS
```

常可以进行捕捉的信号：HUP， INT

## 示例 CODE

``` shell
#!/bin/bash
declare -a hosttmpfiles
trap  'mytrap'  INT

mytrap()  {
  echo "Quit"
  rm -f ${hosttmpfiles[@]}
  exit 1
}

for i in {1..50}; do
  tmpfile=$(mktemp /tmp/ping.XXXXXX)
  if ping -W 1 -c 1 172.16.$i.1 &> /dev/null; then
    echo "172.16.$i.1 is up" | tee $tmpfile
  else
    echo "172.16.$i.1 is down" | tee $tmpfile
  fi
  hosttmpfiles[${#hosttmpfiles[*]}]=$tmpfile
done
rm -f ${hosttmpfiles[@]}
```

## dialog命令可实现窗口化编程；

各窗体控件使用方式；

如何获取用户选择或键入的内容？

默认，其输出信息被定向到了错误输出流；

a=$(dialog)

《高级 bash 编程指南》

《Linux 命令行和 shell 脚本编程宝典》