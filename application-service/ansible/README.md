# 运维: Operations

## 运维自动化发展历程及技术应用

- On-Premises(本地部署)
  - 在家自己做
  - 自己：Application/Data/Runtime/OS/Virtualization/Servers/Storage/Networking
- IaaS(基础设施即服务)
  - 买成品回家做, 阿里云
  - 自己：Application/Data/Runtime/OS
  - 提供：Virtualization/Servers/Storage/Networking
- Pass(平台即服务)
  - 叫外卖
  - 自己：Application/Data/
  - 提供：Runtime/OS/Virtualization/Servers/Storage/Networking
- SaaS(软件即服务)
  - 去披萨店吃
  - 提供：Application/Data/Runtime/OS/Virtualization/Servers/Storage/Networking

## 运维工程师核心职能

- 平台架构组件
- 日常运营保障
- 性能、效率优化

![Linux运维工程师职能划分](./images/sre.png)

## 自动化运维应用场景

- 文件传输
- 命令执行
  - 应用部署
  - 配置管理
  - 任务流程编排

## 企业实际应用场景分析

- 1.Dev 开发环境
  - 使用者：程序员
  - 功能：程序员开发软件，测试BUG的环境
  - 管理者：程序员
- 2.测试环境
  - 使用者：QA 测试工程师
  - 功能：测试经过Dev环境测试通过的软件的功能
  - 管理者：运维
  - 说明：测试环境往往有多套，测试环境满足测试功能即可，不宜过多
    - 1.测试人员希望测试环境有多套，公司的产品多产品线并发，即多个版本，意味着多个版本同步测试
    - 2.通过测试环境有多少套和茶品线数量保持一样
- 3.发布环境：代码发布机，有些公司为堡垒机（安全屏障）
  - 使用者：运维
  - 功能：发布代码至生产环境
  - 管理者：运维（有经验）
  - 发布机：往往需要有2台（主备）
- 4.生产环境
  - 使用者：运维，少数情况开发权限给核心开发人员，极少数公司将权限完全开发给开发人员并且维护
  - 功能：对用户提供公司产品的服务
  - 生产环境服务器数量：一般比较多，且应用非常重要。往往需要自动工具协助部署配置应用。
- 5.灰度环境（生产环境的一部分）
  - 使用者：运维
  - 功能：在全量发布代码前将代码的功能面向少量精准用户发布的环境，可基于主机或用户执行灰度发布
  - 案例：共100台生产服务器，先发布其中的10台服务器，这10台服务器就是灰度服务器
  - 管理者：运维
  - 灰度环境：往往该版本功能变更较大，为保险起见特意先让一部分用户优化体验该功能，待这部分用户使用没有重大问题的时候，在全量发布至所有服务器

## 程序发布

- 预发布验证：
  - 新版本的代码先发布到服务器（跟线上环境配置完全相同，只是未接入到调度器）
- 程序发布：
  - 不能导致系统故障或造成系统完全不可用
  - 不能影响用户体验
- 灰度发布
- 发布路径
  - /webapp/tuangou-1.1 旧版本
  - /webapp/tuangou 软连接(用户访问目录)
  - /webapp/tuangou-1.2 新版本
- 发布过程：在调度器上下线一批主机（标记为maintanance状态）->关闭服务 -> 部署新版本的应用程序 -> 启动服务 -> 在调度器上启用这一批服务器
- 自动化灰度发布：脚本、发布平台

## 自动化运维工具

- Ansible: Python, Agentless(无代理), 中小型应用环境
- Saltstack: Python, 一般需要部署 agent, 执行效率更高
- Puppet: Ruby, 功能强大，配置复杂，重型，适合大型环境(Google)
- Fabric: Python, agentless
- Chef: Ruby, 国内应用少
- Cfengine
- func

## 1. 操作系统安装

- 运维工具：pxe, cobbler
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
  - 1.基于主机
  - 2.基于用户

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
- 被 RedHat 收购（1亿美元）

## Ansible Features

- 模块化：调用特定的模块，完成特定任务
- 基于Python语言实现，由**Paramiko**，**PyYAML**和**JinJa2**三个关键模块
- 部署简单：**agentless**
- 支持自定义模块
- 支持**playbook**(剧本)
- 幂等性

## ansible的常用模块

- command,shell,cron,copy,file,ping,yum,service,user,setup,hostname,group,script

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

- setup 模块

- group 模块: 添加和删除组
  - name
  - state
  - system
  - gid

- script 模块：执行本地路径上的脚本复制远程主机上脚本
  - -a "/PATH/TO/SCRIPT_FILE"

