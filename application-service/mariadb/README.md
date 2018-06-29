# 数据库简介
##　数据库系统

## 数据库管理系统
- Oracle
- Sybase
- Infomix (IBM收购)
- DB2 (IBM)
- SQL Server (MS)
- PostgreSQL
- MySQL, MariabDB
- mysqlite 文档型（一个文件，通过对文件的赋值完成数据库的赋值）

## RDBMS：关系型数据库管理系统
- C/S：专有协议
- 关系模型：表(行、列)，二维关系

- 三层模型
  - 物理层 (路径环境、主从复制)
  - 逻辑层（内建组件，数据库建立、索引、视图）
  - 视图层 (用户视图，crud,数据库查询操作)

## E-R模型
- E: Entity，实体
  - 一个实体转换为数据库中的一个表
- R: Relationship，关系
  - 1 VS 1
  - 1 VS N
  - N VS N

## 关系运算
- 选择
- 投影

## 三范式
- 1NF: 列不可拆分
- 2NF: 唯一标识
- 3NF: 引用主键

# MySQL数据库

- 数据库：表、索引，视图(虚表)
- SQL接口：Structured Query Language
	- 类似于OS的shell接口
	- 提供编程功能
	- ANSI： SQL标准，SQL-86, SQL-89, SQL-92, SQL-99, SQL-03, ...
    - xml
  - 编程接口：选择，循环
  - SQL代码：
		* 存储过程：procedure (call procename 没有返回值)
		* 存储函数：function	(select funcname有返回值)
		* 触发器：trigger
		* 事件调度器：event scheduler

- 用户和权限：
  - 用户：用户名和密码
  - 权限：管理类、数据库、表、字段
					
- DBMS：DataBase Management System
- RDBMS：Relational

- MySQL：单进程，多线程 
  - 用户连接：通过线程来实现；连接线程
  - 线程池：

- 数据字典：元数据数据库（mysql表）
- 视图层（逻辑层）-映射层-物理层


- 事务(Transaction)：组织多个操作为一个整体，要么全部都执行，要么全部都不执行；

“回滚”， rollback
			
- Bob:8000, 8000-2000
- Alice:5000, 5000+2000
	
- 一个存储系统是否支持事务，测试标准：
  - ACID：
    - A：atomicity,原子性(不可分割)
    - C：consistent, 一致性（两个事务有一致性,加减）
    - I：isolation, 隔离性(事务彼此之间分割, 线上和线下)
    - D：durability, 持久性(内存中处理中，突然停电，必须得完成)
			

## MySQL层次结构

1. SQL接口
  - 分析器： 分析SQL语句
  - 操作求解器：求解如何执行
  - 计划执行器：执行的路径
  - 优化器：选择最优路径
	
2. 存储引擎
  - 事务管理器 
  - 锁管理器

  - 文件存取方法 (速度慢)
  - 缓冲区管理器（热点数据装载至内存中，内存中管理）
  - 磁盘空间管理器 (限定表里最大数据)

  -　恢复管理器 （断电数据恢复）

3. 物理数据文件

### 事务
- 组织多个事务为一个整体，要么全部都执行，要么全部都不执行
- 回滚：rollback


## MySQL特点
- 开源软件
- 跨平台
- 功能强大

## MySQL版本
- MySQL Enterprise Version
  - 5.1 -> 5.5 -> 5.6 -> 5.7
- MariaDB Community Version
  - 插件式存储引擎
    - 查看存储引擎：`show engines`
  - 单进程多线程
		* 连接线程
		* 守护线程

## mysql	
- Unireg(存储引擎，没有SQL接口)
- MySQL AB公司 --> MySQL
- My：作者大女儿的名字
  - 第一个版本在Solaris运行：二进制版本

- MySQL的发行机制：
  - Enterprise(企业版)：线程池，可视化编程组件，提供了更丰富的功能；
  - Community(社区版)：
		
### MariaDB features：
- 插件式存储引擎：
- 存储管理器有多种实现版本，彼此间的功能和特性可能略有区别；
- 用户可根据需要灵活选择； 
- 存储引擎也称为“表类型”；
				
1. 更多的存储引擎；
  - MyISAM：不支持事务
  - MyISAM --> Aria(改进版)
  - InnoDB --> XtraDB(改进版)：支持事务
				
- MySQL-5.1默认存储引擎：MyISAM
- MySQL-5.5+默认存储引擎：InnoDB

2. 诸多扩展和新特性；
3. 提供了较多的测试组件；
4. truly open source；

## 安装和使用MariaDB：	
- 安装方式：

1. 包管理器的程序包（rpm,deb包等）

(a) 由OS的发行商提供

(b) 程序官方提供

2. 源码包
3. 通用二进制格式的程序包
			
### 通用二进制格式安装MariaDB：
1. 准备数据目录,以/mydata/data目录为例

`# mkdir -pv /mydata/data`

`# chown -R mysql.mysql /mydata/data/`

2. 安装配置mariadb						
``` SHELL
# useradd -r mysql
# tar xf mariadb-VERSION.tar.xz -C /usr/local
# cd /usr/local
# ln -sv  mariadb-VERSION  mysql
# cd /usr/local/mysql
# chown -R root:mysql ./*
# scripts/mysql_install_db --user=mysql  --datadir=/mydata/data
# cp support-files/mysql.server /etc/init.d/mysqld
# chkconfig --add mysqld
```

3. 提供配置文件

ini格式的配置文件；各程序均可通过此配置文件获取配置信息；
``` 
 [program_name]
								
1. OS Vendor提供mariadb rpm包安装的服务的配置文件查找次序：
 /etc/mysql/my.cnf  --> /etc/my.cnf  --> --default-extra-file=/PATH/TO/CONF_FILE  --> ~/.my.cnf		

2. 通用二进制格式安装的服务程序其配置文件查找次序：
 /etc/my.cnf 越靠后最终生效的 --> /etc/mysql/my.cnf  --> --default-extra-file=/PATH/TO/CONF_FILE --> ~/.my.cnf

获取其读取次序的方法：`mysqld --verbose --help`

# cp  support-files/my-large.cnf  /etc/my.cnf

添加三个选项
[mysqld]	# mysql服务器端配置
datadir = /mydata/data
innodb_file_per_table = ON
skip_name_resolve = ON
```

4. 启动服务: `# service mysqld  start`

## 设计范式：
- 第一范式：字段是原子性的；
- 第二范式：存在可用主键；
- 第三范式：任何都不应该依赖于其它表的非主属性；
- 约束：主键、惟一键、外键、检查性约束；

- SQL：数据库、表、索引、视图、存储过程、存储函数、触发器、事件调度器、用户和权限
- 元数据数据库：mysql

- DDL: CREATE, ALTER, DROP
- DML: INSERT, DELETE, UPDATE, SELECT
- DCL: GRANT, REVOKE

##　安装 MySQL 5.6

### yum安装 Mariadb

