# MariaDB

DBMS

RDBMS: 关系型数据库管理系统

C/S: 通过专有协议

关系模型：表（行、列）、二维关系

范式：第一范式、第二范式、第三范式

关系运算：选择、投影

## 数据库

表、索引、视图（虚表）

### SQL：Structure Query Language

- DDL: Data Defination Language 数据定义语言

- DML: Data Manipulation Language 数据操作语言

- 编程接口：
  - 存储过程（没有返回值）
  - 存储函数（有返回值）
  - 触发器（事件发生时触发触发器）
  - 事件调度器（类似 crontab）
  - 过程式编程：选择、循环

## 三层模型

- 物理层
- 逻辑层
- 视图层

## RDBMS 解决方案

- Oracle
- Sybase
- Infomix(被IBM收购)
- DB@(IBM)

- MySQL(Oracle)
- MariaDB(Open Source)
- PostgreSQL(Open Source)
- SQLite(Open Source)

- MySQL --> 5.1 --> 5.5 --> 5.6 --> 5.7
- MariaDB

## MySQL 特性

- MySQL 是插件式存储引擎： `MariaDB> show engines;`
- 单进程多线程
  - 连接线程
  - 守护线程

## MySQL 配置文件

> 集中式配置，能够为 mysql 的个应用程序提供配置信息

``` mysql
[mysqld]
[mysqld_safe]
[mysqld_multi] 多实例线程
[server] 服务器配置
[mysql] 客户端配置
[mysqldump] 导入导出工具
[client]

parameter = value

skip-name=resolve 都支持
skip_name=resolve 都支持

```

MySQL 配置文件查找路径（后面的覆盖前面的）

1. `/etc/my.cnf`
2. `/etc/mysql/my.cnf`
3. `$MYSQL_HOME/my.cnf` mysql安装路径
4. 命令行 `--default-extra-file=/path/to/somedir/my.cnf`
5. `~/.my.cnf`

## MySQL 安装方法

### 获取 MySQL

1. os vendor
2. 官方提供的 MySQL 方式: rpm | 展开可用 | 源码

### MySQL 安装后的设定

1. 为所有 `root` 用户设定密码

``` shell
# 第一种
mysql> SET PASSWORD

# 第二种(在内存中)
mysql> update sql.user SET password=PASSWORD('PASS') WHERE cluase;
mysql> flush privileges;

# 第三种
mysqladmin
```

2. 删除所有匿名用户

``` mysql
mysql> DROP USER ''@'localhost';
```

上述两步骤可运行命令(mysql 安装目录下)：`# mysql_secure_installation`

3. 建议关闭主机名反解功能

`skip_name=resolve`

### 元数据的数据库: mysql

- user,host等表

## mysql 客户端

> mysql

### mysql 客户端程序

- 交互式 cli 工具
- `mysqldump`: 备份工具（基于 mysql 协议向 mysqld 发起查询请求，并将查询的所有数据转换成 insert 等些操作语句保存文本文件中）
- mysqladmin: 基于 mysql 协议管理 mysqld 进程
- mysqlimport: 数据导入工具（文本数据导入数据库）

### 非客户端类的管理工具

- myisamchk: 检查 myisam 表
- myisampack: 打包压缩存放

### 客户端应用程序可用选项

``` mysql
# mysql -uroot -p

-u USER， --user=USER

-h HOST, --host=HOST

-P PASSWORD --password=PASSWD

-p, --port=PORT

--protocol={tcp}

-S /PATH/TO/SOCKET, --socket=/PATH/TO/SOCKET

-D db, --database=DB

-C, --compress 是否要压缩

-e "执行语句"

# mysql -e "SHOW DATABASES"

```

## mysql 服务端

> mysqld

## 获取 MySQL 默认使用的配置

- 查看 mysql 客户端默认配置：`# mysql --print-defaults`

- 查看 msql 服务端默认配置：`# mysqld --print-defaults` or `# mysqld --verbose`

## MySQL 的使用模式

### 交互式模式：

- 客户端命令：\h, help
- 服务器端命令：SQL, 需要语句结束符；

### 脚本模式

``` shell
# 第一种
# mysql -uUSER -hHOST -pPASSWD < /path/to/somefile.sql>

# 第二种
mysql> source /path/from/somefile.sql
```

## 服务器端（mysqld）工作特性有多种定义方式

- 命令行选项
- 配置文件参数

``` shell
获取可用参数列表：
# mysqld --verbose --help | less
```

- 获取运行中的 mysql 进程使用各服务器参数及其值

``` shell
mysql> SHOW GLOBAL VARIABLES;

# 只对当前线程有效
mysql> SHOW SESSION VARIABLES;

注意：其中有些参数支持运行时修改，会立即生效；有些参数不支持，且只能通过修改配置文件，并重启服务器程序生效；

有些参数作用域是全局的，且不可改变；有些可以为每个用户提供单独的设置；
```

- 修改服务器变量的值

``` mysql
mysql> help SET

# 全局
mysql> SET GLOBAL system_var_name=value;
mysql> SET @@global.system_var_name=vlaue;

# 会话
mysql> SET [SESSION] system_var_name=value;
mysql> SET @@[session.]system_var_name=value;
```

- 状态变量：用于保存 mysqld 运行中的统计数据的变量

``` mysql

mysql> SHOW GLOBAL STATUS;
mysql> SHOW [session] STATUS;

Com_select
```
