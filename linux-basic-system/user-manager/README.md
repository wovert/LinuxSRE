# 用户、组和权限管理

- Multi-tasks
- Multi-Users

- 用户：资源获取标识符，资源分配，安全权限模型的核心要素之一
- 密码：来实现用户认证的
- 名称解析：User IDentifier UID
- 容器：能够容纳很多用户的容器，可以分配权限 组（group），角色（role）
- 组名：Group IDentifier GID
- 解析：在数据库中按搜索码查找到对应的条目，并找到与之对应额外其他数据的过程

## 每个使用者

### 用户标识、密码：3A

- 认证：Authentication, 通过密码认证用户标识
- 授权：Authorization，资源使用权
- 审计：Audition，监督权限（日志）

### 组（角色）：用户组，用户容器

## 用户类别

- 管理员
- 普通用户
  - 系统用户
  - 登录用户

- 用户标识：UserID => UID (16bits二进制数字：0-65535)
  - 管理员：UID为0
  - 普通用户：UID范围是1-65535
  - 系统用户：
    - 1-499（CentOS 6）
    - 1-999（CentOS 7）
  - 登录用户：
    - 500-60000(CentOS 6)
    - 1000-60000(CentOS 7)

  - 名称解析：名称转换
    - Username（字符串） <--> UID（数字）
    - 原因：计算机只知道01代码
    - 根据名称解析库运行：/etc/passwd

## 用户组

- 组类别1：组的分类角度
  - 管理员组
  - 普通用户组
    - 系统组
    - 登录组

- 组类别2：用户的角度
  - 用户的基本组
  - 用户附加组

- 组类别3：组的角度
  - 私有组：组名同用户名且只包含一个用户
  - 公共组：组内包含了多个用户；

## 组标识：GroupID => GID

- 管理员组：0
- 普通用户组：1-65535
  - 系统用户组：
    - 1-499(CentOS 6)
    - 1-999(CentOS 7)
  - 登录用户组：
    - 500-6000(CentOS 6)
    - 1000-60000(CentOS 7)

## 名称解析：groupname <--> GID

- 解析库：/etc/group

## 认证信息

- 通过比对事先存储的，与登录时提供的信息是否一致
- password：
  - `/etc/shadow`
  - `/etc/gshadow`

## 密码的使用策略

1. 使用随机密码
2. 最短长度不要低于 8 位
3. 应该使用大写字母、小写字母、数字和标点符号四类字符中至少三类
4. 定期更换

## 加密算法

### 对称加密

> 加密和解密使用同一个密码

`Plain text<--->cipher text`

### 非对称加密

> 加密和解密使用的一对儿密钥(比对称加密的机密时间慢3个数量等级)

- 密钥对儿：
  - 公钥：public key
  - 私钥：privae key

### 单向加密

> 只能加密，不能解密；提取数据特征码

- 特点
  - 定长输出
  - 雪崩效应
- 例子：`~]# echo "hello world" | md5sum`或`sha512sum`
- 算法：
  - 1：md5sum: message digest version5(信息摘要)
    - 16bytes=128bits
  - 2：sha1sum: secure hash algorithm（安全哈希算法）
    - 20bytes=160bits
  - 3：sha224sum
  - 4：sha256sum, 256bits=4
  - 5：sha384sum, 384bits=48byes
  - 6：sha512sum, 512bits=64bytes

- 在计算时加 `salt`，添加的随机数；
  - `lingyima$12345678`: 加密子串
  - 输入密码+提取`12345678` === 加密密码

## /etc/passwd：用户的信息库

`name:password:UID:GID:GECOS:directory:shell`

- name：用户名
- Password：可以是加密的密码，也可是占位符x
- UID：用户ID
- GID：用户所属的基本组的ID号
- GECOS：用户的注释信息
- directory：用户的家目录
- shell：用户的默认SHELL，登陆时默认SHELL程序
  - /bin/bash
  - /sbin/nologin
  - /bin/csh
  - /bin/tcsh
  - /bin/ksh
  - /bin/sh

## /etc/shadow：用户密码库

- Login name：登录名
- Encrypted password: 加密的密码
  - $1$：md5算法
  - $6$: sha512算法
  - 8个字符：salt
  - 最前面加上两个叹号(!!)表示此账户没有密码