[MariabDB](http://www.mariadb.org)

`# yum -y install mariadb-server`

### 安装后的设定
1. root用户设定密码

```
mysql> set password （自动重读授权表）
mysql> update mysql.user SET password = password('password') where cluase;
mysql> flush privilige
```

`# mysqladmin`

2. 删除所有匿名用户

`mysql> drop user ''@'localhost';`

上述两步骤运行命令：`# mysql_secure_installation`

3. 建议关闭主机名反解功能

my.ini文件中修改 `skip_name_resolve=off`

### 元数据数据库:mysql

user, host 等


### Windows 下安装 MySQL 5.6

[MySQL](https://dev.mysql.com/downloads/mysql/)官网下载地址


## mysql客户端程序

- mysql: 交互式的CLI工具
- mysqldump: 备份工具，基于mysql协议向mysqld发起查询请求，并将查得的所有数据转换成insert等写操作语句保存文本文件中
- mysqladmin： 基于mysql协议管理mysqld
- mysqlimport： 数据导入工具

## 非客户端类的管理工具
- `myisamchk, myisampack`

## 如何获取程序默认使用的配置

`# mysql --print-defaults`

`# mysqld --print-defaults`

`# mysqld --verbose`

--no-auto-rehash 不能命令自动补全（性能差，创建hash计算）


## 客户端类应用程序的可用选项：
-u, --user=

-h, --host=

-p, --password=

-P, --port=

--protocol=tcp|sock(同一个主机上)

-S, --socket=统一主机上及，-h localhost，socket文件路径

-D, --database=

-C, --compress 数据传输时是否压缩

mysql -e "SQL"

## mysql使用模式
- 交互式模式
  - 可运行命令有两类
		* 客户端命令：\h, help
		* 服务器端命令：SQL，需要语句结束符

- 脚本模式
  - `# mysql -uUSERNAME -hHOST -pPASSWORD < /path/from/somefile.sql`
  - `mysql> source /path/from/somefile.sql`

## 服务器端(mysqld)：工作特性有多种定义方式
- 命令行选项
- 配置文件参数
  - 获取可用参数列表 `# mysqld --version --help`

- 获取运行中的mysql进程使用各参数及其值
  - `mysql> show global variables;`
  - `mysql> show [session] variables;`
  - 注意：其中有些参数运行时修改，会立即生效，有些参数不支持，且只能通过修改配置文件，并重启服务器程序生效
  - 有些参数作用域是全局的，且不可该变，有些可以为每个用户提供单独的设置
- 修改服务器变量的值：
  - `mysql> help SET`
  - 全局：
		* `mysql> set global system_var_name=value;`
		* `mysql> set @@global.system_var_name=value;`
  - 会话：
		* `mysql> set [session] system_var_name=value`
		* `mysql> set @@[session.]system_var_name=value`

- 状态变量：用于保存mysqld运行中的统计数据的变量
  - `mysql> show global status;`
  - `mysql> show [session] status;`
    - Com_select
    - Com_delete
    - abored_clients

## MySQL 5.6 特性
- 提高性能和扩展能力
  - 最多扩展48个CPU线程
  - 与v5.5相比，性能提升了230%（疑问：根据什么判断）
- 改进了InnoDB
  - 提升了事务吞吐量和可用性
- 改进了优化器
  - 缩短查询执行时间，增强了诊断，以便更好的进行查询调优和测试
- 改进了赋值
  - 提高了性能、可用性和数据完整性
- 改进了PERFORMANCE_SCHEMA
  - 提供了更好的监测、用户/in公用程序级统计信息和监视
- 对InnoDB进行NoSQL访问，完全符合ACID原则的快速键值访问，提高了开发人员灵活性
- 子查询最佳化，通过优化子查询，可以提高执行效率
 强化Optmizer Diagnostics功能
  - 运行explain执行insert,update和delete，以JSON格式输出，更好的可读性
- 新增Index Condition Pushdown(ICP)和Batch Key Access(BKA)功能
  - 提升特定查询280%
- 自我修复赋值丛集
  - 新增的Global Transaction Identifiers and Utilities检测和复原功能
- 高效能赋值丛集
  - 通过Multi-Threaded Slaves, Binlog Group Commit and optimized Row-Based Replication提高赋值能力高达5倍至多
- 时间延迟赋值，防止主计算机的作业事务


## 配置文件：集中式的配置，能够为mysql的各应用程序提供配置信息
```
[mysqld]
[mysqld_safe] 线程安全
[mysqld_multi] 多实例线程
[server] 服务去程序
[mysql] mysql客户端
[mysqldump] 导入导出
[client] 客户端

parameter = value
parameter绝大多数参数支持下划线和连接线，有的仅支持一种
skip-name-resolve=off
skip_name_reslve=off

命令行启动参数与配置文件参数
```

### Linux下mysql配置查找路径
1. /etc/my.cnf 
2. /etc/mysql/my.cnf
3. $MYSQL_HOME/my.cnf 
4. 启动参数 --default-extra-file=/path/to/somedir/my.cnf 
5. ~/.my.cnf

相同的参数后面的覆盖前面的


## 什么是SQL
> Structured Query Language简称SQL，结构化查询语言，数据管理系统通过SQL语言来管理数据库的数据

## SQL语言的组成部分

### DDL：Data Defination Language
- 数据定义语言，主要用于定义数据、表、视图、索引、触发器
- DROP, CREATE, ALTER
- DB组件：数据库、表、索引、视图、用户、存储过程、存储函数、触发器、事件调度器等
- `mysql> help create`

create相关命令
```
create database
create event
create function
create function udf
create index
create procedure
create server
reate table
create tablespace
create trigger
create user
create view
show create database
show create event
show create function
show create procedure
show crate table
spatial
```

### DML: Data Manipulation Language
- 数据操作语言，主要对数据的增删改查
- `INSERT,UPDATE,DELETE`

### DQL: Data Query Language
- 数据检索语言，用来从表中获的数据、确定数据怎样在应用程序中给出，
- `SELECT` 查询数据

### DCL: Data Control Language
- 数据控制语言，主要用于控制用户的访问权限
- `GRANT, REVOKE, COMMIT, ROLLBACK`

### 编程接口：
- 存储过程
- 存储函数
- 触发器
- 事件调度器
- 过程式编程：选择，循环

### Windows启动服务和关闭服务
`net start|stop|restart mysql`

### 设定字符集
> Server characterset: utf8
> Db characterset: utf8
> Client characterset: utf8
> Conn. characterset: utf8
`\s`

#### my.ini

```
[mysql]
default-chracter-set=utf8 客户端字符集

[mysqld]
charcter-set-server=utf8 服务器端字符集
```

#### 登录与退出

`mysql options ...`

- -u,--usenrame=name
- -p, --password[=pw]
- -h, --host=name
- -p, --port=#
- -D, --database=name
- --prompt=name, 设置命令提示符
  - \D	full date
  - \d	current database
  - h		hostname
  - u 	username
- --delimiter=name，指定分隔符
- -V,--version，输出版本信息并且退出

`mysql> exit | quite | \q | Ctrl + c 退出`

`mysql>prompt \n~\u~\D~\d`

### MySQL常用命令
- `SELECT VERSION();`
- `SELECT NOW();`
- `SLEECT USER();`

### 修改命令分隔符
- `mysql> DELIMITER //`
- `mysql> SELECT VERSION//`

### 保存命令历史文件
- `mysql> \T /path/to/file`
- `mysql> SELECT NOW();		命令和结果都保存于/path/to/file` 
- `mysql> \T 结束`


## 数据库操作

### 创建数据
create database | schema [it not exits] db_name [[default] character set [=] 'charset_name']

```
CREATE DATABASE IF NOT EXISTS db DEFAULT CHARACTER SET 'UTF8';
mysql> help create database
mysql> ? create database
mysql> \h create database
```

`mysql> show warnings 查看警告信息`

### 查看数据库列表
> show database | schemas

### 查看数据库定义
> show create database | schema db_name

### 修改数据库编码字符集
> alter database | schema db_name [default] character set[=]charset_name

- charset_name
  - gbk
  - utf8

### 获取当前数据名称
> select database() | schema()

### 删除数据库
> drop databse | schema [if exits] db_name

### 打开数据
> use db_name

## 数据类型

- SQL接口：ANSI SQL
  - SQL-86, SQL-89, SQL-92, SQL-99, SQL-03

### 整数类型, 精确数值型
- tinyint, 1byte
  - signed : -128~127(-2^7~2^7-1)
  - unsigned : 0~255(0~2^8-1)
- smallint, 2byte
  - signed : -32768~32767(-2^15~2^15-1)
  - unsigned : 0~65535(0~2^16-1)
- mediumint, 3byte
  - signed : -8388608~8388607(-2^23~2^23-1)
  - unsigned : 0~16777215(0~2^24-1)	
- int, 4byte
  - signed : -2147683648~2147683647(-2^31~2^31-1)
  - unsigned : 0~4294967295(0~2^32-1)	
- bigint, 8byte
  - signed : -9223372036854775808~9223372036854775807(-2^63~2^63-1)
  - unsigned : 0~18446744073709551615(0~2^64-1)	
- bool,boolean, 1byte
  - tinyint(1), 0为false,其余为true

`mysql> help int`

`mysql> ? int`

`mysql> \h int`

###　浮点类型, 近似数值型
- float（m,d), 4byte
  - -3.40E+38 ~ -1.17E-38
  - 0和1.17E-38 ~ 3.40E+38
  - M数字总位数，D是小数点后面留位数
  - D和M被省略，根据硬件允许的限制来保存值
  - 小数有效位7位
- double(m,d), 8byte
  - -1.79E+308 ~ -2.22E-308
  - 0 ~ 2.22E-
- decimal(m,d)， M+2
  - double一样，内部已字符串形式存储数值
  - where f_name='30'
- bit

###　字符串类型
- char(m), m个 byte，定长数据类型，不区分字符大小写
  - 0 <= m <= 255
- binary(m) 区分字符大小写

- varchar(m), L+1 byte，变长数据类型，需要结束符
  - L <= m and 0 <= m <= 65535
- varbinary(m) 区分字符大小写

- tinytext, L+1 byte 不区分字符大小写
  - L < 2^8
- text, L+2 byte
  - L < 2^16
- mediumtext, L+3 byte
  - L < 2^24
- longtext, L+4 byte
  - L < 2^32

- blob: tinyblob,blob,mediumblob,longblob

- enum('v1','v2',...), 1或2个 byte
  - 取决于枚举值得个数（最多65535个值）
  - 可以存储NULL值

- set('v1','v2',...), 1,2,3,4或者8个 byte
  - 取决于set成员的数目（最多set的成员数目）
  - 最多64个成员
  - a,b,c
    - a => 100
    - a,b => 110
    - a,c => 101

- 前缀空白字符
  - char,varchar保存到表中
- 后缀空白字符
  - char不保存空白字符
  - varchar保存空白字符
- 中文字符占用一个空间位置

### 日期时间类型
- time, -838:59:59 ~ 838:59:59, 3 byte
- date, 100-01-01 ~ 9999-12-31, 3 byte
- datetime, 1000-01-01 00:00:00 ~ 9999:12-31 23:59:59, 8 byte
- timestamp, 1970-01-01 00:00:01 UTC ~ 2038-01-19: 03:14:07, 4 byte
- year, 1970 ~ 2155, 1 byte
  - year(2) 00-99
  - year(4) 1901-2155

## 存储引擎
> 表的类型，表在计算机中的存储方式

### 完整性约束条件
- UNIQUE KEY
  - NULL不算重复的值
- FOREIGN KEY
- UNSIGNED
- ZEROFILL
- AUTO_INCREMENT
- [PRIMARY] KEY
- NOT NULL
- NULL
- DEFAULT
- COMMENT

- 插入数据关键值
  - DEFAULT
  - NULL
- character set 'utf8' 字符集
- collation 排序规则
默认继承数据库或表

```
mysql> show character set
mysql> show collation
```

- 字符串类型修饰符：not null, null, default, character set, collation
- 整数数据修饰符：not null, null, default number, zerofill, auto_increment(unsgined,primary key | unique key, not null
  - `mysql> select last_insert_id()` 最后插入ID号
- 日期时间修饰符：not null, null,default
- 内建类型SET和ENUM的修饰符：not null, default

### SQL MODE: 定义mysql对约束等的响应行为
```
mysql> set global sql_mode='string'
mysql> set @@global.sql_mode='string'
```

- 需要修改权限，不会立即生效，只会对新建的会话生效，对已经建立的会话无效
- 立即生效，使用会话方式

```mysql> set session sql_mode='string'
mysql> set @@session.sql_mode='string'

mysql> show global variables like 'sql_mode'
mysql> show global variables like 'sql_%'
```

- 为空，没有任何模式

- 常用 MODE：
  - `tranditional` 创痛模型（非法值不能插入）
  - `strict_trans_tables` 只对事务的表进行强行限制
  - `strict_all_tables` 对所有表进行强行限制

- 为空：char(5) => insert "eric", "Black Write" => 自动截取 "eric" "Black"
- tranditional: set sql_mode='TRANDITIONAL'
  - insert "eric", "Black Write" => 出错，不能输入

- 永久有效
  - 启动服务命令行参数
  - 配置文件，全局参数

### 查看存储引擎
`show engines \G`

- Support：是否支持引擎
- Comment：注释
- Transactions: 是否支持事务处理
- XA：是否支持分布式
- Savepoints: 是否保存点（事务）

### 查看支持的存储引擎信息
`show variables like 'have%'`

### 查看默认的存储引擎
`show variables like 'storage_engine'`

### MySQL常用存储引擎
- InnoDB存储引擎
  - 事务
  - 外键
  - 读写效率比较低
  - xx.frm, xx.ibd
- MyISAM存储引擎
  - 不支持事务、外键
  - 读写效率高
  - 磁盘空间小
  - 不支持并发性处理
  - xx.frm, xx.MYD, xx.MYI
- MEMORY存储引擎
  - 数据存放到内存中
  - 读写效率高

### 创建表

```
-- 注释内容
SET NAMES UTF8
-- 输入中文的时候，需要临时转换客户端的编码方式
SET NAMES GBK
create table [if not exists] tbl_name(...)
engine=INNODB AUTO_INCREMENT=100 [DEFAULT] charset=UTF8
```

1. 直接创建
2. 通过查询现存的表创建

```
create [temporary] table [if not exists] tbl_name
[(create_definition,...)]
[table_options]
[partition_options]
select_statement
```

3. 通过复制现存的表的表结果创建；不复制数据

```
create [temporary] table [it not exists] tbl_name
{ like old_tbl_name | (like old_tbl_name) }
```

- 注意：Storage Engine是指表类型，在表创建时指明其使用的存储引擎
  - 同一个库中标要使用同一种存储引擎类型

- 定义：字段，索引
  - 字段，字段名，字段数据类型，修饰符
  - 约束：索引，应该创建在经常用作查询条件的字段上
    - 索引：实现级别在存储引擎
- 索引分类：
  - 稠密索引
  - 稀疏索引
  - B+索引、hash索引、R树索引、FULLTEXT索引
  - 聚集索引、非聚集索引
  - 简单索引、组合索引

### 查看表结构

```
DESC tbl_name
DESCRIBE tbl_name
SHOW COLUMNS FROM tbl_name
```

### 查看表状态信息

`show table status like 't1' \G`

- Name 标明
- Engine
- Version
- Row_format: compact（紧致） 行格式： 紧致|固定|动态
- Rows: 2
- Avg_row_length： 平均每行的字节数
- Data_length ： 表中数据的大小
- Max_data_length 表数据的最大容量，跟存储引擎有关
- Index_length 索引大小，字节大小
- Data_free 目前已经分配，但未被使用
- Auto_increment 自动增长数字值
- Create_time 创建时间
- Update_time 最近一次修改时间
- Check_time : check table 时间 myisam
- Collation : 培训规则
- Checksum ： 表的校验和
- Create_options : 创建表的额外选项
- Comment：注释

## 重命名表

```
alter table tbl_name rename to tbl_new_name
alter table tbl_name rename as tbl_new_name
alter table tbl_name rename tbl_new_name
alter table tbl_name to tbl_new_name
```

## 修改表格结构

```
添加字段
alter table tbl_name
add 字段名1  after|before target_filed
add 字段名2  after|before target_filed

修改字段
alter table tbl_name change 旧字段名 新字段名
alter table tbl_name modify 字段名 ... first|last

删除字段
alter table tbl_name
drop 字段名1
drop 字段名2

删除默认值
alter table tbl_name alter 字段 drop default

添加主键
alter table tbl_name add primary key(id[,name])
alter table tbl_name add constant symbol primary key index_type(id)

删除主键
alter table tbl_name drop primary key   # auto_incrment是删除不了
alter table tbl_name modify id int unsigned # 受限移除auto_increment约束
alter table tbl_name drop primary key 删除成功

添加唯一
alter table tbl_name add [constant [symbol]] unique [index|key] 索引名称(字段名称[,..])

删除唯一
alter table tbl_name drop {index|key} index_name

修改存储引擎
alter table tbl_name engine=INNODB charset=utf8

修改自增长的值
alter table tbl_name auto_increment=100
```

## 删除数据表

`drop table if exists tbl_name[,tbl_name2[,tbl_name3]]`
`show warnings`

## 插入数据

- 不指定字段名
`insert into tbl_name VALUES|VALUE (val...)`

- 列出指定字段
`insert into tbl_name(f1,...) VALUES|VALUE (val...)`

- 同时插入多条记录
`insert into tbl_name(f1,...) VALUES (val...),(val2...)`

- 通过SET形式插入记录
`insert into tbl_name SET 字段名称=值,...`

- 查询结果插入到表中
`insert into tbl_name(f1,...) select 字符名称 tbl_name [where 条件]`

## 更信数据

`update tbl_name set f=v[,f=v] where [条件]`

## 删除数据

`delete from tbl_name [where 条件]`

`trancate table tbl_name`

## 常用函数

- char_length("中文")  --2
- concat(str,str)

##　备份与恢复
### 备份

`# mysqldump -uroot -p database_name > /PATH/TO/datbase_name.sql`

### 恢复

`# mysql -uroot -p database_name < /PATH/TO/database_name.sql`

# DQL (Data Query Language)

## 查询记录

```
select {*|field} from tbl_name
where [条件]
group by {col_name | position} [ASC | DESC]
having 条件
order by {col_name | position} [ASC | DESC]
[limit index length]
```

## where条件

- 比较: =, <, >, <=, >=, <>, !>, !<, <=>
  - age <=> NULL 与 age IS NULL
- 指定范围: between and, not between and
- 指定集合: in, not in
- 匹配字符: like, not like
  - % {0,}
  - _ {1}
- 是否为控制: is null, is not null
- 多个查询条件: and, or

## 分组查询

### 字段分组

- group by gender

### 字段位置分组

- group by 7

### 多个字段分组

- group by gender,partNo

### 分组查询

- `group_concat(字段)` 分组详情
- count(age) **不统计null值**
- max()
- min()
- avg()
- sum()
- with rollup 统计记录的共和记录
  - group by gender with rollup

## 连接查询

### 内连接查询(NxN)

- [inner|cross] join on 连接条件
- 示例：

```
select A.f, B.f from A,B where A.proId=B.id
select a.f, b.f from A as a inner join B as b on a.proId=b.id
select a.f, b.f,b.proName,count(*) as total_users,group_concat(username) from A as a join B as b on a.proId=b.id where a.gender=1 group by b.proName having count(*) > 1 order by a.id asc
```

### 外连接查询

- left [outer] join
  - 没有数据使用NULL值来显示
- right [outer] join

## 外键

> 数据表存储引擎只能为InnoDB

``` mysql
-- 部门表：department
create table if not exists department(
id tinyint unsigned auto_increment key,
depName varchar(20) not null unique`
)engine=InnoDB;

insert into department(depName) values('教学部'),
(市场部),
(运营部),
(督导部);

-- 员工表：employee（子表）
create table if not exists employee(
id smallint unsigned auto_increment key,
username varchar(20) not null unique,
depId tinyint unsigned,
constraint emp_fk_dep foreign key(depId) references department(id)
)engine=InnoDB default charset=utf8;

insert employee(username,depId) values('king',1),
('queen',2),
('张三',3),
('王五',1),
('李四',4);

select e.id,e.username,d.depName
from employee as e
join
department as d
on d.depId=d.id

-- 删除督导部
delete from department where depName='督导部';
```

注意：删除员工表的记录之后才能删除部门表的记录

### 删除外键

``` mysql
alter table employee drop foreign key emp_fk_dep
show create table employee
```

### 添加外键

`alter table employee add constraint emp_fk_dep foreign key(depId) references department(id);`

- 删除employee表中没有部门编号的记录删除

### cascade: 从父表删除或更新且自动删除或更新子表中匹配的行

``` mysql
-- 员工表：employee（子表）
create table if not exists employee(
id smallint unsigned auto_increment key,
username varchar(20) not null unique,
depId tinyint unsigned,
constraint emp_fk_dep foreign key(depId) references department(id) on delete cascade on update cascade
)engine=InnoDB default charset=utf8;
```

### set null: 从父表删除或更新，并设置子表中的外键列为null, 如果使用该选项，必须保证子表没有指定not null

```
-- 员工表：employee（子表）
create table if not exists employee(
id smallint unsigned auto_increment key,
username varchar(20) not null unique,
depId tinyint unsigned,
constraint emp_fk_dep foreign key(depId) references department(id) on delete set null on update set null
)engine=InnoDB default charset=utf8;
```

### restrict: 拒绝对父表的删除或更新操作

### no action: 标准SQL的关键字，在MySQL中与restrict相同

## 联合查询, 查询字段数目必须相同
- union (去掉相同记录）
- union all
`select username from employee union all select username from cms_user`

# 子查询

> 一个查询语句嵌套在另一个查询语句中

- 使用[not] in 的子查询
  - `select id,username from employee where deptID in(select id from department)`
- 使用比较运算符的子查询：=,>,<,>=,<=,<>,!=,<=>
  - `select id,username from employee where deptID score<=(select id from department where id=20)`
- 使用[not] exists的子查询
  - 内层语句执行为true时，执行外层语句
  - `select id,username from employee where exists(select * from department where id=5)`
- 使用any|some或则ALL的子查询
  - >,>=, any(最小值), some(最小值), all(最大值)
  - <,<=, any(最大值), some(最大值), all(最小值)
  - =, any(任意值), some(任意值)
  - <>, !=, all(任意值)

  - 查询所有获的奖学金的学生
    - `select id,username,score from student where score>=any(select level from sholarship)`
  
  - 查询所有学员中获得一等奖学金的学员
    - `select id,username,score from student where score>=all(select level from sholarship)`

  - 查询所有学员中没有获得奖学金的学员
    - `select id,username,score from student where score<all(select level from sholarship)`
    - `select id,username,score from student where score=any(select level from sholarship)`
    - `select id,username,score from student where score in(select level from sholarship)`
    - `select id,username,score from student where score not in(select level from sholarship)`
    - `select id,username,score from student where score <> all(select level from sholarship)`

# 正则表达式
`SELECT * FROM cms_user where username regexp '^t'`

- ^：匹配字符开始的部分
- $：匹配字符结束的部分
- .：匹配任意单个字符，包括回车和换行 与_相似 
- [字符集合]
- [^字符集合]
- S1|S2|S3：匹配S1，S2，S3中的任意一个字符串
- *：代表0个1个或者多个其前的字符
- +：代表1个或者多个其前的字符
- String{N}：字符串出现N次
- 字符串{M,N}：字符串至少出现M次，最多N次

# mysql 运算符

## 算数运算符
- +,-,* 加减乘
- /,DIV 除法
- %,MOD 去余

## 比较运算符
- =
- <>, !=
- <=> 判断是否相等，可以判断是否已等于NULL
- >, >=
- <, <=
- is null, is not null
- between and, not between
- in, not in
- like, not like
- regexp

## 逻辑运算符
- && 或者 AND
- || 或者 OR
- ! 或者 NOT
- XOR 异或

# 数学函数库
- CEIL(), CEILING()
- FLOOR()
- ROUND()
- MOD(3,8) -- 3
- POW(2,3), POWER(3,3) -- 8, 27
- TRUNCATE(3.1415) -- 3.14
- ABS()
- PI()
- RAND(1)
- SIGN() - 1, 0, -1 符号
- EXP(3) - E的3次方, 20.085536

# 字符串函数
- char_length('lingyima') 字符数，英文中文占一个字符
- length('lingyima') 长度，utf8中文一个中文占3个长度
- concat(s1,s2)
- concat_ws("_",'a','b','c') -- a_b_c
  - concat_ws(NULL,'a','b') -- NULL
  - concat_ws("_",'a','b','c',NULL) -- a_b_c 
- upper(),ucase()
- lower(),lcase()
- left(string, 2)
- right(string, 2)
- lpad('A',5, '?') -- ????A
- rpad('A',5,'!') -- A!!!!
- trim(' ABC ')
- ltrim(' ABC ')
- rtrim(' ABC ')
- trim('A' FROM 'ABCBCA') -- BCBC
- repeat('H',5) -- HHHHH
- space(5) 空格数量
- replace(string,old,replace)
- strcmp('a','a') 不区分大小写
- strcmp('A','a') -- 0 
- strcmp('B','A') -- 1
- strcmp('A','B') -- -1
- substring(string,index,length)
  - index从1开始
- reverse()
- elt(2,'A','B','C') 返回指定位置的字符串，索引1开始


# 日期时间函数
- now() -- YYYY-mm-dd HH:MM:SS
- curdate(),current_date()
- curtime(), current_time()
- month('2014-1-3') -- 1
  - month(now())
- monthname() - January
- dayname(now()) - Saturday
- dayofweek(now()) - 一周之内的第几天，1代表星期日
- weekday(d) - 0：星期一
- week() - 一年中的第多少个星期
- year(now())
- hour()
- minute()
- second()
- datediff(current_date(), '1990-1-1')


# 条件判断函数
- if(expr, v1, v2) 
- ifnull(v1,v2) v1不为空显示v1, 否则v2
- case when expr1 
then v1 [when exp2 
then v2] [else vn] 
end

# 系统函数
- version()
- connection_id() 服务器的连接数
- database(),schema()
- user(), system_user() 当前用户
- current_user(), current_user 当前用户
- charset(STR) 		STR的字符集
- collation(STR) 	字符串STR的校验字符集
- LAST_INSERT_ID()  最近生成auto_increment的值

# 其他常用函数

- md5() -- 32位字符串
- password() -- mysql用户加密函数
- format(3.1415,2)
- ASCII(s) 				返回ASCII码
- bin(x)
- hex(x)
- oct(x)
- conv(88,10,16) 		将x从f1进制数变成f2进制数
- inet_aton(ip) 		将IP地址转换为数字
- inet_ntoa(n) 			将数字转换成IP地址
- get_loct(name,time) 	定义锁
  - is_free_lock('king') -- 0 表示存在
- release_lock(name) 	解锁

# 索引的使用
> 优点是提高检索数据的速度
> 缺点是创建和维护索引需要耗费时间
> 索引可以提高查询速度、会减慢写入速度


## 普通索引
`index|key idx_name(filed[,filed2])`

## 唯一索引
`unique idx_name(filed[,filed2])`

## 全文索引
`fulltext index full_name(filed)`

## 单列索引
## 多列索引
## 空间索引
```
test geometry not null
spatial index spa_test(test)
)engine=myisam
```
## 删除索引
- `drop index idx_name on tbl_name`
- `alter table tbl_name drop index idx_name`

## 创建索引
```
create  index idx_name on tbl_name(id)
alter table tbl_name add index idx_names(username)
create unique|fulltext index u_idx_name on tbl_name(username)
```

# mysql编码设定

## 服务器编码格式

`mysql> show variables like 'char%';`

character_set_client latin1

character_set_connection latin1

character_set_database latin1

character_set_filesystem latin1

character_set_results latin1

character_set_server latin1

character_set_system utf8

## my.ini
[mysql]
`default-character-set=utf8`

- 影响效果
  - `character_set_database utf8`  
  - `character_set_server utf8`
```
[mysqld]
character-set-server=utf8
```

重启mysql服务

`mysql> set names 'utf8'`

## table 编码格式

- 1.插入数据（中文）时出错
  - 表的编码格式不支持中文
  - 解决:`alter table tbl_name character set utf8` 
  - 数据列的编码格式
  - 解决:`alter table tbl_name change name name varchar(20) ch aracter set utf8 not null;`....

- 2.多张表拥有数据编码
  - 2.1 导出表结构：`mysqldump -uroot -p --default-character-set=utf8 -d db_name > file-desc.sql`
  - 2.3 数据导出：`mysqldump -uroot -p --quick --no-create-info --extended-insert --default-character-set=utf8 db_name > file-data.sql`
    - --quick 快速
    - --no-create-info 不导出结构
    - --extended-insert 多行输出

- 3. 删除原有数据库的表
- 4. 新的编码格式创建数据库
  - `mysql -uroot -p db_name < file-desc.sql`
  - file-data文件中加入`set names 'utf8'`
  - `mysql -uroot -p db_name < file-data.sql`

# 会话变量和全局变量

## 会话变量

> clien与server相关联的变量，客户端所拥有的变量

- 查看会话变量: `show session variables;`
- 查看某个变量: `show session variables like 'auto%'`
- 修改会话变量: `set autocommit='off';` `set @@session.autocommit='off'`

## 全局变量

> mysql客户端和服务端都有效

- 查看全局变量: `show global variables like`

- 查看某个全局变量: `show global variables like 'auto%'`

- 设置全局变量
```
set global autocommit='off';
set @@global.autocommit='off'
```

- 查看全局变量: `select @@global.autocommit;`

## MySQL Arch

Connection -> Coonection Pool -> SQL Interface -> Parser -> Optimizer -> Caches & Buffers -> Pluggable Storage Engine

- Connectors
  - Native C API
  - JDBC
  - ODBC
  - NET
  - PHP
  - Perl
  - Python
  - Ruby
  - Cobol

- 单进程多线程
  - 用户连接：连接线程

- Connection Pool （线程池：客户端并发请求处理）
  - Authentication 连接认证
  - Thread Reuse 线程重用（销毁之后，如线程池，变为空闲线程）
  - Connection Limits（连接限制）
  - Check Memory（检查内存）
  - Caches（线程缓存）

- SQL Interface (DML,DDL, Stored Procedures, Views,Triggers, etc)
- Parser (Query Translation, Object Priviledge)
- Optimizer( Access paths, Statistics)
- Caches & Buffers (Global and Engine Specific Caches & Buffers)

- Management Services & Utilities
  - Backup & Recovery
  - Security
  - Replication
  - Cluster
  - Administration
  - Configuration
  - Migration & Metadata

- Pluggable Storage Engines (Memory, Index & Storage Management)
  - MyISAM
  - InnoDB
  - NDB
  - Archive
  - Federated
  - Memory
  - Merge
  - Partner
  - Community
  - Custom

- File System (NTFS, ufs, ext2/3, NfS,sAN,NAS)
- File & Logs (Redo, Undo, Data, Index, Binary, Error, Query and Slow)

## MySQL数据文件类型

- 数据文件、索引文件
- 重做日志、撤销日志、二进制日志、错误日志、查询日志、慢查询日志、中继日志

## MySQL架构流程

用户-> 连接管理器-线程管理器-用户模块

用户连接之后，直接到->用于模块

查询缓存<-命令派发器->记录日志

分析器

- 优化器
- 表修改模块
- 表维护模块
- 复制模块
- 状态报告模块

访问控制模块

表管理器

存储引擎接口

- MyISAM
- InnoDb

## MySQL's Logical Archtecture

- client
- 连接/线程处理
- 查询缓存 <- 分析器
- 优化器
- 存储引擎
- 文件系统

## 索引

> 按特定数据（排序的数据）结构存储的数据

### 索引类型

- 聚集索引、非聚集索引：数据是否与索引存储在一起
- 主键索引、辅助索引
- 稠密索引、稀疏索引：是否索引了每一个数据项
- B+ Tree、Hash（一对一，不能排序），R Tree(空间索引)
- 简单索引，组合索引
- 左前缀索引：
  - LIKE "abc%"
- 覆盖索引

### 管理索引

- 创建索引：创建表时指定
- 创建或删除索引：修改表的命令
- 删除索引：drop index
- 查看表上的索引：
  - `show {index|indexes|keys} {from|in} tbl_name {from|in} db_name [WHERE expr]`
  - `explain SELECT * FROM students WHERE StuId=3\G`

- type: 扫描方式
  - const (1对1)
  - ALL

## 视图

- 虚表：存储的select语句
- 创建视图：`create view v_name as select_statement`
- 删除视图：`drop view v_name`

- 生意： 视图中的数据事实上存储于“基表”中，因此，其修改操作也会针对基表实现；其修改操作受基表限制

### select: Query Cache

`select now();`

- 查询执行路径中的组件：查询缓存、解析器、预处理器、优化器、查询执行引擎、存储引擎

- memcache（哈希算法）

### select 语句的执行流程

1. from
2. where
3. group by
4. having
5. order by
6. select: selects columns
7. limit

### 单表查询

`select [ALL |　DISTINCT |DISTINCTRON]
[SQL_CACHE] [SQL_NO_CACHE]
[for update | lock in share mode]`

- DISTINCT: 数据去重
- SQL_CACHE：显示指定存储查询结果与缓冲之中
- SQL_NO_CACHE：显示查询结果不予缓存

- query_cache_type的值哦"ON"时，查询缓存功能打开
  - select的结果符合缓存条件即会缓存，否则，不予缓存
  - 显示指定sql_no_cache，不予缓存

- query_cache_type的值哦"DEMAND"时，查询缓存功能按需进行；
  - 显示指定select sql_cache的语句才会缓存，其他均不予缓存

- `query_cache_size = 16777216` 16MB
- `SHOW global variables like 'query%`
- `SHOW global variables like 'qcache%`
  - Qcache_hits 2 命中次数
