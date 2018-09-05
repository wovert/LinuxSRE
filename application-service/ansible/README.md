# 运维: Operations

## 1.系统安装
- bare metal(裸机上安装): pxe(网卡，raw设备，预引导)
	+ cobbler(封装pxe)
- virtual machine(虚拟机上安装): 安装模版

## 2. Configuration(应用程序安装、配置)
- 问题：多个服务器安装应用程序，100台服务器
- 解决工具： 
	+ puppet(ruby)，重量级
	+ saltstack(python)
	+ chef
	+ cfengine

## 3. Command and Control（创建目录）
- fabric(Python，轻量级)
- func

## 4. 程序发布
- 手动发布（人工智能）
- 脚本
- 发布程序（运维程序）

- 要求：
1. 不能影响用户体验
2. 系统不能停机
3. 不能导致系统故障或造成系统完全不可用

- 灰度模型
	1. 主机
	2. 用户

	发布路径：
		/webapp/tuangou
		/webapp/tuangou-1.1
		/webapp/tuangou-1.2

	在调度器上下线一批主机（标记为维护模式）-> 关闭服务 -> 部署新版本 -> 启动服务 -> 在调度器上启用这一批主机

## 运维工具分类
- agent: puppet, func,...
- agentless(ssh): ansible, fabric

# ansible
> Configuration, Command and Control 功能的轻量级运维工具

## 特性
- 模块化：调用特定的模块，完成特定任务
- 基于Python语言实现，由Paramiko，PyYAML和JinJa2三个关键模块
- 部署简单：agentless
- 支持自定义模块
- 支持playbook
- 幂等性


## 示例
- 管理端：CentOS 7(1个)
- 控制端：CentOS 7(2个), CentOS 6(1个), Ubuntu 14(1个)
- 命令（条件判断）


### 172.16.100.6(管理端)
- 安装epel, ansible
`# yum -y install ansible`
`# rpm -qi ansible`
`# rpm -ql ansible`

- 配置文件：/etc/ansible/ansible.cfg
- 主机清单：/etc/ansible/hosts
- 角色：/etc/ansible/roles
- 主程序：
	/usr/bin/ansible
	/usr/bin/ansible-playbook
	/usr/bin/ansible-pull
	/usr/bin/ansible-doc

- ansible使用格式
`# ansible HOST-PATTERN -m mod_name -A MOD_ARGS`

- 配置主机
`# cd /etc/ansible`
`# cp hosts{,.bak}`
`# vim hosts`
	[webserver]	
	172.18.100.10
	172.18.100.11

	[dbserver]	
	172.18.100.11
	172.18.100.12

- 基于密钥认证
`# ssh-keygen -t rsa -P ''`
`# ssh-copy-id -i .ssh/id_rsa.pub root@172.18.100.10`
`# ssh-copy-id -i .ssh/id_rsa.pub root@172.18.100.11`
`# ssh-copy-id -i .ssh/id_rsa.pub root@172.18.100.12`

`# ansible-doc -l`
`# ansible -h`

`# ansible all -m ping` -m 指明模块
返回pong成功

### 172.18.100.10
### 172.18.100.11
### 172.18.100.12

