- date of last password change:最后一次更改密码的日期
  - 表示从1970年1月1日开始的天数
  - 0表示下次登录时更改密码
  - 空字段表示密码年龄功能被禁用
- minimum password age：最短使用期限
  - 更改密码之后，要等多长时间再次被允许更改密码
- maximum password age：最长使用期限
  - 更改密码之后，经过n天后，用户必须更改密码
  - n 天之后，密码仍然可用，用户将会在下次登陆的时候被要求更改密码。
  - 如果最大密码年龄小于最小密码年龄，用户将会不能更改密码
  - 修改密码期限：最长-最短
- password warning period：警告期限，登录时提示修改密码
  - 最长使用期限之前，警告期限天数
  - 登录提示修改密码，但不需要修改，也可以登录
- password inactivity period：非活动期限，不修改密码不能登录
  - 最长使用期限之后，延长时间天数
  - 登录提示修改密码，不改密码不能登录
- account expiration date：过期期限
  - 禁用账号天数
- reserved field：保留字段

- 用户名：加密的密码：最近一次修改密码时间（天数）：最短使用期限：最长使用期限：警告期限：延长期限：账户过期期限：保留字段
- 最近一次修改密码时间：从1970天数，0:下次登陆时更改密码，空：禁用

## /etc/group：用户组的信息库

- group_name:password:GID:user_list
- user_list:改组的用户成员；以此组为附加组的用户的用户列表

### 安装上下文：

- 进程以其发起者的身份运行；
  - 进程对文件的访问权限，取决于发起此进程的用户的权限；
- 系统用户：为了能够让那后台进程或服务类进程以非管理员的身份运行，通常需要为此创建多个普通用户；这类用户从不用登录系统；

### groupadd命令 添加组

``` shell
# groupadd [option] group_name
  -r: 创建系统组
-g GID：默认是上一个组的GID+1
```

### groupmod命令：修改组属性

- `groupmod [option] GROUP`
  - `-g GID`：修改GID
  - `-n new_name`：修改组名

### groupdel命令 删除组

`groupdel group_name`

### userdel命令：删除用户

`-r`：删除用户时一并删除其家目录

### useradd命令：创建普通用户或更新新用户信息

- `useradd [options] LOGIN`
- `useradd -D`
- `useradd -D [options]`
  - `-p`：设置明文密码
  - `-u, --uid UID`：指定UID
  - `-g, --gid GROUP`：指定基本组ID，此组得事先存在
  - `-G, --groups GROUP1[,GROUP2,...[,GROUPN]]]`：指明用户所属的附加组，多个组之间用逗号分隔；
  - `-c, --comment COMMENT`：指明注释信息；
  - `-d, --home HOME_DIR`：以指定的路径为用户的家目录；通过复制/etc/skel此目录并重命名实现；指定的家目录路径如果事先存在，则不会为用户复制环境配置文件；即没有任何文件；
  - `-s, --shell SHELL`：指定用户的默认shell，可用的所有shell列表存储在/etc/shells文件中；
  - `-r, --system`：创建系统用户
  - `-f, --inactive`：非活动期限天数，账户被彻底禁用之前的天数
    - 0：立即禁用
    - 1：禁用这个功能
  - `-M`：不创建用户主目录，即使系统在/etc/login.defs中设置CREATE_HOME为yes
  - `-m, --create-home`：如果不存在，则创建用户主目录。骨架目录中的文件和目录(-k选项指定)将会复制到主目录如果没有指定此选项并且CREATE_HOME没有启用，不会创建主目录

  - 注意：创建用户时的诸多默认设定配置文件为 `/etc/login.defs`		

  - `/etc/login.defs` 文件
    - MAIL_DIR /var/spool/mail
    - PASS_MAX_DAYS
    - PASS_MIN_DAYS
    - PASS_MIN_LEN
    - PASS_WARN_AGE
    - UID_MIN
    - UID_MAX
    - SYS_UID_MIN
    - SYS_UID_MAX
    - GID_MIN
    - GID_MAX
    - SYS_GID_MIN
    - SYS_GID_MAX
    - CREATE_HOME
    - UMASK 077
    - USERGROUP_ENAB YES 时候删除基本组（不包含其他组的用户）
    - ENCRYPT_METHOD SHA512(CentOS 7) 或MD5(CentOS 5)

