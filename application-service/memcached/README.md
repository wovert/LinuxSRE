# memcached介绍
- 数据结构模型：
	+ 结构化数据：关系型数据库
	+ 半结构化数据：xml,json，NoSQL(Redis,Hbase,MongoDB)
	+ 非结构化数据：文件系统

- K/V
	+ memcached: 存储于内存中
	+ redis: 存储于内存中，周期性地将数据同于辅存上

## memcached:
>Livejournal旗下的Danga Interactive
[livejournal](https://www.livejournal.com/)
[danga](http://danga.com/)
[memcached](http://memecached.org)

Free & open source, high-performance, distributed object caching system
有livejournal旗下的danga公司开发

## 特性
- k/v缓存：可序列化数据；（打散，流式化数据）存储箱：key,value,flag,expire time
- 功能的实现一半依赖于服务端，一半依赖客户端
- 分布式缓存：互不通信的分布式集群
- O(1)的执行效率
- 清理过期数据
	+ 缓存项过期
	+ 缓存空间用尽

## 缓存系统的种类
- 代理式缓存
- 旁路式缓存

## 分布式系统主机路由
- 取模法
- 一致性hash

# 安装
`# yum info memcached`
`# yum -y install memcached`
`# rpm -ql memcahed`

- 11211/tcp,11211/udp
- 主程序：memecached
- 环境配置文件：/etc/sysconfig/memcached
	+ PORT="11211"
	+ USER="memcached"
	+ MAXCONN="1024"
	+ CACHESIZE="64"
	+ OPTIONS=""
`# systemcl start memcahced.servie`

## 协议格式
- 文本协议
- 二进制协议

## memcached客户端程序
- telnet
`# telnet 172.16.100.6 11211`
- 命令: 
	+ 统计类：stats,stat items,stats slabs,stats sizes
	+ 存储类：set, add, replace, append, prepend
	+ 获取数据：get keyname, delete keyname, incr/decr (加+)
	+ 清空：flush_all

add key flag expires length
`set mykey 0  60 5` mykey键名 flag 缓存有效时间(秒) 5个字节 
`stats items`
`get mykey`
`stats` 统计数据
`append mykey 0 300 16` 新增16字节
`get mykey`
`prepend mykey 0 300 16` 新增16字节
`get mykey`

`incr mykey 1`

## memcached程序的常用选项：
- -l <ip_addr>：监听的地址
- -u <username>
- -m <num>：缓存空间大小，单位为MB; 默认为64MB
- -c <num>：最大并发连接数，默认为1024
- -p <num>：TCP port, 11211
- -U <num>：UDP Port, 11211， -U 0关掉
- -M：缓存空间耗尽时，向请求者返回错误信息，而不是基于LRU算法进行缓存清理
- -f <factor>：growth factor，增长因子
	+ `# memcached -u memcached -f 1.1 -vv`
- t <thread>：处理用于请求的线程数
- B <proto>：ascii or binary

- memcached默认没有认证机制，但可借助于SASL进行认证

## slab： 内存分配器
`stats slab`

## PHP连接memecached服务的模块
- memcache：php-perl-memcache 扩展
- memcached：php-perl-memcached 

## 可提供工具程序的程序包
`# yum -y install libmemcached`
`# memstat --help`
`# systemctl start memcached`
`# memstat --servers=127.0.0.1`

##　LB Cluster保持会话地方法：
- session stick
- session cluster
- session server

《LVS Web PHP session memcached.txt》

- 博客作业：nginx调度负载均衡用户请求至后端多个ammp主机，PHP的会话保存于memcached中




















