# nsswitch

> Name Service Switch

名称解析：用户名、组名、主机名、服务名

## 解析：根据已知的信息（key）查找某存储库，获取其他信息的过程

### 存储：文件、SQL、NoSQL、LDAP、DNS

- 文件系统接口：系统调用
- SQL：SQL接口

- 名称解析剥离出来的解析框架，是一个通用层，支持很多成协议

- 通用框架，承上启下
- 启下：用于与各种存储进行交互
- 承上：提供统一的配置和调用接口

## 实现：库

``` shell
# ls -l /usr/lib64/libnss*
# ls -l /lib64/libnss*
```

- 框架：libnss3.so 通用层
- 驱动：libnss_files, libnss_db, libnss_dns

## 为每种用到解析库应用程序通过一个配置文件定义其配置：

`# vim /etc/nsswitch.conf`

文件格式

``` shell
db: store1 store2 ... 在store1查找，找到不在继续store2中查找
passwd: files sss
shadow: files sss
group: files sss
hosts: files dns

库名：files
[NOTFOUND=RETURN] 解析后的动作
```

- 每种存储中的根据查找键进行查找的**结果状态**
  - STATUS => success | notfound | unavail | tryagain
    - success: 成功找到 return
    - notfound：未发现服务 continue
    - unavail: 找到解析库了，但服务不可用 continue
    - tryagain: 重试 continue

- 对应于每种**状态结果**的行为(action)
  - return 返回 | continue 继续
  - 一般success返回return，其他都是continue

- 例：hosts在files查找，找到sucess, 没有找到继续在nis中查找，找到return，没有找到也reutrn。因为设置了[NOTFOUND=return]。因为nis挂了不用再dns在查找。但有些场景会continue, nis不可用时。nis不给我们响应，继续查找下一个 dns

`hosts: files nis [NOTFOUND=return] dns`

## getent命令

``` shell
# man getent
# getent database [key ...]
```

``` shell
passwd解析库查找root
# getent passwd root

# getent passwd fedora

# getent hosts 192.168.1.71

# getent hosts web.lingyima.com

hosts: files [SUCCESS=continue] dns
# getent hosts web.lingyima.com

hosts: files [NOTFOUND=return] dns 没有hosts直接返回，永远找不到
# getent hosts web.lingyima.com
```

### 去掉本机 DNS 解析

``` shell
# vim /etc/nsswitch.conf
  hosts: files dns 改成 hosts: dns
# gentent hosts lingyima.com

# vim /etc/nsswitch.conf
  hosts: files [SUCCESS=continue]  dns
# gentent hosts lingyima.com

# vim /etc/nsswitch.conf
  files没有找到 直接返回不在继续dns服务查找
  hosts: files [NOTFOUND=return]  dns
# gentent hosts lingyima.com
```

## pam

> pluggable authentication modules，插入式认证模块

认证功能的通用框架

### 实现

> 提供与各种类型的存储进行交互的通用实现，以及多种辅助类的功能模块(比如：密码弱口令提示语)
`/lib64/security/*`

配置文件：每个基于pam做认证的应用程序都需要有其专用的配置

提供方式

1. 使用单个文件为多种应用提供配置：`/etc/pam.conf`
2. 为每种应用提供一个专用配置文件：`/etc/pam.d/APP_NAME`

配置文件语法格式

``` shell
# vim /etc/pam.conf
  application type control module-path module-arguments
```

``` shell
# vim /etc/pam.d/APP_NAME
  type control module-path module-arguments
```

- type
  - auth：账号的认证和授权
  - account：与账号管理相关的非认证类的功能（审计生效，认证成功，未必能使用，账号过期）
  - password：用户修改密码时密码复杂度检查机制等功能
  - session：用户获取到服务之前或使用服务完成之后需要进行一些附加的操作

- control：同一种type的多个检查之间如何进行组合
  - 有两种实现方式：
    - 简单实现：使用一个关键词来定义
    - 详细实现：使用一个或多个"status=action"进行组合定义

  - 简单实现关键词
    - required：必须成功通过，否则即为失败；无论成功还是失败，都需要参考同种type下的其他定义；本检查**不成功一定不能过**

    - requisite：**必须成功通过，否则立即返回失败（1票否决）**；成功时，还需要参考同种type下的其他定义；失败时，不参考同种type的定义

    - sufficient：（一票成功）成功立即返回成功，失败是有同种type下其他模块确定
    - optional：可选的；与追踪结果无关
    - include：调用其他配置文件中同种type的相关定义；

``` shell
# vim /etc/pam.d/password-auth
```

### 详细实现

`[status1=action, status2=action, ...]`

- status：检查结果的返回状态；
- action：采取的行为，比如ok,done,die,bad,igonre,...
- ok:通过
- done：一票通过
- die：一票否决，挂掉
- bad: 挂掉
- ignore: 忽略

- module-path：模块文件路径
  - 相对路径：相对于`/lib64/security/`目录
  - 绝对路径：

- module-arguments：模块的专用的参数

### pam_shells.so

> 检查用户的shell程序

``` shell
# vim /etc/pam.d/sshd
  # 在auth栈的第一行添加
  auth required pam_shells.so
```

没有 csh 测试是否能登录

``` shell
# useradd -s /bin/csh docker
# echo docker | passwd --stdin "docker" docker
# vim /etc/shells
  删除/bin/csh
```

登陆测试：`# vim /etc/shells`文件中的shell是安全shell，如果没有csh文件不能登录

### pam_limits：系统资源分配及控制的模块

> 在用户级别实现对其可使用的资源的限制，例如可**打开的最大文件数**，可**同时运行的最大进程数**等等

定义或修改资源限制

1. ulimit命令
2. 配置文件

``` shell
# vim /etc/security/limits.conf
# vim /etc/security/limits.d/*
```

#### 配置文件格式

``` shell
# vim /etc/security/limits.conf

<domain> <type> <item> <value>
  <domain>：应用于哪些对象
    username：单个用户
    @group：组内的所有用户
    *：通配符，设定默认值；所有用户

  <type>：限制的类型
    soft：可超过的限制（大家尽量不要迟到）
    hard：不超过限制（大家一定不要迟到）
    -：即是soft亦是hard

  <item>：限制的资源
    nofile：max number of open file descriptors
    nproc：max number of processes

  fedora hard nofile 2

# su - fedora
# lsof
```

### ulimit命令：用于临时调整软硬限制或查看，仅root用户能执行

``` shell
ulimit [options] [限制]

查看
# ulimit -a
  open files 1024

修改
# ulimit -n 2048

OPITONS:
  -S soft资源限制
  -H hard资源限制
  -a 所有当前限制都被报告
  -v 虚拟内存尺寸
  -x 最大的锁数量
  -u 最大用户进程数
  -t 最大的CPU时间，以秒为单位
  -s 最大栈尺寸
  -r 实时调度的最大优先级
  -n 最多的打开的文件描述符个数
  -i 最多的可以挂起的信号数
```

## 自学模块

- pam_listfile，要求实现仅允许sshusers组中的用户能通过sshd服务登录系统；
- pam_time模块