- `useradd -D`：显示创建用户的默认配置
  - `GROUP=100`
  - `HOME=/home` # 家目录启始位置
  - `INACTIVE=-1`
  - `EXPIRE=` # 永不过期
  - `SHELL=/bin/bash`
  - `SKEL=/etc/skel`
  - `CREATE_MAIL_SPOOL=yes` # 邮件缓冲队列，邮筒=> /var/spool/mail/USERNAME

- `useradd -D` 选项：修改默认选项的值
  - `-D OPTIONS`: 修改默认选项的值
  - `-c, --comment COMMENT`
  - `-d, --home HOME_DIR`
  - `-f, --inactive`
  - `-e,--expiredate`
  - `-g, --gid GROUP`
  - `-G, --group GOUPRS[,GROUP2,...[,GROUPN]]`
  - `-s, --shell SHELL`
  - `-u, --uid UID`

- 修改的结果保存于/etc/default/useradd文件中 `# useradd -D -s /bin/csh`

### usermod命令：修改用户属性

- `-u, --uid UID`：修改用户的ID为此处指定的新UID；
- `-g, --gid GROUP`：修改用户所属的基本组；

- `-G, --groups GROUP1[,GROUP2,...[,GROUPN]]]`：修改用户所属的附加组；原来的附加组会被覆盖；
- `-a, --append`：与-G一同使用，用于为用户追加新的附加组；

- `-d, --home HOME_DIR`：修改用户的家目录；用户原有的文件不会被转移至新位置；
- `-m, --move-home`：只能与`-d`选项一同使用，用于将原来的家目录移动为新的家目录；

- `-c, --comment COMMENT`：修改注释信息；
- `-s, --shell SHELL`：修改用户的默认shell；

- `-l, --login NEW_LOGIN`：修改用户名；
- `-L, --lock`：锁定用户密码；即在用户原来的密码字符串之前添加一个"!"；
- `-U, --unlock`：解锁用户的密码；username:!$6s920390203

### 练习

1. 创建用户 `gentoo, UID` 为 `4001`，基本组为 `gentoo`，附加组为 `distro(GID为5000)` 和 `peguin(GID位5001)`

2. 创建用户 `fedora`，其注释信息为 `"fedora Core"`，默认 `shell` 为 `/bin/tcsh`

3. 修改 `gentoo` 用户的家目录为 `/var/tmp/gentoo`；要求其原有文件仍能被用户访问

4. 为 `gentoo` 新增附加组 `netadmin`

### passwd命令

`passwd [-k] [-l] [-u [-f]] [-d] [-e] [-n mindays] [-x maxdays] [-w warndays] [-i inactivedays] [-S] [--stdin] [username]`

1. `passwd`：修改用户自己的密码；

2. `passwd USERNAME`：修改指定用户的密码，但仅 root 有此权限；

- `-l/u`：锁定和解锁用户
- `-d`：清除用户密码串

- `-n DAYS`：密码的最短使用期限
- `-x DAYS`：密码的最长使用期限

- `-w DAYS`：警告期限
- `-i DAYS`：非活动期限
- `-e DATE`: 过期期限，日期

- `--stdin：echo "PASSWORD" | passwd --stdin USERNAME`

### gpasswd命令

- 组密码文件：/etc/gshadow
- `gpasswd [选项] group`
  - `-a USERNAME`：向组中添加用户
  - `-d USERNAME`：从组中移除用户

### newgrp命令：临时切换指定的组为基本组；使用组密码

- `newgrp [-] [group]`
  - `-`: 会模拟用户重新登录以实现重新初始化其工作环境；

### chage 命令：更改用户密码过期信息

- `chage [选项] 登录名`
  - `-d, --lastday LAST_DAY`
  - `-m, --mindays MIN_DAYS`
  - `-M, --maxdays MAX_DAYS`
  - `-W, --warndays WARN_DAYS`
  - `-I, --inactive INACTIVE`
  - `-E, --expiredate EXPIRE_DATE`
  - `-l, --list Show account aging information`

