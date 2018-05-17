# Program package Management 程序包管理

## 单片机

> 单片机又称单片微控制器,它不是完成某一个逻辑功能的芯片,而是把一个计算机系统集成到一个芯片上。相当于一个微型的计算机，和计算机相比，单片机只缺少了I/O设备。一块芯片就成了一台计算机。它的体积小、质量轻、价格便宜、为学习、应用和开发提供了便利条件。同时，学习使用单片机是了解计算机原理与结构的最佳选择

---

## 接口

- API：Application Program Interface
- ABI：Application Binary Interface

--

## 系统文件格式

- Unix-like文件内容格式：ELF
- Windows：exe, msi

---

## 库级别的虚拟化

- Linux: WinE
- Windows: Cywin

---

## 系统级开发

- C/C++：httpd, vsftpd, nginx
- Go

---

## 应用级开发

- Java: hadoop, hbase (依赖于jvm)
- Python：openstack, (依赖于pvm)
- Perl: (依赖于perl解释器)
- Ruby: (依赖于rvm)
- PHP: (依赖于php解释器)

---

## C/C++程序格式

- 源代码：文本格式的程序代码；
  - 编译开发环境：编译器、头文件、开发库
- 二进制格式：文本格式的程序代码 -> 编译器 -> 二进制格式（binary、lib、etc、man）
  - 二进制程序文件、库文件、配置文件、帮助文件

--

## Java/Python程序格式

- 源代码：编译成能够在其虚拟机(jvm/pvm)运行的格式；
  - 开发环境：编译器、开发库
- 二进制

---

## 项目构建工具

- C/C++: make
- Java: maven
- Web: gulp, grunt, webpack, rollup

---

## 程序包管理器

- 源代码 -> 目标二进制格式（bin,lib,etc,man->组织成为一个或有限几个“包”文件；
- 安装、升级、卸载、查询、校验

## 程序包管理器种类

- debian: dpt, dpkg, .deb
- redhat: redhat package manager, rpm, .rpm(rpm is package manager)
- S.u.S.E: rpm, .rpm
- Gentoo: ports
- ArchLinux: pacman

## 源代码：

- name-VERSION.tar.gz
- VERSION：major.minor.release

- 主版本号: 架构
- 次版本号: 功能
- 发行号: 修复

## rpm包命名格式：name-VERSION-release.os.arch.rpm 

- VERSION: major.minor.release(程序发行号)
- release: rpm包的发行号
- os: 操作系统
- archetecture: 系统架构；i386, x64(amd64), ppc, noarch
- noarch: 有些程序基于java,python虚拟机上编写的
- VERSION-2.el7.i386.rpm
  - redis-3.0.2.targz --> redis-3.0.2-1.centos7.x64.rpm 

- 拆包：主包和支包
  - 主包：name-VERSION-release.arch.rpm 
  - 支包：name-function-VERSION-release.arch.rpm 
  - function：devel, utils, libs, ...

## 依赖关系

- X, Y, Z
- X --> Y,Z
  - Y --> A, B, C
    - C --> Y

## 前端工具：自动解决依赖关系

- **yum**: rhel系列系统上rpm包管理器的前端工具
- **apt-get**(apt-cache): deb包管理器的前端工具
- **zypper**: suse的rpm管理器前端工具
- **dnf**: Fedora 22+系统上rpm包管理器的前端工具

## 程序包管理器详解

> 功能：将编译好的应用程序的各组成文件打包成一个或几个程序包文件，从而更方便地实现程序包的安装、升级、卸载和查询等管理操作

### 程序包的组成清单（每个程序包都单独实现）

- 文件清单
- 安装或卸载时运行的脚本

### 数据库（公共）

- 程序包的名称和版本
- 依赖关系
- 功能说明
- 安装生成的各文件的文件路径及校验码信息

- rpm数据库文件路径：`# ls /var/lib/rpm/`

### 获取程序包的途径

1. 系统发行版的光盘或官方的文件服务器（或镜像站点）
- http://mirrors.aliyun.com 
- http://mirrors.sohu.com
- http://mirrors.163.com 

2. 项目的官方站点

3. 第三方组织

- EPEL
- 搜索引擎
  - http://pkgs.org
  - http://rpmfind.net 
  - http://rpm.pbone.net 

4. 自动动手，丰衣足食

- 建议：检查其合法性-依赖于签名密钥
  - 来源合法性
  - 程序包的完整性