- `SHOW global variables like 'Com_se%`
  - Com_select 43 查询次数

命中次数/查询次数

### 字段别名

`field as newName`

### where 子句：指明过滤条件以实现“选择”的功能

- 过滤条件：布尔型表达式
- 算术操作符：+,-,*,/,%
- 比较操作符：=,!=,<>,<=,>=,<,>
  - between min_num and max_num
  - in(e1,e2,...en)
  - is null
  - is not null
  - like [%_]
  - rlike | regexep : 匹配字符串可用正则表达式或书写模
  - 逻辑操作符：NOT,and, or ,xor

### group by：根据指定的条件的查询结果进行“分组”以用于做“聚合”运算

- avg(),min(),max(),sum(),count()
- having：对分组聚合运算后的记过指定的过滤条件
- order by：根据指定的字段对查询结构进行排序
  - ASC：升序
  - DESC：降序
- limit [ofsset,row_count]：对查询的结果进行输出行数数量限制

### 对查询结果中的数据请施加“锁”：

- `for update`: 写锁，排他锁 （不能读写）
- `lock in share mode`：读锁，共享锁

### 多表查询

- 交叉连接：笛卡尔乘积
- 内连接：
  - 等值连接：让表之间的字段以“等值”尽力连接关系
  - 不能值连接
  - 自然连接
  - 自连接
  - 外连接：
    - 左外链接：from tb1 left join tb2 on tb1.col=tb2.col
    - 右外链接：from tb1 right joing tb2 on tb1.col=tb2.col

