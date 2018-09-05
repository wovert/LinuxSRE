# Systemd

## init(启动程序)

- CentOS 5: SysV init(Unix System V)
- CentOS 6: `Upstart`(Ubuntu)
- CentOS 7: `Systemd`(System daemon，参考 Mac OSX)

## Systemd features

- 系统引导时实现服务并行启动（服务与服务没有依赖时）
- 按需激活进程（访问时激活服务，启动进程）
- 系统状态快照
- 基于依赖关系定义服务控制逻辑

## 核心概念：unit

> unit 由其相关配置文件进行标识、识别和配置；文件中主要包含了系统服务，监听的socket、保存的快照以及其它与init相关的信息；

## unit 配置文件主要保存在

- `/usr/lib/systemd/system`
- `/run/systemd/system`
- `/etc/systemd/system`

## unit 的常见类型

- service unit：用于定义**系统服务**
- target unit：用于模拟实现**运行级别**
- device unit：用于定义**内核识别的设备**
- mount unit：定义**文件系统挂载点**
- socket unit：用于标识进程间通信用到的 socket 文件
- snapshot unit：管理**系统快照**
- swap unit：用于标识**swap设备**
- automount unit：文件系统**自动点设备**
- path unit：用户定义**系统中的文件或目录**

## 关键特性

- 基于 socket 的激活机制：socket 与程序分离
- 基于 bus 的激活机制
- 基于 device 的激活机制
- 基于 path 的激活机制
- 系统快照：保存各 unit 的当前状态信息于持久存储设备中
- 向后兼容 sysv init 脚本 `/etc/init.d/`

## 不兼容

- systemctl 的命令是固定不变的
- 非由 systemd 启动的服务，systemctl 无法与之通信

## 管理系统服务

- CentOS 7: service类型的unit文件
  - systemctl命令：Control the systemd system and service manager
  - systemctl [options...] COMMAND [NAME...]

- 启动：`service NAME start = systemctl start NAME.service`
- 停止：`service NAME stop = systemctl stop NAME.service`
- 重启：`service NAME restart = systemctl restart NAME.service`
- 状态：`service NAME status = systemctl status NAME.service`
- 条件式重启：`service NAME condrestart = systemctl try-restart NAME.service`
- 重载或重启服务：`systemctl reload-or-restart NAME.service`
- 重载或条件式重启：`system reload-or-try-restart NAME.service`

- 查看某服务当前激活与否状态:`systemctl is-active httpd.service`
- 查看所有已激活的服务：`systemctl list-units --type service`
- 查看所有服务（已激活及未激活）: `chkconfig --list`, `systemctl list-units -t service {-a | --all}`

- 设置服务开机自启：`chkconfig NAME on = systemctl enable NAME.service`
- 禁止服务开机自启：`chkconfig NAME off = systemctl disable NAME.service`
- 查看某服务是否能开机自启：`chkconfig --list NAME`, `systemctl is-enabled NAME.service`

- 禁止某服务设定为开机自启：`systemctl mask NAME.service`
- 取消此禁止：`systemtl umask NAME.service`
- 查看服务的依赖关系：`systemctl list-dependencies NAME.service`

## 管理 target units

- 运行级别：
  - `0 => runlevel0.target, poweroff.target`
  - `1 => runlevel1.target, rescue.target`
  - `2 => runlevel2.target, multi-user.target`
  - `3 => runlevel3.target, multi-user.target`
  - `4 => runlevel4.target, multi-user.target`
  - `5 => runlevel5.target, graphical.target`
  - `6 => runlevel6.target, reboot.target`

- 级别切换：`init N => systemctl isolate NAME.target`
- 查看级别：`runlevel => systemctl list-units {-t | --type} target`
- 查看所有级别：`runlevel => systemctl list-units -t target -a`
- 获取默认运行级别：`systemctl get-default`
- 修改默认运行级别：`systemctl set-default NAME.target`
- 切换至紧急救援模式(init 1,加载驱动)：`sytemctl rescue`
- 切换至emergency模式(init 1,不加载驱动)：`systemctl emergency`

- 关机：`systemctl halt, systemctl poweroff`
- 重启：`systemctl reboot, systemctl`
- 挂起：`systemctl suspend`
- 快照：`systemctl hibernate`
- 快照并挂起：`systemctl hybrid-sleep`

## service unit file

- 文件通常由三部分组成：
  - [Unit]：定义与**Unit类型无关的通用选项**;用于提供unit的描述信息、unit行为依赖关系
  - [Service]：与**特定类型相关的专用选项**；此处为Service类型；
  - [Install]：定义由**systemctl enable以及systemctl disable命令实现服务启用或禁用**时用到的一些选项

### Unit 段的常用选项

- Description: 描述信息；意义性描述；
- After：定义unit的启动次序；表示当前unit应该晚于哪些unit启动；其功能与Before相反；
- Request：依赖到的其它units；强依赖，被依赖的units无法激活时，当前unit即无法激活
- Wants：依赖到的其它units；弱依赖
- Conflicts：定义units之间的冲突关系

### Service 段的常用选项

- Type：用于定义影响ExecStart及相关参数功能的unit进程启动类型
  - 类型：
    - simple:
    - forking:
    - oneshot:
    - dbus:
    - notify: 类似于simple
    - idle:
- ExecStart：指明启动unit的要运行的命令或脚本；ExecStartPre, ExecStartPost
- ExecStop：指明停止unit要运行的命令或脚本
- EnviromentFile：环境配置文件
- Restart：

### Install 段的常用选项

- Alias：
- RequiredBy：被哪些units所依赖
- WantedBy：被哪些units所依赖

注意：对于新创建的unit文件或修改了的unit文件,要通知systemd重载此配置文件 `# systemctl daemon-reload`

练习：为当前系统的httpd服务提供一个unit文件

``` shell

```