- template 模块：给予模板方式生成一个文件复制到远程主机
  - *src=
  - *dest=
  - owner=
  - group=
  - mode=

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

管理组
# ansible-doc -s group

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

- Hosts
- Tasks(任务)
- Variables(变量)
- Templates(模板)：包含了模板语法的文本文件
- Handlers(处理器)：由特定条件下的任务
- Roles(角色)

### playbook 基础组建

- Hosts: 运行指定任务的目标主机
- remote_user: 在远程主机上执行任务的用户
- sudo_user
- tasks: 任务列表
  - 模块，模块参数
  - 格式：
    - action: module arguments (最新版本)
    - module: arguments (通用版本)

    - 注意：shell 和 command 模块后面直接跟命令，而非key=value类的参数列表
  - 1.某任务的状态在运行后为 changed 时，可通过"notify"通知给相应的handlers
  - 2.任务可以通过“tags”打标签，而后可在ansible-playbook 命令上使用-t指定进行调用；多个标签可以使用都好分割

### 运行playbook 的方式

1. 测试

- 运行测试(只检测可能会发生的改变，但不真正执行操作): `# ansilbe-playbook --check first.yaml`

- 列出运行在任务的主机:`# ansilbe-playbook --list-hosts  first.yaml`

2. 运行

- 运行任务:`# ansilbe-playbook first.yaml`

``` sh
# cd ~
# vim first.yaml
- hosts: all
  remote_user: root
  tasks:
  - name: create a user user3
    uer: name=user3 system=true uid=307
  - name: create a user user4
    uer: name=user4 system=true uid=308

# man ansible-playbook

运行测试
# ansilbe-playbook --check first.yaml

运行在哪个主机上
# ansilbe-playbook --list-hosts first.yaml

查看各个主机的FACTS变量（报告主机状态信息）
# ansible-doc -s setup
# ansible 172.18.100.69 -m setup

# ansible-playbook first.yaml

启动服务剧本
# mkdir working
# cd working
# mkdir files
# rpm -q httpd
# cp /etc/httpd/conf/httpd.conf files/
# vim files/http.conf
  Listen 8080
# vim web.yaml
- hosts: webservers
  remote_user: root
  tasks:
  - name: install httpd package
    yum: name=httpd state=present
  - name: install configure file
    copy: src=files/httpd.conf dest=/etc/httpd/conf/
  - name: start httpd service
    service: name=httpd state=started
  - name: execute ss command
    shell: ss -tnl | grep :80
# ansible-playbook --check web.yaml

 关闭 httpd 服务
# ansible all -m yum -a "name=httpd state=absent"
# ansible-playbook --check web.yaml
# ansible-playbook web.yaml
# ansible webservers -m shell -a "ss -tnl | grep :80"


# vim web.yaml
# vim file/httpd.conf
  Listen 80
# ansible-playbook --check web.yaml
# ansible-playbook web.yaml
# ansible webservers -m shell -a "ss -tnl | grep :80"
```

### handlers

- 任务，在特定条件下触发
- 接收到其他任务的通知时被处罚
  - 例如：监控的资源被change的时候，触发handlers

``` sh
配置文件修改是触发handler => 重启服务
# cp web.yaml web-2.yaml
# vim web-2.yaml
- hosts: webservers
  remote_user: root
  tasks:
  - name: install httpd package
    yum: name=httpd state=present
  - name: install configure file
    copy: src=files/httpd.conf dest=/etc/httpd/conf/
    notify: restart httpd
  - name: start httpd service
    service: name=httpd state=started
  - name: execute ss command
    shell: ss -tnl | grep :80
  handlers:
  - name: restart httpd  与notify 后面的名字保持一致
    service: name=httpd state=restarted
# ansible-playbook --check web-2.yaml
# ansible-playbook web-2.yaml
```

``` sh
# cp web-2.yaml web-3.yaml
# vim web-3.yaml
- hosts: webservers
  remote_user: root
  tasks:
  - name: install httpd package
    yum: name=httpd state=present
  - name: install configure file
    copy: src=files/httpd.conf dest=/etc/httpd/conf/
    tags: instconf
    notify: restart httpd
  - name: start httpd service
    service: name=httpd state=started
  handlers:
  - name: restart httpd  与notify 后面的名字保持一致
    service: name=httpd state=restarted
# ansible-playbook --check web-3.yaml

# vim files/httpd.conf
  改变一下端口

# ansible-playbook --check -t instconf web-3.yaml
  仅显示配置文件修改
# ansible-playbook web-3.yaml

# vim web-3.yaml
- hosts: webservers
  remote_user: root
  tasks:
  - name: install httpd package
    yum: name=httpd state=present
    tags: insthttpd
  - name: install configure file
    copy: src=files/httpd.conf dest=/etc/httpd/conf/
    tags: insthttpd
    notify: restart httpd
  - name: start httpd service
    service: name=httpd state=started
    tags: starthttpd
  handlers:
  - name: restart httpd  与notify 后面的名字保持一致
    service: name=httpd state=restarted
# ansible-playbook --check -t insthttpd web-3.yaml
  安装包和配置文件标签

运行配置文件标签任务
# ansible-playbook -t instconf web-3.yaml
```

