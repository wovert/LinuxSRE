# 运维: Operations

## 1. 操作系统安装

- bare metal(裸机上安装): pxe(网卡->raw设备->预引导执行环境， 只能引导)
  - cobbler(二次封装 pxe环境)
  - 硬件支持 PXE 技术
- virtual machine(虚拟机上安装): 安装模版

## 2. Configuration(应用程序安装、配置)

- 问题：多个服务器安装应用程序，100台服务器
- 解决工具：
  - **puppet(ruby)** 重量级(学习困难)
  - **saltstack(python)**
  - **chef**
  - **cfengine**

## 3. Command and Control

- **fabric**(Python，轻量级)
- **func**

## 4. 程序发布

- 手动发布（人工智能）
- 脚本
- 发布程序（运维程序）

- 要求：
1. 不能影响用户体验
2. 系统不能停机
3. 不能导致系统故障或造成系统完全不可用

- 程序发布基于灰度模型
  - 1. 基于主机
  - 2. 基于用户

- 发布路径：
  - /webapp/tuangou(应用程序)
  - /webapp/tuangou-1.1(软链接)
  - /webapp/tuangou-1.2(软链接)

在调度器上下线一批主机（标记为维护模式）-> 关闭服务 -> 部署新版本 -> 启动服务 -> 在调度器上启用这一批主机

## 运维工具分类

- agent: **puppet, func**
  - 管理主机(认证证书，有agent程序) ------ 操作 --------> 被管理主机(管理员身份运行管控进程)
- agentless(ssh): **ansible, fabric**
  - 管理主机(普通用户) ------ 操作 --------> 被管理主机(sudo 普通用户)

## Ansible Introduction

> Configuration, Command and Control 功能的轻量级运维工具

- 2012年十佳 OSS
- 被RedHat收购（1亿美元）

## Ansible Features

- 模块化：调用特定的模块，完成特定任务
- 基于Python语言实现，由**Paramiko**，**PyYAML**和**JinJa2**三个关键模块
- 部署简单：**agentless**
- 支持自定义模块
- 支持**playbook**(剧本)
- 幂等性

## ansible的常用模块

- 获取支持模块列表 `# ansible-doc -l`
- command 模块：在远程主机运行命令
- shell模块：在远程主机在shell进程下的运行命令，支持shell特性，如管道等
- copy模块：Copies files to remote locations.
  - src= dest=
  - contnet= dest=
  - owner, group, mode

- cron 模块：Manage cron.d and crontab entries.
  - minute=
  - day=
  - month=
  - weedday=
  - hour=
  - job=
  - name= 必须要指明名称
  - state=present(创建) | absent(删除)

- fetch 模块：Fetches a file from remote nodes. 从远程主机拉取到本地
  - src 远程主机文件，不能是目录
  - dest 本地目录

- file 模块：Sets attributes of files
  - 创建链接文件：path= src= state=link
  - 修改属性：path= ownver= mode= group=
  - 创建目录：path=/tmp/tmpdir state=directory

- filesystem 模块：Makes file system on block device
- hostname 模块：管理主机名
  - name= # Name of the host
- pip 模块：管理 python 依赖库模块
- yum 模块：Manages packages with the 'yum' package manager
  - name= 程序包名称，可以带版本号(必填)
  - state= present或latest(最新版本) |  | absent(删除)
  - disablerepo=

- service 模块：管理服务
  - name= 指明管理服务名（必填）
  - state= started | stopped | restarted 服务状态
  - enabled=
  - runlevel=

- user 模块：管理用户和组账号
  - name= 用户账号(必填)
  - state= absent | present
  - system= 是否为系统账号
  - uid=
  - shell=
  - group= 基本组
  - groups 附加组
  - comment=
  - home=
  - move_home=
  - password=
  - remove=