### CentOS系统上rpm命令管理程序包

> 安装、升级、卸载、查询、校验、数据库维护

#### rpm命令

``` 常用命令
rpm [OPTIONS] [PACAGE_FILE]
安装：-i, --install
升级：-U,--update, -F, --freshen
卸载：-e, --erase
查询：-q, --query
校验：-V, -verify
数据库维护：--builddb, --initdb
```

#### 安装：-i, --install

``` 安装命令
rpm {-i|--install} {install-options} PACKAGE_FILE
rpm -ivh PACKAGE_FILE

GENERAL OPTIONS:
-v：verbose
-vv：更详细

[install-options]:
-h, --hash：输出进度条；每个#表示2%的进度
--test：测试安装，检查并报告依赖关系及冲突消息等
--nodeps：忽略依赖关系强制安装
--replacepkgs：重新安装（配置文件删除之后之后重新安装）
--noscript：不执行校验脚本（任何脚本）
--nosignature：不检查包签名信息，不检查来源合法性
--nodigest：不检查包完整性信息;md5信息

- 注意：rpm自带脚本, --noscript（都不执行一下脚本）
preinstall：安装过程开始之前运行的脚本，%pre，--nopre
postinstall：安装过程完成之后运行的脚本，%post，--nopost
preuninstall：卸载过程真正开始执行之前运行的脚本，%preun，--nopreun
postuninstall：卸载过程完整之后运行的脚本：%postun，--nopostun
```

#### 升级：-U,--update, -F,--freshen

``` 升级命令
rpm {-U|--upgrade} {options} PACKAGE_FILE...
rpm {-F|--freshen} {options} PACKAGE_FILE...
-U：升级或安装
-F：升级

rpm -Uvh PACKAGE_FILE...
rpm -Fvh PACKAGE_FILE...

--oldpackage: 降级为较老版本
--force: 强制升级
--nodeps
--noscript
--test
```

- **注意**
1. 不要对内核升级操作；Linux支持多内核版本并存，直接安装新版本内核；
2. 如果某原程序包的配置文件安装后曾被修改过，升级时，新版本的程序提供的同一个配置文件不会覆盖原有版本的配置文件，而是把新版本的配置文件重命名(FILENAME.rpmnew)后提供；

#### 卸载：-e,--erase

``` 卸载命令
rpm {-e|--erase} {options} PACKAGE_NAME...
--allmatches: 卸载所有匹配指定名称的程序包的各版本；
--nodeps: 忽略依赖关系
--test: 测试卸载，dry run模式
```

### 查询：-q, --query

``` 查询命令
rpm {-q|--query} {select-options} {query-options} PACKAGE_NAME
- {select-options}

PACKAGE_NAME: 查询指定的程序包是否已经安装及其版本
-a,--all: 查询所有已经安装过的包
-f, --file FILE：查询指定的文件由哪个包生成
-p,--package PACKAGE_FILE：未安装的程序包执行查询操作
```

``` 实例
rpm -qpl zsh-5.0.2-7.el7_1.2.x86_64.rpm`
rpm -qpi zsh-5.0.2-7.el7_1.2.x86_64.rpm`
rpm -qpc zsh-5.0.2-7.el7_1.2.x86_64.rpm`
rpm -qpd zsh-5.0.2-7.el7_1.2.x86_64.rpm`
rpm -q --scripts zsh-5.0.2-7.el7_1.2.x86_64.rpm`
--whatprovides CAPABILITY：查询指定的CAPABILITY由哪个程序包提供
--whatrequires CAPABILITY：查询指定的CAPABILITY被哪个包所依赖

- [query-options]
--changelog：rpm包的changelog,版本迭代信息
-l, --list：程序包安装生成的所有文件列表
-i,--info：查询程序包信息，版本号、大小、所属的包组等
-c,--configfiles：查询指定程序包提供的配置文件
-d, --docfile：查询指定的程序包的帮助文档
--provides：列出指定的程序包提供的CAPABILITY
```

``` 项目依赖
rpm -q --whatprovides bash`
rpm -q --whatprovides 'config(bash)'`
-R，--requires：查询指定程序包所依赖关系，依赖关系先解决
--script：查询程序包的脚本代码
Relocations: 重新定位到新的路径下安装
```

- 已安装包查询操作

``` 已经安装查询操作选项
-qi PCK
-qf FILE
-qc PCK
-ql PCK
-qd PCK
```

- 未安装的包查询操作

``` 未安装的包查询选项
-qpi PACKAGE_FILE
-qpl PACKAGE_FILE
-qpc PACKAGE_FILE
-qpd PACKAGE_FILE
-qpR PACKAGE_FILE
```

### 校验：-V, --Verify

``` 校验选项
--nodeps
--nodigest： 校验信息
--nofiles
--noscripts
--nosignature 完整性
--nofiledigest(--nomd5) 校验码
--nolinkto
--nosize
--nouser
--nogroup

