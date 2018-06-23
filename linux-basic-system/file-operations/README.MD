# Linux 文件操作

## Linux文件类型

- -或f：常规文件；regular file；
- d: directory，目录文件；
- b: block device，块设备文件，支持以“block”为单位进行随机访问
- c：character device，字符设备文件，支持以“character”为单位进行线性访问
  - major number：主设备号，用于标识设备类型，进而确定要加载的驱动程序
  - minor number：次设备号，用于标识同一类型中的不同的设备
  - 8位二进制：0-255
- l：symbolic link，符号链接文件；
- p: pipe，命名管道；
- s: socket，套接字文件；

## 文件查找

> 在文件系统上查找符合条件的文件

### locate

- 依赖于事先构建好的索引库
- 系统自动实现（周期性任务）

#### locate 工作特性

- 查找速度快；
- 模糊查找；
- 非实时查找；

- `# locate [OPTIONS] ... PATTERN...`
  - `-b`：只匹配路径中的基名
  - `-c`：仅显示匹配的数量
  - `-r`, `--regexp`：BRE

#### locate 手动更新数据库

`~]# updatedb`

- 注意：索引构建过程中需要遍历整个跟文件系统，极消耗资源；

## find 命令

> 实时查找工具，通过遍历指定起始路径下的文件系统层级结构完成文件查找

### find 工作特性

- 查找速度略慢；
- 精确查找；
- 实时查找；

`find [OPTIONS] [查找起始路径] [查找条件] [处理动作]`

- 查找起始路径：
  - 指定具体搜索目标起始路径；
  - 默认为当前目录；

- 查找条件：
  - 可以根据文件名、大小、类型、从属关系、权限等等标准进行；
  - 默认为找出指定路径下的所有文件；

- 处理动作：
  - 对符合查找条件的文件做出的操作，例如删除等操作；
  - 默认为输出至标准输出；

- 查找条件：
  - 表达式：选项和测试
  - 选项：
    - -maxdepth levels
    - -mindepth levels

  - 测试：结果通常为布尔型（"true"， "false"）

  - 根据文件名查找
    - `-name "pattern"`
    - `-iname "pattern"` 支持glob风格通配符
    - `*,?[],[^]`
    - `-regex "pattern"` 基于正则表达式查找文件，匹配是整个路径

  - 根据文件从属关系查找
    - `-user` USERNAME 查找属主指定用户的所有文件
    - `-group` GROUPNAME 查找属组指定用户的所有文件
    - `-uid UID` 查找属主指定的UID的所有文件
    - `-gid GID` 查找属组指定的UID的所有文件
    - `-nouser` 查找没有属主的所有文件
    - `-nogroup` 查找没有属组的所有文件

  - 根据文件的类型查找
    - `-type {f|d|l|b|c|s|p}`

  - 根据文件的节点查找
    - `-inum NUMBER`

  - 组合测试：
    - `与：-a`, 默认组合逻辑
    - `或：-o`
    - `非：-not, ！`

    - 或条件表达式时，必须加上括号`\(....\)`

    - `find /tmp \( -nouser -o -uid 1003 \) -ls`
    - `find /tmp -not \( -user root -o -iname "*fstab*" \) -ls`

    - `!A -a !B = !(A -o B) -o并(或)`
    - `!A -o !B = !(A -a B) -a交(且)`

    - `# find /tmp ! -user root -a ! -name "*fsta*" -a -type f -ls`
    - `# find /tmp ! \( -user root -o -name "*fsta*" \) -a -type f -ls`

  - 根据文件的大小查找： `-size[+|-]#UNIT`, 常用单位：c,k,M,G
    - `#UNIT：-1 < ? <= #`
    - `-#UNIT: 0 < ? <= #-1`
    - `+#UNIT: # < ?`
    - `find /tmp -size 115k`

  - 根据时间戳查找：
    - 以”天“为单位：`-atime [+|-]#`
    - #：[#, #-1], 大于#-1天至#天
    - -#：[#, 0] , #天内
    - +#：[oo, #-1], #-1天之前所有
    - -mtime
    - -ctime

    - 以“分钟”为单位：-amin, -mmin, -cmin

  - 根据权限查找：
    - `-perm mode`：精确查找
    - `-perm /mode`：任何一类用户(u, g, o)的权限中的任意一位(r,w,x)符合条件即满足；9位权限之间存在"或"关系(包含权限)
      - /002 其他用于有写权限的文件
      - /222 ugo权限当中至少有写权限满足（至少有一个有=任何一位有）

    - `-perm -mode`：每一类用户(u,g,o)的权限中的每一位(r,w,x)同时符合条件即满足；9位权限之间存在"与"关系(包含权限)
    - -222 ugo权限当中所有类必须都有写权限满足
    - -not -222 ugo权限当中至少有一类没有
    - `-perm +mode`

  - 精确查找：`find ./ -perm 644 -ls`

- 处理动作：
  - `-print`：输出至标准输出，默认的动作；
  - `-ls`：输出文件的详细信息，类似于"ls -l"命令
  - `-delete`：删除查找到的文件
  - `-fls /PATH/TO/SOMEFILE`：长格式保存在指定文件
  - `-ok COMMAND {} \;`
    - 对查找到的每个文件执行由COMMAND表示的命令
    - 每次操作显示提示确认执行命令
  - `-exec COMMAND {} \；`对查找到的每个文件执行由COMMAND表示的命令
  - `{}`：查找到的文件的占位符
  - `# find ./ -perm /002 -exec mv {} {}.danger \;`

- 注意：find传递查找到的文件路径至后面的命令时，实现查找出所有符合条件的文件格式，并一次性传递给后面的命令；

- 但是有些命令不能接受过长的参数，此时命令执行会失败，另一种方式可规避此问题；

`find | xargs COMMAND`

``` 示例
查找/var目录下属主为root，且属组为mail的所有文件或目录；
# find /var -user root -a -group mail -ls

查找/usr目录下不属于root, bin或hadoop的所有文件或目录；用两种方法；
# find /usr -not -user root -a -not -user bin -a -not -user hadoop
# find /usr -not \( -user root -o -user bin -o -user hadoop \) -ls

查找/etc目录下最近一周内其内容修改过，且属主不是root用户也不是hadoop用户的文件或目录；
# find /etc -mtime -7 -a -not \( -user root -o -user hadoop \) -ls
# find /etc -mtime -7 -a -not -user root -a -not -user hadoop -ls

查找当前系统上没有属或属组，且最近一周内曾被访问过的文件或目录；
# find  /  \( -nouser -o -nogroup \)  -atime  -7  -ls

 查找/etc目录下大于1M且类型为普通文件的所有文件；
# find /etc -size +1M -type f -exec ls -lh {} \;

查找/etc目录下所有用户都没有写权限的文件；
# find /etc -not -perm /222 -type f -ls

查找/etc目录至少有一类用户没有执行权限的文件；
# find /etc -not -perm -111 -type f -ls

查找/etc/init.d/目录下，所有用户都有执行权限，且其它用户有写权限的所有文件；
# find /etc -perm -113 -type f -ls
```

---

``` shell
find 示例
# find /data -type f -NAME "file.txt" -exec rm {} \;
# find /data -type f -NAME "file.txt" | xargs rm -f

查找/log 目录，刪除 15 天以前修改过的文件
# find /log -type f -name "*.log" -mtime +15 | xargs rm -f

刪除修改日期在30天以前，且以 file 名称结尾的目录
# find /log -type f -name "*file" -mtime +30 | xargs rm -rf

```