###　id 命令：显示用户的真和有效ID

- `id [OPTION]... [USER]`
  - `-u`: 仅显示有效的UID；
  - `-g`: 仅显示用户的基本组ID; 
  - `-G`：仅显示用户所属的所有组的ID；
  - `-n`: 显示名字而非ID；

### su命令：switch user

> 登录式切换：会通过读取目标用户的配置文件来重新初始化

- `su - USERNAME`
- `su -l USERNAME`

- 非登录式切换：不会读取目标用户的配置文件进行初始化

`su USERNAME`

- 注意：管理员可无密码切换至其它任何用户；`c 'COMMAND'`：仅以指定用户的身份运行此处指定的命令；

### pwck命令

> pwck - verify integrity of password files

### grpck命令

> grpck - verify integrity of group files

### chsh命令 -s SHELL USERNAME

> chsh - change your login shell

### chfn命令

> chfn - change your finger information

### finger命令

> Finger - user information lookup program 

### whoami命令

> whoami - print effective userid

## 权限管理

### rwxrwxrwx

- 左三位：定义user(owner)的权限
- 中三位：定义group的权限
- 右三为：定义other的权限

### 进程安全上下文：进程对文件的访问权限应用模型

1. 进程的属主与文件的属主是否相同；如果相同，则应用文件属主权限；
2. 否则，则检查进程的属主是否属于文件的属组；如果是，则应用文件属组权限；
3. 否则，就只能应用文件其他权限；

### 权限

- r：read，读
- w：write, 写
- x：execute，执行

### 文件

- r：readable, 可获取文件的数据(cat,more,less)
- w：writable, 可修改文件的数据(vim)
- x：excutable, 可将此文件发起运行为进程(默认不应该有执行权限)

### 目录

- r：可使用ls命令获取其下的所有文件列表，不包括详细信息
- w：可修改次目录下的文件列表；即创建或删除文件
- x：可cd至此目录中，且可使用ls -l来获取所有文件的详细属性信息

### mode(模式): rwxrwxrwx

- ownership(拥有权): user, group

### 权限组合机制

- --- 000 0
- --x 001 1 
- -w- 010 2
- -wx 011 3
- r-- 100 4
- r-x 101 5
- rw- 110 6
- rwx 111 7

### 权限管理命令

- chmod命令：
- chmod [OPTION]... MODE[,MODE]... FILE...
- chmod [OPTION]... OCTAL-MODE FILE...
- chmod [OPTION]... --reference=RFILE FILE...

- 三类用户
  - u：属主
  - g：属组
  - o：其他
  - a：所有

### (1) chmod [OPTION]... MODE[,MODE]... FILE...

- MODE表示法：
  - 赋权表示法：直接操作一类用户的所有权限位;
    - u=
    - g=
    - o=
    - a=
    - ug=rw,o=
    - chmod u=rwx,g=rw,o= fstab
  - 授权表示法：直接操作一类用户的一个权限位r,w,x;
    - u+, u-
    - g+,g-
    - o+,o-
    - a+,a-
    - +x 所有执行权限
    - +r 所有读权限
    - +w : 只对属主有权限
    - chmod ug+x fstab
    - chmod u+x,g+w fstab

### (2) chmod [OPTION]... OCTAL-MODE FILE...

- `chmod 660 fstab`

### (3) chmod [OPTION]... --reference=RFILE FILE...

- OPTION:
  - `-R, --recursive`：递归修改,一般应用于授权表示法

- 注意：用户仅能修改属主为自己的那些文件的权限

- 从属关系管理命令：chown, chgrp
  - chown [OPTION]... [OWNER][:[GROUP]] FILE...
  - chown [OPTION]... [OWNER][.[GROUP]] FILE...
  - chown [OPTION]... --reference=RFILE FILE..
    - `-R, --recursive`：递归算法

  - chgrp [OPTION]... GROUP FILE...
  - chgrp [OPTION]... --reference=RFILE FILE...
    - `-R, --recursive`

- 注意：仅管理员可修改文件的属主和属组

- 用户对目录有写权限，但对目录下的文件没有写权限时，能否修改此文件内容？
- 能否删除此文件？不能修改文件内容，可以删除此文件

### umask：文件权限的方向掩码，遮罩码：

