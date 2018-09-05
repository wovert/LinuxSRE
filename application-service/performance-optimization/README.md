# Linux优化-RH442

## Introduction
- REEL 6.2 64bit OS
- desktop.exampl.com 192.168.0.x physical student workstation
- server.example.com 192.168.0.x+100 main student virtual machine
- host.example.com 192.168.0.x+200 secondary student virtual machine
- Instructor.example.com 192.168.0.254 physical instruction macine and utility server

## 性能优化
- Black art 黑色艺术
- Both of the hardware and software
- 应用场景
- Tuning goals: Response time or Throughput
- Performance tuning is undertakein to ...
- Perforamnce management is the process of ...

## Disable Unused Services
- service service_name stop
- chkconfig service_name off
- service - -status-all
- yum -y remove bluez

## Monitoring vs Profiling

K = 10^3=1000		2^10=1024
M = 10^6=1,000,000	2^20=1,048,576
G = 10^9 			2^30
T = 10^12 			2^40
P = 10^15 			2^50
E = 10^18 			2^60
df -H 				df -h

`# bc`
scale=8 小数点后位8位
1/6
2*10^12
2*10^12/2^40 真实空间
quit

`# df -h` /1024
`# df -H` /1000

## Unit Conversions
- 100Mib/s equals 	GiB/h
	+ 100/8MiB/s => 100/8/1024GiB/s * 3600 
- 43KiB/sec equals 	MiB/min
- 20GiB/h equals 		MiB/s

## Profiling Tools
- `vmstat`: Virtual Memory Statistics
- `iostat` and `mpstat`(sysstat package)
- `sar`: The System Activity Reporter

- Using `awk` to Format Data
- Plotting data with `gnuplot|RRDtool`

# CPU, Mem, IO, NEt
- `rpm -ql mpstat`
- `rpm -ql vmstat`
- `rpm -ql iostat`
- `rpm -ql mpstat`
- `rpm -ql sar`

## mpstat
mpstat n m
n:时间间隔
m：统计次数 
`# LANG=C mpstat 1 3`
时间以24小时制

HH:MM:SS CPU %usr %nice %sys %iowait %irq %soft %steal %guest

`# LANG=C mpstat -P ALL 1 3`
`# LANG=C mpstat -P 0 1 3` 多核CPU第一个
%usr: 用户态CPU占用百分比
%nice： 优先级程序百分比
%sys: 内核态程序百分比
%iowait: 磁盘IO (数值高, 结合iostat)
%irq: 系统中断（键盘、鼠标、网卡数据包）
%soft: 软件中断（网卡数据包，程序处理）
%steal: 虚拟机有关（CPU用于虚拟机进程）
%guest: 虚拟机有关（当前系统它所运行的虚拟机）
%idle: 空闲百分比

`# cat /proc/cpuinfo`
processor : 几核数，核心, 0单核
module name: 
flags: vmx(支持虚拟化)
`# lscpu`
