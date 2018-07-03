# redis

## Overviw of Redis

> Redis is an open source. BSD licensed, advanced key-value cache and tore. It is ofternreferred to as a data structure server since keys can contain string, hashes, lits, sets, sorted sets, bitmaps and hyperloglogs.

- The word Redis means REmote DIctionary Server
- Initial release in 2009
- It is an advanced key-value store or a data structure store
- Runs entirely in memory
  - All data is kept in memory
  - Quick dta access since it is maintained in memory
  - Data can be backed up to disk periodically
  - Single threaded server
- Extensible via Lua Scripts
- Able to replicate data between servers
- Clustering also available(v3.0+)

## Redis features

- KV cache and store
  - Redis is an in-memory but persisten on disk datase
    - 1 Million small Key -> String value pairs use ~ 100 MB of memory
    - Single threaded - but CPU should not be the bottleneck
      - Average Linux system can deliver even 500k(50万并发) requests per second
    - Limit is likely the available memory in your system
      - max 323 keys
  - Persistence,持久化
    - Snapshotting
      - Data is asynchronously transferred from memory to disk
    - AOF(Append Only File)
      - Each modifying operation is written to a file
      - Can recreae data store by replaying operations
      - Without interrupting service, will rebuild AOF as the shortest sequence of commands needed to rebuild the current dataset in memory.
  - replication 主从(借助于sentinel实现一定意义上的 HA)
    - Redis supports master-slave replication
    - Master-slave replication can be chained
    - Be carefull
      - Slaved are writeable
      - Potential for data inconsistency
    - Fully compatible with Pub/Sub features
  - clustering(分布式)

- Data Structure Server
  - String
  - List
  - Hash(关联数组)
  - Set
  - Sorted Set
  - Bitmaps
  - Hyperloglogs

## Redis VS Memcache

- Memcached is a "distributed memory object caching system"
- Redis persis data to disk eventually
- Memcached in a LRU cache
- Redis has difference data types and more features
- Memcached is multithreaded
- Similar speed

### Redis 优势

- 丰富的（资料形态）操作
  - Hashes, Lists, Sets, Sorted Sets, HyperLogLog 等
- 内建 replication 及 cluster
- 就地更新(in-place update)操作
- 支持持久化（磁盘）
  - 避免雪崩效应

### Memcache 优势

- 多线程
  - 善用多核 CPU
  - 更少的阻塞操作
- 更少的内存开销
- 更少的内存分配压力
- 可能有更少的内存碎片

## Prominent Adopters

- Twitter
- Pinterest
- Tumblr
- Github
- Stack Overflow
- digg
- Blizard
- flickr
- Weibo

## Redis 3.0

- 2015-4-1 release
- Redis Cluster
- 新的 “embedded string”
- LRU 演算法的改进
  - 预设随机取5个样本，插入并排序至一个 pool, 移除最佳者，如此反复，知道内存用最小于 maxmemory 的设定
  - 样本 5 比先前 3 多
  - 从局部优化趋向全局最优

## Redis 特性

### 存储系统

- RDBMS：Oracle, DB2, MySQL, SQL Server
- NoSQL: HBase, Memcached, MongoDB, Redis
- NewSQL(分布式): Aerospike, FoundationDB, RethinkDB

### NoSQL

- key-value NoSQL
  - Memcached, Redis
- Column family NoSQL
  - Cassandra, HBase
- Documatation NoSQL
  - MongoDB
- Graph NoSQL
  - Neo4j

## Redis 组件