### 子查询：嵌套的的语句叫做子查询

> 基于其语句的查询结构再次进行的查询

### where子句子查询

- 用于比较表达式中的子查询：资产讯仅能返回单个数 : `SELECT Name，Age from students where Age>(select avg(Age) from students)`
- in中的子查询：子查询应该单键查询并返回一个或多个值从构成列表 : `SELECT Name，Age from students where Age IN(select Age from students)`
- 用于`exists`

#### 用于from子句中的子查询

使用格式：`select tb_alias.col1,... from (select clause) as tb_alias Clause;`

`select a,classID (select avg(Age) as a from students where ClassID is not null group by ClassID) as t where t.a>30`

### 联合查询：union

`select Name,Age From teacher union select Name,Age from teachers`

## Storage Engine

表类型
``` mysql
create table ... engine[=]storage_engine_name...
show table status [like|where]
```

## InnoDB：数据存储于“表空间（table space）”中

1. 所有InnDB表的数据和索引存储于同一个表空间中

- 表空间文件：datadir定义的目录下
- 文件：ibddata1,ibdata2,...

2. 每个表单独使用一个表空间存储表的数据和索引

- `innodb_file_per_table = ON`
- 数据文件（存储数据和索引）：tbl_name.lbd
- 表格式定义：tbl_name.frm
- 文件存储于数据库目录中