rpm -V zsh
修改包的某个文件只有 # rpm -V zsh
```

### 校验结果

- S: file **Size** differs
- M: **mode** differs
- D: **Device** major/minor number mismatch 主次设备号不匹配
- L: **readLink(2)** path mismatch 
- 5: digest(formerly **MD5** sum) differs
- T: **mTime** differs
- U：**User** ownership differ
- P: **Capabilities** differ

### 包来源合法性验证和完整性验证

#### 来源合法性验证

- 生成一对密钥
- 包的后面添加(私钥)数字签名(digital signature)
- 公钥提供给所有人

1. 包的制作者使用**单向加密**计算出**程序包的特征码**定长输出
2. 然后在用自己的**私钥加密**这个**特征码（数字签名）**，并且把加密后的特征码附加在**包的后面**
3. 包使用者使用**公钥解密**附加在包后面的**数字签名**，取出**特征码（来源合法性得到验证）**，并使用**单向加密**技术**对包计算出特征码**，在与其上**特征码进行比较**是否相等（**包完整性得到验证**）。

#### 获取并导入信任的包作者的公钥

1. 对于CentOS发行版

``` command
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
```

2. RPM-GPG-KEY-CentOS-7(在光盘里有RPM公钥)

``` RPM公钥
rpm --import /media/cdrom/RPM-GPG-KEY-CentOS-7
```

#### 验证

1. 安装此组织签名的程序时，会自动执行验证
2. 手动验证：`# rpm -K zsh-2.0.1.el7.rpm`

#### 来源合法性验证方法

- rsa sha1(md5)
- pgp md5

- RSA: 公开密钥密码体制就是使用不同的加密密钥与解密密钥，是一种“由已知加密密钥推导出解密密钥在计算上是不可行的”密码体制
- GPG: (Pretty Good Privacy，更好地保护隐私)，是一个基于RSA公钥加密体系的邮件加密软件。

- **数字签名**：使用私钥加密对应数据单向加密的特征码

### 数据库重建：--builddb, --initdb

#### rpm管理器数据库路径：`/var/lib/rpm/`

> 查询操作：通过此处的数据库进行

####　获取帮助

- CentOS 6: `# man rpm`
- CentOS 7: `# man rpmdb`

#### 数据库损坏解决方案

``` command
rpm {--initdb | --rebuilddb}

--initdb：初始化数据库，当前无任何数据库可初始化创建一个新的；当前有时不执行任何操作
--rebuilddb：重新构建，通过读取当前系统上所有已经安装过的程序包进行重新创建
--dbpath/tmp/rpm：指明新的路径下初始化数据库

```

``` shell
# mkdir /tmp/rpm
# rpm --initdb --dbpath=/tmp/rpm
# ls /tmp/rpm/
# rpm --rebuilddb --dbpath=/tmp/rpm
```

## yun 管理器

- C/S 架构
  - Server
    - 支持 ftp 和 http, createrepo 创建仓库
  - Client
    1. yum 命令读取配置文件远程访问 yum 源
    2. 读取 Server 的依赖关系的数据缓存到本地当中
    3. 根据依赖关系从远程下载依赖关系的程序包并安装程序包
    4. 删除 cache 源数据依赖关系，保留程序包

- 远程下载的源数据跟本地的源数据文件校验码进行比较，如果不相等就再次下载源数据文件

- YUM: yellow dog update modifier
> yum repository: yum repo
> 存储了众多rpm包，以及包的相关的**元数据**文件（放置于特定目录下：**repodata**）

- 仓库文件服务器
  - ftp://
  - http://
  - nfs://
  - file:///

### yum 客户端

- 配置文件：`# rpm -qc yum`
  - `/etc/yum.conf`: 主配置文件(为所有仓库提供公共配置)
  - `/etc/yum.repo.d/*.repo`: 为仓库的指向提供配置

- `/etc/yum.conf`