``` sh
参数帮助
# ansible-doc -h
# ansible-doc -s ping
# ansible-doc -s yum
# man ansible

# ansible-doc -s command
  chdir 哪个目录下运行
  creates 先创建文件
  executable 指明shell程序
  removes 移除文件

使用命令模块执行shell程序
# ansible webservers -m command -a 'ls /var'

默认使用命令模块，所以可以省略
# ansible webservers -a 'ls /var'

添加用户和密码(不支持管道命令)
# ansible webservers -a 'useradd user1'
# ansible webservers -a 'echo password | passwd --stdin user1'

支持管道
# ansible-doc -s shell
# ansible webservers -m shell -a 'echo password | passwd --stdin user1'

本地文件或目录复制到远程主机的路径上
# ansible-doc -s copy
# ansible all -m copy s -a "src=/etc/fstab dest=/tmp/fstab"

直接生成内容复制到远程主机上
# ansible all -m copy s -a "content='hello there\n' mode=600 dest=/tmp/testfile"

目标文件已经存在则覆盖文件内容
# ansible all -m copy s -a "content='hello there\n override' mode=600 dest=/tmp/testfile"

# ansible-doc -s cron
  state 创建任务(present)还是删除任务(absent)
  job 任务
  name 指明名称(删除任务时使用名称)

创建每隔 5分钟执行时间同步
# ansible all -m cron -a "minute=*/5 job='/sbin/ntpdate 172.18.0.1 &> /dev/null' name=Synctime"

删除任务
# ansible all -m cron -a "state=absent name=Synctime"


从一个节点拉取文件
# ansible-doc -s fetch

修改文件属性
# ansible-doc -s file

创建链接文件（fstab.link -> /tmp/fstab）
# ansible all -m file -a "src=/tmp/fstab path=/tmp/fstab.link state=link"

创建目录
# ansible all -m file -a "path=/tmp/tmpdir state=directory"

yum包管理
# ansible-doc -s yum

安装 httpd 服务
# ansible all -m yum -a "name=httpd state=latest"

卸载 httpd 服务
# ansible all -m yum -a "name=httpd state=absent"

# ansible-doc -s service

启动服务
# ansible all -m shell -a "ss -tnl | grep :80"
# ansible all -m service -a "name=httpd state=started"
# ansible all -m shell -a "ss -tnl | grep :80"

管理用户账号
# ansible-doc -s user
# ansible all -m user -a "name=use2 system=yes state=present uid=306"


```

## YAML

> Yet Another Markup Language(仍是一种表一语言)

[YAML官网](http://www.yaml.org)

``` yaml
packages:
  - httpd
  - php
  - php-mysql
version: 0.1

```

有两个键值对儿组成的叫做字典

## playbook 的核心元素

- Tasks(任务)
- Variables(变量)
- Templates(模板)：包含了模板语法的文本文件
- Handlers(处理器)：由特定条件下的任务
- Roles(角色)

## 示例

- 管理端：CentOS 7(1个)
- 控制端：CentOS 7(2个), CentOS 6(1个), Ubuntu 14(1个)
- 命令（条件判断）

### 172.16.100.6(管理端)

- 安装epel, ansible

``` sh
# yum -y install ansible
# rpm -qi ansible
# rpm -ql ansible
```

- 配置文件：`/etc/ansible/ansible.cfg`
- 主机清单：`/etc/ansible/hosts`
- 角色：`/etc/ansible/roles`
- 主程序：
  - `/usr/bin/ansible`
  - `/usr/bin/ansible-playbook`
  - `/usr/bin/ansible-pull`
  - `/usr/bin/ansible-doc`

- ansible使用格式:

``` sh
# ansible HOST-PATTERN -m mod_name -A MOD_ARGS`
-m: 指明模块
```

``` sh
- 配置主机
# cd /etc/ansible
# cp hosts{,.bak}
# vim hosts
  :.,$d

  [webservers]
  172.18.100.10
  172.18.100.11

  [dbservers]
  172.18.100.11
  172.18.100.12

- 基于密钥认证
生成一对儿密钥
# ssh-keygen -t rsa -P ''

公钥文件复制到被控主机上
# ssh-copy-id -i .ssh/id_rsa.pub root@172.18.100.10
# ssh-copy-id -i .ssh/id_rsa.pub root@172.18.100.11
# ssh-copy-id -i .ssh/id_rsa.pub root@172.18.100.12

# ansible -h

测试与被控主机ping操作，-m 指明模块，成功返回"pint:pong"
# ansible all -m ping

```

### 172.18.100.10

### 172.18.100.11

### 172.18.100.12