- 事务型存储引擎，适合处理大量的短期事务：
- 基于MVCC支持高并发；支持所有的四个隔离级别，默认级别为repeatable read；间隙锁防止幻读；
- 使用聚集索引（主键索引）索引和数据存储在一起
- 支持“自适应hash索引”
- 锁粒度：行级锁

- 注意：percona,percona-server
  - InnoDB改进成XtraDB
  - MadriaDB(InnoDB => XtraDB)

- 数据存储：表空间
- 并发：MVCC, 间隔锁
- 索引：聚集索引、辅助索引
- 性能：预读操作，自适应hash索引，插入缓存区
- 备份：支持热备（xtrabackup）

## MyISAM

- 支持全文索引(fulltext index)、压缩、空间函数（GIS）
- 不支持事务
- 锁粒度：表级锁
- 崩溃后无法安全恢复

- 使用场景  
  - 只读（或者读多写少）、较小的表（可以接受较长时间的修复操作）

- 注意：MariaDB, Aria(crash-safe tables)

- 文件：每表三个文件，存储于数据库目录中
  - tbl_name.frm: 表格式定义
  - tbl_name.MYD: 数据文件
  - tbl_name.MYI: 索引文件

- 特性：
  - 加锁和并发：表级锁
  - 修复：手动或自动修复，但可能会丢失数据
  - 索引：非聚集索引
  - 延迟更新索引
  - 表压缩