### variable

1. facts: 可直接调用
2. ansible-playbook 命令的命令行中自定义变量; `-e VARS, --extra-vars=VARS`
3. 通过 role 传递变量
4. Host Inventory;

- 向不同的主机传递不同的变量; IP/HOSTNAME var1=value var2=value
- 向组中的主机传递相同的变量
  - [groupname:vars]
  - variable=value
- invertory 参数;
  - 用于定义ansible 远程主机目标主机时使用的参数，而非传递给playbook 的变量；
    - ansible_ssh_host
    - ansible_ssh_port
    - ansible_ssh_user
    - ansible_ssh-pass
    - ansible_sudo_pass
    - `172.18.100.12 ansible_ssh_user=root ansible_ssh_pass=pass`

``` sh
# man ansible-playbook
# vim forth.yaml
- hosts: dbservers
  remot_usrs: root
  tasks:
  - name: install {{ pkname }}
    yum: name={{ pkname }} state=present
# ansible-playbook -e pkname=emecached -- check forth.yaml

节点上测试是否安装memecached
# rpm -q memecached

主机变量
# vim /etc/ansible/hosts
  [webservers]
  172.18.100.10  hname=www1 http_port=808
  172.18.100.11  hname=www2 http_port=8080

  组变量
  [webserers:vars]
  mysql_port=3306

  [dbservers]
  172.18.100.11
  172.18.100.12 ansible_ssh_user=root ansible_ssh_pass=pass

# ansible-dc -s hostname
# vim hostname.aml
- hosts: webservers
  remote_user: root
  tasks:
  - name: set hostname
    hostname: name={{ hname }}
# ansible-playbook --check hostname.yaml
# ansible-playbook hostname.yaml

节点主机上检测 hostname
# hostname

```

### template 模板

> 文本文件，嵌套有脚本（使用模板编程语言编写）

### Jinja2：模板编程语言

- 字面量：
  - 字符串：使用单引号或双引号；
  - 数字：整数，浮点数
  - 列表：[item1, item2, ...]
  - 元祖：(item1, item2, ...)
  - 字典：{k1: v2, k2: v3, ...}
  - 布尔：true | false
- 算数运算：
  - +, -, *, /, //, %, **
- 比较操作：
  - ==, !=, <, >=, <, <=
- 逻辑运算符：
  - and, or, not

```sh
检查各个节点CPU核心数量
# ansible all -m setup | grep ansible_processor_vcpus
主机1：4个
主机2：2个

每台主机上部署 Nginx
# cd working
# vim files/epel.repo
[epel]
name=Fedora EPEL
baseurl=http://172.18.0.1/fedora-epel/$releasever/$basearch
enabled=1
gpgcheck=0

复制文件
# ansible all -m copy -a "src=files/epel.repo dest=/etc/yum.repos.d"

安装 nginx
# ansible all-m yum -a "name=nginx state=present"

本地安装 nginx
# yum -y install nginx
# cp /etc/nginx/nginx.conf fiels/
# mv files/nginx.conf files/nginx.conf.j2

模板配置文件
# vim files/nginx.conf.j2
  worker_processes {{ ansible_processor_vcpus }};
  listen {{ http_port }};

# ansible webservers -m template -a "src=files/nginx.conf.j2 dest=/etc/nginx/nginx.conf"
错误提示

# vim nginx.yaml
- hosts: webserers
  remote_user: root
  tasks:
  - name: install nginx
    yum: name=nginx state=present
  - name: install conf file
    template: src=files/nginx.conf.j2 dest=/etc/nginx/nginx.conf
    notify: restart nginx
    tags: instconf
  - name: start nginx service
    service: name=nginx state=started
  handlers:
  - name: restart nginx
    service: name=nginx state=restarted

# ansible-playbook --check nginx.yaml
# ansible-playbook nginx.yaml

验证各个节点主机
# ps aux


# vim /etc/ansible/hosts

[webservers]
172.18.100.67 http_port=80
172.18.100.68 http_port=8080


# ansible-playbook --check nginx.yaml
# ansible-playbook nginx.yaml

验证主机上的端口
# ss -tnl

-----------------------

算数运算：CPU 核心数减掉1
# vim files/nginx.conf.j2
  worker_processes {{ ansible_processor_vcpus }};

# ansible-playbook --check nginx.yaml
# ansible-playbook nginx.yaml

验证各个节点主机
# ps aux

```