- 文件：666-umask
- 目录：777-umask

- root:0022
  - 文件：644
  - 目录：755

- 普通用户：0002
  - 文件：664
  - 目录：775

- 注意：文件用666，表示文件默认不能拥有执行权限；如果减得的结果中有执行权限，则需要将其加1；

- umask: 023
  - 666-023=643, 644
  - 777-023=754

- `umask命令：`
- `umask：查看当前umask`
- `umask MAST：设置umask`

- 注意：此类设定仅对当前 shell 进程有效

### 练习用户命令

1. 新建系统组mariadb，新建系统mariadb，属于mariadb组且没有家目录，shell为/sbin/nologin；尝试root切换至用户，查看其命令提示符；

2. 新建GID为5000的组lingyima，新建用户gentoo，要求其家目录为/users/gentoo,密码同用户名；

3. 新建用户fedora，其家目录为/users/fedora，密码同用户名；

4. 新建用户www，其家目录为/users/www，删除www用户，但保留其家目录；

5. 为用户gentoo和fedora新增附加组lingyima;

6. 复制目录/var/log至/tmp/目录，修改/tmp/log及其内部的所有文件的属组为lingyima,并让属组对目录本身拥有写权限；

### 特殊权限：SUID, SGID, STICKY

#### 安全上下文：

1. 进程以某用户的身份运行；进程是发起此进程用户的代理，因此以此用户的身份和权限完成所有操作；

2. 权限匹配模型；

(1) 判断进程的属主，是否为被访问的文件属主；如果是，则应用属主的权限；否则进入第2步；
(2) 判断进程的属主，是否属于被访问的文件属组；如果是，则应用属组的权限；否则进入第3步；
(3) 应用other的权限；

### SUID

- 默认情况下：用户发起的进程，进程的属主是其发起者；因此，其以发起者的身份在运行；

- SUID的功用：用户运行某程序时，如果此程序拥有SUID权限，那些程序运行为进程时，进程的属主不是发起者，而程序文件自己的属主；

- `chmod u[+-]s FILE...`
  - 展示位置：属主的执行权限位
  - 如果属主原本有执行权限，显示为小写s；
  - 否则，显示为大写S；

- 示例：
  - `cp /bin/cat /tmp/`
  - `chmod u+s /tmp/cat`
  - `/tmp/cat /etc/passwd`

### SGID

- 功用：当目录属组写权限，且有SGID权限时，那么所有属于此目录的属组，且以属组身份在此目录中新建文件或目录时，新文件的属组不是用户的基本组，而是此目录的属组；

- 管理文件的SGID权限：`chmod g[+-]s FILE...`
- 展示位置：属组的执行权限位
- 如果属组原本有执行权限，显示为小写s；否则，显示为大写S；

- 示例：

``` shell
# mkdir -pv /tmp/sgid/test
# chmod g+s /tmp/sgid/test
# chgrp mygrp /tmp/sgid/test
# su - centos
$ touch /tmp/sgid/test/a.centos
$ su - fedora
$ touch /tmp/sgid/test/b.fedora
$ ls -l /tmp/sgid/test
$ su - centos
$ rm -rf /tmp/sgid/b.fedora
```

### Sticky

- 功用：对于属组或全局可写的目录，组内的所有用户或系统上的所用用户对此目录都能创建文件或删除所有的已有文件；如果为此类目录设置Sticky权限，则每个用户能创建新文件，且只能删除自己的文件

- 管理文件的Sticky权限：chmod o[+-]t FILE...
  - 展示位置：其他用户的执行权限位
  - 如果其他用户原本有执行权限，显示为小写t;否则，显示为大写T
  - 系统上的/tmp和/var/tmp目录默认均有sticky权限

`# chmod o+t /tmp/sticky`

- 管理特殊权限的另一种方式：
  - suid sgid sticky 八进制权限
  - 0 0 0 0
  - 0 0 1 1
  - 0 1 0 2
  - 0 1 1 3
  - 1 0 0 4
  - 1 0 1 5
  - 1 1 0 6
  - 1 1 1 7

- 基于八进制方式赋权时，可于默认的三位八进制左侧再加一位八进制数字；例如：`chmod 1777`