- 行格式：dynamic,fixed,compressed,compact,redudent

`show global variables like '%storage%'`

- default_storage_engine
- storage_engine

`show engines`

## 其他的存储引擎

- CSV: 将普通的CSV文件（字段基于逗号分隔）作为MySQL表使用
- MRG_MYISAM: 由多个MyISAM表合并形成的虚拟表
- BLACKHOLE: 类似于dev/null，不真正存储任何数值
- MEMORY: 基于内存存储，支持hash索引，表级锁；常用于临时表
- performance_schema
- archive: 只支持select和insert操作，支持行级锁；
- federated: 用于访问其他的远程的MySQL Server的代理接口，它通过创建一个到远程MySQL Server的客户端连接，并将查询语句传输至远程服务器执行

## MariaDB支持的其他存储引擎

- OQGraph
- SphinxSE
- TokuDB
- Cassandra (访问接口，facebook分布式无中心的,NoSQL)
- CONNECT
- SQUENCE

## 搜索引擎

- Lucene (Java)
- sphinx (C++)

## 并发控制：

- 锁类型：
  - 读锁：共享锁，可共享给其他的读操作
  - 写锁：独占锁(不能select语句)
- 锁粒度：
  - 表级锁
  - 行级锁
- 锁策略：在锁粒度及数据安全性之间寻求的一种平衡机制
  - 每种存储引擎都可自行实现其锁策略和锁粒度
  - MySQL在服务器级也实现了锁，当今支持表级锁

- 锁类型
  - 显式锁：用户手动请求
  - 隐式锁：存储引擎自行根据需求施加的锁

- 显式锁使用
  - 1. lock tables
    - `lock table tbl_name lock_type,tbl_name lock_type;`
    - `unlock tables`
  - 2. flush tables
    - `flush tables tbl_name[,...] [width read lock][for update]`
  - 3. select
    - `select clause [for update] [with read lock]`

## MySQL事务

- 事务：一组原子性的SQL查询，或者多个SQL语句组成了一个独立的工作单元
- 事务日志：将随机写转化为顺序写
  - `SHOW GLOBAL variables like 'innodb%log%'`
  - `# cd /var/lib/mysql`

  - innodb_log_file_size 5242880 (5MB)
  - innodb_log_files_in_group 2
  - innodb_log_group_home_dir ./ 

## ACID测试

- A:automicity，原子性；整个事务中的所有操作要么全部成功执行，要么全部失败后回滚
- C:consistency，一致性；数据库总是从一个一致性状态转换为另一致性状态
- I:isolation,隔离性，一个事务所做出的操作在提交之前，是不能为其他事务所见；隔离有多重级别，主要是为了并发
- D: durability，持久性，事务一旦提交，其所做的修改会永久保存于数据库中

## 事务流程

- 启动事务：`start transaction`
- 结束事务：
  - 完成，提交：`commit`
  - 未完成，回滚：`rollback`
- 事务支持savepoint
  - `savepoint identifier`
  - `rollback to [savepoint] identifier`
  - `release savepoint identifier`

## 建议：显示请求和提交事务，不要使用自动提交功能

- `show global variables like '%commit%'`
  - autocommit = on
- `set session autocommit = off` 临时有效
- `show variables like '%commit%'`

```
mysql> start transaction;
mysql> select * from tb1;
mysql> insert into tb1 values(4,'Ouyang Feng');
mysql> update tb1 set name='Guo Jing' where id=1;
mysql> rollback

mysql> start transaction;
mysql> insert into tb1 values(4,'Ouyang Feng');
mysql> savepoint first;
mysql> update tb1 set name='Guo Jing' where id=1;
mysql> savepoint second;
mysql> insert into tb1 values(5,'Murong Fu');
mysql> rollback to second;
mysql> select * from tb1;
mysql> rollback to first;
mysql> select * from tb1;
mysql> commit;
```

## 事务的隔离级别

- read uncommitted (读未提交，别还没提交就可以读)
  - 问题：脏读
- read committed (读提交)
  - 问题：不可重复读
- repeatable read (可重复读)
  - 问题：幻读
- seriablizable (可串行化)，默认

### IP1-session1(read-uncommitted)

- `show variables like 'tx_iso%';`
- `set tx_isolation='READ-UNCOMMITTED';`
- `set autocommit=0;`
- `start transaction;`
- `select * from tb1; -- 2 能看到6,hello` 
- `select * from tb1; -- 4 看不到6,hello` 
- `commit`

### IP1-session2(read-uncommitted)

- `show variables like 'tx_iso%';`
- `set tx_isolation='READ-UNCOMMITTED';`
- `set autocommit=0;`
- `start transaction;`
- `insert into tb1 values(6, 'hello'); --1`
- `rollback; ; --3 `

### IP1-session1(read-uommitted)

- `show variables like 'tx_iso%';`
- `set tx_isolation='READ-COMMITTED';`
- `set autocommit=0;`
- `start transaction;`
- `select * from tb1; -- 2 看不到6,hello` 
- `select * from tb1; -- 4 看到6,hello` 
- `commit`

### IP1-session2(read-committed)

- `show variables like 'tx_iso%';`
- `set tx_isolation='READ-COMMITTED';`
- `set autocommit=0;`
- `start transaction;`
- `insert into tb1 values(6, 'hello'); --1`
- `commit; ; --3 `

### IP1-session1(repeatable-read)

- `show variables like 'tx_iso%';`
- `set tx_isolation='repeatable-read';`
- `set autocommit=0;`
- `start transaction;`
- `select * from tb1; -- 2 看到6,hello` 
- `select * from tb1; -- 4 看到6,hello 幻读` 
- `commit`
- `select * from tb1; -- 5 看不到6,hello` 

### IP1-session2(repeatable-read)

- `show variables like 'tx_iso%';`
- `set tx_isolation='repeatable-read';`
- `set autocommit=0;`
- `start transaction;`
- `delete form tb1 where id=6; --1`
- `commit; ; --3 `

### IP1-session1（seriablizable)

- `show variables like 'tx_iso%';`
- `set tx_isolation='seriablizable';`
- `set autocommit=0;`
- `start transaction;`
- `select * from tb1; -- 2 阻塞，看不到6,hello` 
- `select * from tb1; -- 4 看到6,hello 幻读` 
- `commit`
- `select * from tb1; -- 6 看不到6,hello` 

### IP1-session2(seriablizable)

- `show variables like 'tx_iso%';`
- `set tx_isolation='seriablizable';`
- `set autocommit=0;`
- `start transaction;`
- `insert into tb1 values(6, 'hello'); --1`
- `update form tb1 where id=6; --3`
- `commit; ; --5 `

### 设置隔离级别：tx_isolation，默认为第三级别

- READ-UNCOMMITTED
- READ-COMMITTED
- REPEATABLE-READ
- SERIALIZABLE

```
A,B
P1,P2
  P1: A
  P2: B
死锁
```

### 查看innodb存储引擎状态信息

- `show engine innodb status`

## MariaDB 程序的组成：

`/usr/local/mysql/bin`

- C：Client
  - `mysql`：CLI交互式客户端程序
  - `mysqldump`：备份工具
    - `mysqladmin`：管理工具
    - `mysqlbinlog`：二进制日志工具
  ...