### 条件测试

- when 语句：在task 中使用, jinja2 的语法格式
  


- CentOS: httpd 报名
- Ubuntu: Apache2 包名
- CentOS 7 vs CentOS 6

``` sh
# ansible all -m setup
# ansible all -m setup | grep ansible_distribution

tasks:
- name: intall conf file to centos7
  template: src=files/nginx.conf.c7.j2
  when: ansible_distribution_major_version == "7"
- name: install conf file to cento6
  template: src=files/nginx.conf.c6.j2
  when: ansible_distribution_major_version == "6"



# scp root@172.18.100.69:/etc/nginx/nginx.conf files/nginx.conf.c6.j2
# vim files/nginx.conf.c6.j2
  worker_processes {{ ansible_processor_vcpus }};
# vim nginx.yaml
- hosts: all
  remote_user: root
  tasks:
  - name: install nginx
    yum: name=nginx state=present
  - name: install conf file to centos7
    template: src=files/nginx.conf.c7.j2 dest=/etc/nginx/nginx.conf
    when: ansible_distribution_major_version == "7"
    notify: restart nginx
    tags: instconf
  - name: install conf file to centos6
    template: src=files/nginx.conf.c6.j2 dest=/etc/nginx/nginx.conf
    when: ansible_distribution_major_version == "6"
    notify: restart nginx
    tags: instconf
  - name: start nginx service
    service: name=nginx state=started
  handlers:
  - name: restart nginx
    service: name=nginx state=restarted

# ansible-playbook --check nginx.yaml
# ansible-playbook nginx.yaml
```

### 循环：迭代，需要重复执行的任务

> 对迭代项的引用，固定变量名位"item"；而后，要在task 中使用 with_items 给定迭代的元素列表

- 列表方法
  - 字符串
  - 字典 

``` sh
- name: install some packeges
  yum: name={{ item }} state=present
  with_items:
  - nginx
  - memcached
  - php-fpm
```

``` sh
# cd working
# vim iter.yaml
- hosts: webservers
  remote_user: root
  tasks:
  - name: install some packages
    yum: name={{ item }} state=present
    with_items:
    - nginx
    - memcached
    - php-fpm
# ansible-playbook --check item.yaml
# ansible-playbook  item.yaml
```

``` sh
不同组的不用用户

# vim user.yaml
- hosts: all
  remote_user: root
  tasks:
  - name: add some groups
    group: name={{ item }} state=present
    - group11
    - group12
    - group13
  - name: add some users
    user: name={{ item.name }} group={{ item.group }} state=present
    with_items:
    - { name: 'user11', group: 'group11'}
    - { name: 'user12', group: 'group12'}
    - { name: 'user13', group: 'group13'}

# ansible-playbook --check item.yaml
# ansible-playbook  item.yaml

检查各个节点用户
# tail /etc/passwd
# tail /etc/group
```

## 角色(roles)

- 角色集合：每一个角色都是一个目录
  - /etc/ansible/roles/
    - mysql/
    - httpd/
    - nginx/
    - memcached/

- 每个角色，以特定的层级目录结构进行组织
  - mysql/
    - files/: 存放由 copy 或 script 模块等调用的文件
    - templates/: template模块查找所需要模板文件的目录
    - tasks/: 至少应该包含一个名为main.yaml文件；其他的文件需要在此文件中通过 include 进行包含
    - handlers/:至少应该包含一个名为 main.yaml 文件；其他的文件需要在此文件中通过 include 进行包含
    - vars/:至少应该包含一个名为 main.yaml 文件；其他的文件需要在此文件中通过 include 进行包含
    - meta/:至少应该包含一个名为 main.yaml 文件,定义当前角色的特殊设定及其依赖关系；其他的文件需要在此文件中通过 include 进行包含
    - default/: 设定默认变量时使用此目录中的main.yaml 文件

``` yaml
在playbook调用角色
- hosts: webservers
  remote_user:root
  roles:
  - mysql
  - memcached
  - nginx
```

### 创建角色

``` sh
# mkdir /etcansible/roles/nginx/{files,tasks,templates, handlers, vars, meta, default}
# tree /ec/ansible/roles/nginx
17:48
```

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