``` yum.conf
cachedir=/var/cache/yum/$basearch/$releasever 缓存目录
keepcache=0  是否本地保留缓存
debuglevel=2 调试级别
logfile=/var/log/yum.log 安装日志文件
exactarch=1 精确严格平台匹配
obsoletes=1 过时的
gpgcheck=1 来源合法性和包完整性
plugins=1 插件机制
installonly_limit=5
bugtracker_url=http://bugs.centos.org/set_project.php?project_id=19&ref=http://bugs.centos.org/bug_report_page.php?category=yum
distroverpgk=centos-release 发行版号
```

``` SOURCE
# whatis yum.conf
# man 5 yum.conf
```

#### 仓库指向的定义

``` SOURCE
[repositoryID]
name=Some name for this repository
baseurl=url://server1/path/to/repository/
  url://server1/path/to/repository/
  url://server1/path/to/repository/
enable={1|0}
gpgcheck={1|0}

repo_gpgcheck={1|0}  元数据文件数字签名验证
gpgkey=URL gpg的密钥文件
enablegroups={1|0} 是否使用组管理程序包
failovermethod= {roundrobin or priority} 轮循(随机) 优先级
roundrobin 默认
username
password
cost 开销,默认1000
mirrorlist 必须支持plugin
```

### 创建 YUM

``` SOURCE
[base]
name=Base Repo on 192.168.1.100
baseurl=http://IP/path/to/ repodata所在目录
enable=1
gpgcheck=0

[epel]
name=Fedora EPEL for El6 
base=http:/IP/path/to/
gpgcheck=0
```

### yum 命令

``` SOURCE
# yum [opitons] [command] [package ...]
# yum help [command]
```

### 显示仓库列表

``` command
# yum repolist [all | enabled | disabled]
```

### 显示程序包

``` command
# yum list [all | glob_exp] [glob_exp2]
# yum list installed [glob_exp1] [...] yum安装的包
# yum list available [glob_exp1] [...] 可安装的包
# yum list updates [glob_exp1] [...] 可升级的包

# yum list extras [glob_exp1] [...] 额外的
# yum list obsoletes [glob_exp1] [...] 废弃的
```

- @anaconda... 操作系统安装的包
- installed
- avalible

### 安装程序包

``` command
# yum -y install package[-version] ...
```

### 重新安装

``` command
# yum reinstall package
```

### 查看指定包所依赖胡capabilities：

``` command
# yum deplist package
```

###　降级程序包

``` command
# yum downgrade package
```

### 升级程序包：

``` SOURCE
# yum update package ...
# yum update-to package ...
```

### 检查可用升级

``` command
# yum check-update
```

### 卸载程序包：

``` command
# yum remove | erase package1...
```

### 查看程序包信息：

``` command
# yum info package1...
```

### 查看指定的特性（可以是某文件）是由哪个程序包所提供：

``` command
# yum provides | whatprovides feature1 ...
```

- 相似-qf

### 清理本地缓存

``` command
yum clean [ package | metadata | expire-cache | rpmdb | plugins | all]
```

### 构建缓存:

> 取各各仓库获取元数据到本地

``` command
# yum makecache
```

### 搜索：模糊匹配

> 以指定的关键字搜索程序包名及summary信息

``` source
# yum search package_name
```

### yum事务历史（安装、升级、卸载）

``` SOURCE
# yum history [list | info | stats]
```

### 安装及升级本地程序包（自动解决依赖关系包）

``` SOURCE
# yum localinstall rpmfile
# yum localupdate rpmfile
```

###　包组相关命令

``` SOURCE
# yum grouplist
# yum -y groupinstall "group_package_name"
# yum groupupdate "group_package_name"
# yum groupremove "group_package_name"
# yum groupinfo "group_package_name"
```

### 如何使用光盘当作本地yun仓库

1. 挂载光盘至某目录，例如/media/cdrom 