- S：Server
  - `mysqld`：服务端程序
  - `mysqld_safe`：建议运行服务端程序（线程安全方式运行mysql）
  - `mysqld_multi`：多实例

## 三类套接字地址：

- IPv4, 3306/tcp
- Unix Sock：/var/lib/mysql/mysql.sock, /tmp/mysql.sock
- C <--> S: localhost, 127.0.0.1

## 命令行交互式客户端程序：mysql

`mysql [OPTIONS] [database]`

- options：
  - -uUSERNAME：用户名，默认为root；
  - -hHOST：远程主机（即mysql服务器）地址，默认为localhost;
  - -p[PASSWORD]：USERNAME所表示的用户的密码； 默认为空；
  - -Ddb_name：连接到服务器端之后，设定其处指明的数据库为默认数据库；
  - -e 'SQL COMMAND;'：连接至服务器并让其执行此命令后直接返回

注意：mysql的用户账号由两部分组成：'USERNAME'@'HOST'; 其中HOST用于限制此用户可通过哪些远程主机连接当前的mysql服务；

- HOST的表示方式，支持使用通配符：
  - _：匹配任意单个字符
  - %：匹配任意长度的任意字符
    - 172.16.%.%,  172.16.0.0/16

## 命令：

- 客户端命令：本地执行

- mysql> help 或 \h
  - \u db_name or use db_name：设定哪个库为默认数据库
  - \q or exit：退出；
  - \d CHAR or delimiter CHAR：设定新的语句结束符；
  - \g：语句结束标记；
  - \G：语句结束标记，结果竖排方式显式；
  - \s：状态信息
  - \c：取消语句

- 服务端命令：通过mysql连接发往服务器执行并取回结果；
  - DDL， DML， DCL

- 注意：每个语句必须有语句结束符，默认为分号(;)

## 数据类型：

- 表：行和列

- 定义字段时，关键的一步即为确定其数据类型；
  - 用于确定：数据存储格式、能参与运算种类、可表示的有效的数据范围；

- 字符型：字符集
  - 码表：在字符和二进制数字之间建立映射关系；