- 早期只有10k行代码（作者：意大利人）
- [redis.io](http://redis.io)

- redis-server
- redis-clie
  - command line interface

- redis-benchmark 性能压力测试工具
  - benchmark utility

- redis-check-dump & redis-check-aof
  - corrupted RDB/AOF files utilities

``` shell

epel 源
# yum info redis

www.redis.io

pkgs.org

redis-3.0.0.2-1.el6....

# rpm -i redis-3...
# rpm -ql redis

# cp /etc/redis.conf{,bak}
# vim /etc/redis.conf
  daemonize no 守护进程
  pidfile /var/run/redis.pid
  port 6379 监听端口
  tcp-backlog 511 等待队列
  bind 127.0.0.1 [172.16.100.6]
  unixsocketperm 700 本地socket
  timeout 0 客户端连接不超时
  tcp-keepalive 0
  loglevel notice
  logfile /var/log/redis/redis.log
  databases 16 支持16个数据库，集群仅支持 0 号数据库

  save 900 1 : 900秒1个记录变化一次快照
  save 300 10 : 300秒内10个记录发生变化一次快照
  save 60 10000 : 60秒内10000个记录发生变化一次快照

  maxmemory 最大使用内存


# service redis start
# ss -tnl | grep 6379

# redis-cli -h
# redis-cli -h 172.16.100.6

# redis-cli

> help

> help @STRING
> help APPEND
> help @transaction
> help @server

> CLIENT LIST
```

## Keys

- Arbitrary ASCII strings
  - Define some format convention and adhere to it
  - Key length matters
- Multiple name spaces are available
  - Separate DBs indexed by an integer value
    - select command
    - multiples DBs vs. Single DB + key prefixes
- Keys can expire automatically

``` redis
名称空间或数据库会解决内存使用量
> select 0
> select 2


```

## Strings

``` REDIS
> help set
> SET disto fedora
> GET disto
"fedora"
> SET disto centos
> GET disto
"centos"
> append disto slackware
(integer) 15
> GET disto
"centosslackware"

> help @string

> STRLEN disto
(integer) 15

> SET count 0
OK

> INCR count
(integer) 1

> INCR count
(integer) 2

> INCR count
(integer) 3

> DECR count
(integer) 2

> DECR count
(integer) 1

> DECR count
(integer) 0

> DECR count
(integer) -1

自动过期
> HELP SET
key seconds value

如果键不存在，则可以设置键
> SET disto gentoo NX
(nil)

> GET disto
"centosslackware"

如果键存在，则可以设置键
> SET foo bar XX
(nil)

键是否存在
> EXISTS foo
```

## List

['A','B','C']

``` REDIS
> help @list
> rpush 向右添加
> lpush 向前添加
> lpop 左边弹出元素
> rpop 右边弹出元素

> LPUSH L0  mon
(integer) 1
> LINDEX L0 0
"mon"
> LPUSH L0 sun
(integer) 2
> LINDEX L0 0
"sun"
> LINDEX L0 1
"mon"
> RPUSH L0 tue
(integer) 3
> LINDEX L0 2
"tue"
> LSET L0 1 fri
> LINDEX L0 1
> RPOP L0
> RPOP L1


```

## Set

> 无序数据结构

(A,B,C,D)

``` REDIS
> HELP @SET
> SADD w1 mon tue ved thu fri sat sun
(integer) 7
> SADD w2 tue thu day
(integer) 3 

> SINTER w1 w2 交集
1) "thu"
2) "tue"

> SUNION w1 w2 并集
1) "thu"
2) "tue"
3) "sat"
4) "mon"
5) "thu"
6) "wed"
7) "sun"
8) "day"

> SPOP w1 随机弹出
"fre"

> SISMEMBER w1 fri 是否存在元素

```

## Sorted Set

> 有序集合

{C:1, D:2, A:3, B:4}

``` REDIS
> HELP @SORTED_SET

key score memer : score 排序分数

> ZADD weekday1 1 mon 2 tue 3 wed
> ZCARD weekday1
(integer) 3
> ZRANK weekday1 tue 索引号
> ZRANK weekday1 tue 索引号

> ZSCORE weekday2 tue 根据 score 获取索引
"2"

> ZRANGE weekday1 0 2 起始索引和结束索引 
```

## Hash

{key:value}

{field1: "A", field2:"B"}

``` REDIS
> HELP @HASH

> HSET h0 a mon
(integer) 1
> HGET h0 a
> HSET h0 b tue
(integer) 1
> HGET h0 a
"mon"
> HGET h0 b
"tue"

> HKEYS h0 所有键名
1) "a"
2) "b"

> HVALS h0 所有名

> HLEN h0
(integer) 2

```