``` source
# mount -r -t iso9660 /dev/cdrom /media/cdrom`
```

2. 创建配置文件

``` source
[CentOS7-CDROM]
name=cdrom repository
baseurl=file:///media/cdrom
gpgcheck=0
enabled=0
```

### yum的命令行选项：

``` source
--nogpgcheck：禁止进行gpg check
-y：自动回答为yes
-q：静默模式
--disablerepo=repoidglob：临时禁用对此处指定的repo
--enablerepo=repoidglob：临时启用此处指定的repo
--noplugins：禁用所有插件
```

### yum的repo配置文件中可用的变量：

``` source
$releasever: 当前OS的发行版的主版本号
$arch: 平台
$basearch: 基础平台, i386,x86_64 都认为 i386
$YUM0-$YUM9
```

> http://mirrors.lingyima.com/centos/$releasever/$basearch/os
> http://mirrors.lingyima.com/centos/6/i386/os
> http://mirrors.lingyima.com/centos/6/x86_64/os
> http://mirrors.lingyima.com/centos/7/x86_64/os

### 创建yum仓库

#### 1. 安装createrepo包

``` source
# yum -y install createrepo
```

#### 2. ftp里连接发送rpm文件

``` SOURCE
# !mkdir -p /yum/repo
# lcd /yum/repo
# mget *.rpm
```

#### 3. 创建yum仓库

``` SOURCE
# cd /yum/repo
# createrepo ./

[xen4entos]
name=Xen 4 CentOS
baseurl=file:///yum/repo
gpgcheck=0
enabled=1
```

---

## 程序包编译安装

- testapp-VERSION-release.src.rpm
- 源代码 -> 预处理 -> 编译(gcc) -> 汇编 -> 连接 -> 执行
- 安装后，使用**rpmbuild命令**制作成二进制格式的rpm包，而后再安装

### 源代码组织格式

- 多文件：文件中的代码之间，很可能存在跨文件依赖关系

###　项目管理工具

- C/C++: make
  - configure —> Makefile.in模板 —> makefile
- Java: maven

### C代码编译安装三步骤

1. `# ./configure`
- 通过选项传递参数，指定启用特性、安装路径等；执行时会参考用户的指定以及Makefile.in文件生成makefile
- 检查依赖到的外部环境

2. `# make`
- 根据makefile文件，构建应用程序

3. `# make install`

### 开发工具：以下两个工具依赖其程序包的配置文件

- autoconf：生成 configure 脚本
- automake：生成 Makefile.in

> 建议：安装前查看INSTALL，README

### 开源程序源代码的获取

#### 官方自建站点

- Apache.org(ASF)
- mariadb.org

#### 代码托管

- SourceForge
- Github.com
- code.google.com

### 编译 C 源代码

- 前提：提供开发工具及开发环境
  - 开发工具：make, gcc等
  - 开发环境：开发库，头文件 
    - glibc：标准库

#### 1.通过包组提供开发组件 CentOS 6

``` SOURCE
# yum -y groupinstall "Development Tools"
# yum -y groupinstall "Server Platform Development"
```

#### 2. configure 脚本

> 选项：指定安装位置、指定启用的特性

- `# ./configure --help`：获取其支持的使用的选项
- 安装路径设定：

``` options
--prefix=/PATH/TO/SOMEWHERE`：指定默认安装位置;默认为/usr/local/APPNAME
--sysconfdir=/PATH/TO/SOMEWHERE`：配置文件安装路径`
```

- System types：交叉编译使用这里的选项

``` options
--build=BUILD
--host=HOST
--target=TARGET
```

- Optional Features: 可选特性

``` options
--disable-FEATURE
--enable-FEATURE[=ARG]
```

- Optional Packages：依赖的可选程序包

``` options
--with-PACKAGE[=ARG]
--without-PACKAGE
```

#### 3. make && make install

#### 4. 安装后的配置

1.导出二进制程序目录至PATH环境变量中

- 编辑文件 **/etc/procile.d/NAME.sh**
  - `export PATH=/PATH/TO/BIN:$PATH`

2.导出库文件路径

- 编辑 /etc/ld.so.conf.d/NAME.conf
  - 添加新的库文件所在目录至此文件中：/usr/local/apache2/lib
  - 让系统重新生成缓存：
    - `# ldconfig [-v]`

3.导出头文件

> 基于链接的方式实现：

``` SOURCE
# ln -sv /usr/local/apache2/include/ /usr/include/apache
```

4.导出帮助手册

- 编辑**/etc/man.config**文件 
- MANPATH /usr/local/apache2/man`

#### Setup httpd-2.2.29

``` SOURCE
# ./configure --prefix=/usr/local/apache2
# apachectl [ start | stop | restart ] 脚本文件
```

## 练习

- yum的配置和使用：包括yum repository的创建
- 编译安装apche 2.2；启动此服务

- 博客：程序包管理器、rpm、yum、编译
- 桌面环境：Windows7, OpenSUSE 13.2, Kubuntu(KDE) 