- 种类：
  - 字符型：
    - 定长字符型：max 255
    - CHAR(#)：不区分字符大小写
    - BINARY(#)：区分字符大小写
    - 变长字符型：max 65535,有一个结束符，表示结束字符
    - VARCHAR(#)：不区分字符大小写
    - VARBINARY(#)：区分字符大小写
  - 对象存储：存储的是指针
    - TEXT：max 2^32(40G)，不区分大小写
    - BLOB：tinyblog,smallblob,mediumblob,blob,bigblob区分大小写
  - 内置类型：SET(集合), ENUM(枚举)
  - 数值型：
    - 精确数值型：INT（TINYINT，SMALLINT，MEDIUMINT，INT，BIGINT） 
    - 近似数值型：FLOAT，DOBULE
    - 日期时间型：
      - 日期型：DATE
      - 时间型：TIME
      - 日期时间型：DATETIME
      - 时间戳：TIMESTAMP
      - 年份：YEAR(2), YEAR(4)

- 数据类型有修饰符：
  - UNSIGNED：无符号
  - NOT NULL：非空
  - DEFAULT value：默认值

- 服务器端命令：
  - DDL：主要用于管理数据库组件，例如表、索引、视图、用户、存储过程
    - CREATE、ALTER、DROP
  - DML：主要用管理表中的数据，实现数据的增、删、改、查；
    - INSERT， DELETE， UPDATE， SELECT
  - 获取命令帮助：`mysql> help  KEYWORD`

## 数据库管理：

- 查看：`SHOW DATABASES LIKE ''`;
- 查看支持的所有字符集：`SHOW CHARACTER SET`
- 查看支持的所有排序规则：`SHOW COLLATION`
- 创建数据库：`CREATE  {DATABASE | SCHEMA}  [IF NOT EXISTS]  db_name;`
`[DEFAULT]  CHARACTER SET [=] charset_name`
`[DEFAULT]  COLLATE [=] collation_name`

- 修改：`ALTER {DATABASE | SCHEMA}  [db_name]`
`[DEFAULT]  CHARACTER SET [=] charset_name`
`[DEFAULT]  COLLATE [=] collation_name`
- 删除：`DROP {DATABASE | SCHEMA} [IF EXISTS] db_name`

## TABLE MANAGEMENT：

- 查看表结构：`mysql> desc tbl_name`
- 查看数据库支持的所有存储引擎类型：`mysql> SHOW ENGINES;`
-查看某表的存储引擎类型：`mysql> SHOW TABLES STATUS [LIKE 'tbl_name']`
- 查看表上的索引的信息：`mysql> SHOW INDEXES FROM tbl_name;`
- 删除：`DROP TABLE [IF EXISTS] tbl_name [, tbl_name] ...`
- 表的引用方式：
  - `tbl_name`
  - `db_name.tbl_name`

CREATE：CREATE TABLE [IF NOT EXISTS] tbl_name (create_defination) [table_options]

### create_defination:

- field：col_name  data_type
- key：
  - PRIMARY KEY (col1, col2, ...)
  - UNIQUE KEY  (col1, col2,...)
  - FOREIGN KEY (column)
- index：
  - KEY|INDEX  [index_name]  (col1, col2,...)
- table_options
  - ENGINE [=] engine_name

## 用户账号及权限管理

### 权限类别

- 库级别
- 表级别
- 字段级别
- 管理类（创建其他用户，并且其他用户转赠给其他用户）
- 程序类（存储过程，存储函数）

### 管理类

- create temporary tables 创建临时表 （空间：16M ）
- create user
- file （导出文件，加载文件）
- super
- show databases
- reload (重新装载授权表)
- shutdown (关闭数据库)
- replication slave（复制）
- replication client
- lock tables
- process

## 程序类 - create,alter,drop,excute

- procedure
- function
- trigger

## 库和表级别: database or table

- alter database | table
- create database | table
- drop database | table
- create | drop  index
- create | show view
- grant option 能够把自己获得的权限赠给其他用户一个副本

## 数据操作

- select
- insert
- update
- delete

## 字段级别

- select(col1,col2,...)
- update(col1,col2,...)
- insert(col1,col2,...)

## 所有权限

- all [privileges]

## 元数据数据库：mysql

- 授权表
  - db,host,user
  - columns,priv, tables_priv, proces_priv, proxies_priv

## 用户账号

- `'username'@'host'`
  - `@host`
    - 主机名 （可以反解）
    - IP地址或Network;
    - 通配符：%, _
      - 172.16.%.%
- 创建用户： `create user 'username'@'host' [identified by 'password']`
- 查看用户的授权：`show grants for 'username'@'host'`
- 重命名用户：`rename user old_username to new_username`
- 删除用户：`drop user 'username'@'host'`

- 修改密码：
``` mysql
set password for

update  mysql.user set password=password('you_password') where clause  不会重读授权表，因此执行`mysql> flush privileges`

mysqladmin password
mysqladmin [options] command command ...
- options: -h, -u,-p
  mysqldmin -uroot -p create tdb 创建数据库（不用连接数据库）
  mysqladmin drop tdb 删除数据库
  mysqladmin ping
  mysqladmin --help

mysql> flush status;
# mysql -e 'flush privileges'
```

## 忘记管理员密码

1. 启动mysqld进程时，为其使用： --skip-grant-tables --skip-networking 禁止远程登录  
2. 使用update命令修改管理员密码: `update mysql.user set password=PASSWORD('password') where user='root';`
3. 关闭mysql进程，移除上述两个选项，重启mysqld

- 修改my.cnf配置文件
`# sudo vi /etc/my.cnf`
```
[mysqld]
skip-grant-tables
```

- 重启服务: `# sudo systemctl restart mysqld`

- 登陆并修改密码
`# mysql -uroot`
`# mysql> use mysql`

- 修改密码
- MySQL 5.7.6 以及最新版本：
`# mysql> update user set authentication_string=PASSWORD('newpass') where User='root';`

- MySQL 5.7.5 或更早之前的版本r:
`# mysql> update user set password=PASSWORD('newpass') where User='root';`

- 授权远程访问
1. mysql -u root -p
2. GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'your_root_password' WITH GRANT OPTION;
3. FLUSH PRIVILEGES;

`> create database sina default character set utf8mb4 collate utf8mb4_unicode_ci`

## 授权:grant

`grant priv_type[,...] on [{table|function|procedure}] db.{table|routine} to 'username'@'host' [identified by 'password'] [require ssl] [with with_option]`

- with_option
  - grant options 默认
  - max_queries_per_hour count
  - max_updates_per_hour count
  - max_connections_per_hour count
  - max_user_connections count

- 用户账号：'username'@'host'
  
  - host：此用户访问当前mysql服务器时，允许其通过哪些主机远程可创建连接
    - 表示方式：IP，网络地址、主机名、通配符(%和_)
  - 禁止检查主机名：my.cnf
    - [mysqld]
    - `skip_name_resolve = ON`
  - 创建用户账号：`CREATE USER 'username'@'host' [IDENTIFIED BY 'password'];`
  - 删除用户账号：`DROP USER  'user'@'host' [, user@host] ...`

- 授权：
  - 权限级别：管理权限、数据库、表、字段、存储例程；

`GRANT priv_type,... ON [object_type] db_name.tbl_name TO 'user'@'host' [IDENTIFIED BY 'password'];`

- priv_type
  - ALL [PRIVILEGES]
  - select | update | create ...
- [object_type]
  - TABLE 默认
  - FUNCTION
  - PROCEDURE
- db_name.tbl_name：
  - `*`
  - *.*：所有库的所有表
  - db_name.*：指定库的所有表
  - db_name.tbl_name：指定库的特定表
  - db_name.routine_name：指定库上的存储过程或存储函数

- 查看指定用户所获得的授权：
  - `SHOW GRANTS FOR 'user'@'host'`
  - `SHOW GRANTS FOR CURRENT_USER;`	

- 取消授权：
  - `REVOKE priv_type, ... ON db_name.tbl_name FROM 'user'@'host';`

##　注意：MariaDB服务进程启动时，会读取mysql库的所有授权表至内存中；
1. GRANT或REVOKE命令等执行的权限操作会保存于表中，MariaDB此时一般会自动重读授权表，权限修改会立即生效；
2. 其它方式实现的权限修改，要想生效，必须手动运行`FLUSH PRIVILEGES命令`方可；

- 加固mysql服务器，在安装完成后，运行`mysql_secure_installation`命令；
- 实现安全设定，用户账号空秘密删除等操作

## 图形管理组件：

- Mysql-Front
- ToadForMySQL
- SQLyog
- phpMyAdmin(运行于lamp)
- Navicat

## 查询缓存

- 如何判断是否命中：通过查询语句的哈希值判断；哈希值考虑的因素包括
  - 查询本身、要查询的数据库、客户端使用协议版本,...
  - 查询语句任何字符上的不同，都会导致缓存不能命中

- 哪些查询可能不会被缓存
  - 查询中包含UDF(User Defined Function)、存储函数、用户自定义变量、临时表、mysql库中系统表、或者包含列级权限的表、有着不确定值的函数(Now())

- `show global variables like '%query%'` 查询缓存相关的服务器变量
  - query_cache_min_res_unit 4096 查询缓存中内存块的最小分配单位
    - 较少值会减少浪费，但会导致更频繁的内存分配操作
    - 较大值会带来浪费，会导致碎片过多

  - query_cache_limit 1048576 能够缓存的最大查询结果
    - 对于有着较大结果的查询语句，建议在select中使用sql_no_cache
  - query_cache_size 查询缓存总共可用的内存空间，单位是字节，必须是1024的整数倍
  - query_cache_type on|off|demand 
  - query_cache_wlock_invalidate 如果某表被其他的连接锁定，是否仍然可以从查询缓存中返回结果；默认值off,表示可以在表被其他连接锁定的场景中继续从缓存返回数据；on则表示不允许

- 查询状态变量：`show global status like 'Qcache%'`
  - Qcache_free_blocks 1 空闲内存块
  - Qcache_free_memory  内存空闲空间
  - Qcache_hits
  - Qcache_inserts 	可缓存查询语句的结果被放入缓存中次数
  - Qcache_lowmem_prunes 内存空间太少而使用prunes算法清理缓存
  - Qcache_not_cached   可缓存，当没能被缓存的结果
  - Qcache_queries_in_cache  当前的缓存空间中缓存的被查询的个数
  - Qcache_total_blocks  

- 缓存命中率的评估：**Qcache_hits/(Qcache_hits+Com_select)**

## 索引

- 基本法则：索引应该构建在被用作查询条件的字段上

### 索引类型：

### B+ Tree索引（数据结构）：顺序存储，每一个叶子节点到根节点的距离是相同的

- 根节点->子节点1指针->子节点2指针->数据指针->行数据

- 使用B-Tree索引的查询类型：全键值、键值方位或键前缀查找
  - 全值匹配：精确某个值，例如：姓名 "Jinjiao King"
  - 匹配最左前缀：只精确匹配起头部分，"jin%"
  - 匹配范围值： between 20 and 40
  - 精确匹配某一列并范围匹配另一列: 使用多键索引
  - 只访问索引的查询

- 不适合使用B-Tree索引的场景
  - 如果不从最左列开始，索引无效；(Name,Age)
  - 不能跳过索引中的列（StuID,Name,Age）
  - 如果查询中某个列是为范围查询，那么其右侧的列都无法再使用索引优化查询：（StuID,Name）

### 哈希索引 

- 基于哈希索引实现，特别适用于精确匹配索引中的所有列
- Memory存储引擎支持显示hash索引
- 不适合使用hash索引的场景：
  - 存储的非为值的顺序，因此不使用与顺序查询
  - 不支持模糊匹配
- 适用场景：
  - 只支持等值比较查询：包括=,in(),<=>

### 空间索引(R-Tree)

- MyISAM支持空间索引

### 全文索引(FULLTEXT)

- 在文本中查找关键词

## 索引优点

- 降低服务器需要扫描的数据量，减少了IO次数
- 可以帮助服务器避免排序和使用临时表
- 可以帮助将随机IO转为顺序IO

## 高性能索引策略

- 独立使用列，尽量避免使用在其参与运算
- 左前缀索引，索引构建于字段的左侧的多少个字符，要通过索引选择性来评估
  - 索引选择性，不重复的索引值和数据表的记录总数的比值
- 多列索引：
  - and操作时更适合使用多列索引
- 选择合适的索引列次序；将选择性最高放左侧

## 冗余和重复索引

- 不好的索引使用策略
  - (Name), (Name,Age)

## explain来分析索引的有效性

- explain select clause

获取查询执行计划信息，用来查看查询优化器如何执行查询

- 输出

- id：当前查询语句中，每个select语句的编号
  - 复杂类型的查询三种：
    - 简单子查询
    - 用于from中的子查询
    - 联合查询：union
  - 注意：union查询的分析结果会出现一个额外匿名临时表
- select_type
  - 简单查询为simple
  - 复杂查询：
    - subquery：简单子查询 age>(select avg(age)
    - derived: 用于from中的子查询 from (select) as a where clause
    - union: union语句第一个之后的select语句
    - union result: 匿名临时表
- table: select语句关联到的表
- type: 关联类型，或访问类型，即mysql决定如何去查询表中的行的方式
  - all：全表扫描
  - index: 根据索引的次序进行全表扫描，如何在Extra列出现"Using index"表示了使用覆盖索引，而非全表扫描
  - range:有范围限制的根据索引实现范围扫描；扫描位置始于索引中的某一点，结束于另一点
  - ref：根据索引返回表中匹配某单个值的所有行
  - eq_ref: 仅返回一个行，但与需要额外与某个参考值做比较
  - const, system:　直接返回单个行

- possible_keys：查询可能会用到的索引
- key：查询中使用的索引
- key_len: 在索引使用的字节数
- ref： 在利用key字段所表示的索引完成查询时所有的列或某常量值
- rows: MySQL估计为找所有的目标行而需要读取的行数
- Extra: 额外信息
  - Using index: MySQL将会使用覆盖索引，以避免访问表
  - Using where: MySQL服务器将在存储引擎检索后，在进行一次过滤
  - Using temporary: MySQL对结果排序时会使用临时表
  - Using filesort: 对结果使用一个外部索引排序

## 存储过程

- 多个SQL语句组合一个存储过程，类似函数

### 创建存储过程

```
1. 选择数据库：`use db1;`
2. 改变语句分隔符：`delimiter $$`
3. 创建语句：
create procedure pro_name()
begin
select 'hello';
select 'world';
end
$$

4. 恢复分隔符：`delimter ;`
5. 调用存储过程：`call pro_name;`
```

## 局部变量

- 存储过程定义局部变量：`declare varName datatype default 默认值`
- 显示变量：`select varName`
- 赋值变量：`set varName = 10;`

## 参数

```
create procedure p_test(in p_int int)
begin
select p_int; -- 3
set p_int = p_int + 1;
select p_int; -- 4
end
$$;
delimiter ;
set @p_int=3; 初始值
call p_test(@p_int);
select @p_int; -- 3
```

### in: 输入参数

>in参数的值必须在戴红存储过程之前指定，在存储过程中修改的值不能被返回

### out:输出参数

> out参数值可在存储过程内部改变，并可以返回

1. 用户定义的变量值：@out_int = 12
2. 存储过程调用变量值：不认可之前所赋的值
3. 存储过程改变了变量的值
4. 在存储过程外的变量是存储过程修改的值

### inout: 输入输出参数

> inout参数的值可以在调用时指定，并可修改和返回