### facl：file access control lists文件的额外赋权机制：

> 在原来的u,g,o之外，另一层让普通用户能控制赋权给另外的用户或组的机制

`getfacl命令：`

- getfacl FILE...
  - user:USERNAME:MODE
  - group:GROUPNAME:MODE

``` shell
# file: search/
# owner: root
# group: root
  user::rwx 默认属主权限
  group::r-x 默认属组权限
  group:linux:rwx
  mask::rwx
  other::r-x
```

### setfacl命令

- 赋权给用户：`setfacl -m u:USERNAME:MODE FILE...`
- 赋权给组：`setfacl -m g:GROUPNAME:MODE FILE...`
- 撤销用户赋权：`setfacl -x u:USERNAME FILE...`
- 撤销组赋权: `setfacl -x g:GROUPNAME FILE...`

- 目录赋权给用户: `setfacl -m u:USERNAME:MODE -R FILE`
- 目录赋权给组: `setfacl -m g:GROUPNAME:MODE -R FILE`

- MODE=--- 拒绝某个用户访问控制列表

- 发起进程属主 ? (SUID)命令的属组 -> facl属主 -> 发起进程属组 ? (SGID)命令的属组

## sudo命令

> execute a command as another user

以另外一个用户的身份执行的命令

- 授权机制：sudo的授权文件，`/etc/sudoers`
- 两类内容：
1. 别名的定义，即为变量；
2. 授权项，可使用别名进行授权；

授权项（每行一个授权项）

``` shell
  who where=(whom) commands
  users hosts=(runas) commands
  用户名 主机=(作为谁) 哪些命令
```

- 注意：用户通过sudo获得的授权，只能以sudo命令来启动

``` shell
# man visudo

# sudo [options] command
  -u username：以指定的用户身份运行命令
# sudo -u centos whoami
# usermod -aG wheel centos
# su - centos
# sudo -l
  -l：列出用户能以sudo方式执行的所有命令
  -k：清楚此前缓存的用户认证的密码，默认为5分钟不用输入密码
  %wheel （wheel组）
# usermod -aG wheel centos
```

- who:谁
  - `username`：单个用户
  - `#uid`：单个用户的ID号
  - `%groupname`：组内的所有用户
  - `%#gid`：组内的所有用户
  - `user_alias`：用户别名

- where：在哪里
  - `ip或hostname`：单个主机
  - `NetAddr`：网络地址；
  - `host_alias`：主机别名

- whom：谁的身份
  - `username`
  - `#uid`
  - `runas_alias`

- `commands`: 谁的身份运行命令
  - `command`：单个命令
  - `directory`：指定目录内的所有程序
  - `sudoedit`：特殊权限，可用于向其他用户授予sudo权限
  - `cmnd_alias`：命令别名

``` shell
# which useradd
# which usermod
# visudo
  /etc/sudoers.d
  centos ALL=(root) usr/sbin/useradd, /usr/sbin/usermod, /usr/bin/passwd
# su - centos
$ sudo -l
$ sudo /usr/sbin/useradd slackware
$ tail -1 /etc/passwd
$ sudo userel -r slackware
```

- 定义别名的方法：`ALIAS_TYPE NAME=item,item2,itemn`

- ALIAS_TYPE：
  - User_Alias
  - Host_Alias
  - Runas_Alias
  - Cmnd_Alias

- NAME：别名的名称字符，必须使用全大写字母；

示例

``` shell
User_Alias USERADMINS=tom,jerry
Cmnd_Alias USERADMINCMNDS=/usr/sbin/useradd,/user/sbin/usermod,/user/bin/passwd [a-z]*, !/usr/bin/passwd root, /usr/sbin/userdel
USERADMINS ALL=(root) USERADMINCMNDS
```

- 常用标签：
  - NOPASSWD：不需要输入密码
  - PASSWD: 需要输入秘密，默认为缓存5分钟内，不需要输入

  - centos ALL=(root) NOPASSWD: /usr/sbin/useradd, /usr/sbin/usermod, /usr/bin/passwd, PASSWD: /usr/sbin/userdel

  - root ALL=(ALL) ALL
  - root用户已任何用户身份运行任何命令
  - `%whell ALL=(ALL) ALL`