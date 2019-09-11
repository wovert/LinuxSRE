# shell脚本监控 CPU和内存负载

## 安装linux下面的一个邮件客户端msmtp软件(类似于一个foxmail的工具)

### 1、下载安装：
http://downloads.sourceforge.net/msmtp/msmtp-1.4.16.tar.bz2?modtime=1217206451&big_mirror=0
代码如下:
```
# tar jxvf msmtp-1.4.16.tar.bz2
# cd msmtp-1.4.16
# ./configure --prefix=/usr/local/msmtp
# make && make install
```
### 2、创建msmtp配置文件和日志文件（host为邮件域名，邮件用户名fuquanjun，密码fuquanjun）

```
# vim /root/.msmtprc
account default 
host xxxxx.com 
from fuquanjun@xxxx.com 
auth login 
user fuquanjun 
password fuquanjun 
logfile ~/.msmtp.log
# chmod 600 /root/.msmtprc
# touch ~/.msmtp.log
```
### mutt安装配置：（一般linux下有默认安装mutt）

如果没有安装，则使用yum安装

```sh
yum -y install mutt
# vim /root/.muttrc
set sendmail="/usr/local/msmtp/bin/msmtp" 
set use_from=yes 
set realname="moniter" 
set from=fuquanjun@xxx.com 
set envelope_from=yes 
set rfc2047_parameters=yes 
set charset="utf-8"
```
### 邮件发送测试（-s邮件标题，-a表加附件）

`# echo "邮件内容123456" | mutt -s "邮件标题测试邮件" -a /scripts/test.txt fuquanjun@xxxx.com`

出现下面报错信息：
代码如下:

`msmtp: account default not found: no configuration file available`

发送信件出错，子进程已退出 78 ()。

无法发送此信件。

解决方法：

单独使用msmtp发送测试：/usr/local/msmtp/bin/msmtp -S 发现是配置文件没找到

`msmtp: account default not found: no configuration file available`

查看当前的配置文件路径：/usr/local/msmtp/bin/msmtp -P
代码如下:
```
ignoring system configuration file/work/target/etc/msmtprc: No such file or directory
ignoring user configuration file /root/.msmtprc: No such file ordirectory
falling back to default account
msmtp: account default not found: no configuration file available
```

故将/usr/local/etc/msmtprc 复制为/root/.msmtprc
查看一下mutt文件安装目录情况
代码如下:

`rpm -ql mutt`

## 监控服务器系统负载情况

### 用`uptime`命令查看当前负载情况（1分钟，5分钟，15分钟平均负载情况）在苹果公司的Mac电脑上也适用
代码如下:

`# uptime`

15:43:59 up 186 days, 20:04, 1 user, load average: 0.01, 0.02, 0.00

"load average"意思分别是1分钟、5分钟、15分钟内系统的平均负荷。

1. 主要观察"15分钟系统负荷"，将它作为电脑正常运行的指标。
2. 如果15分钟内，（系统负荷除以CPU核心数目之后的）平均负荷大于1.0，表明问题持续存在，不是暂时现象。
3. 当系统负荷持续大于0.7，你必须开始调查了，问题出在哪里，防止情况恶化。
4. 当系统负荷持续大于1.0，你必须动手寻找解决办法，把这个值降下来。
5. 当系统负荷达到5.0，就表明你的系统有很严重的问题，长时间没有响应，或者接近死机了。

假设你的电脑只有1个CPU。如果你的电脑装了2个CPU,意味着电脑的处理能力翻了一倍，能够同时处理的进程数量也翻了一倍。

2个CPU表明系统负荷可以达到2.0，此时每个CPU都达到100%的工作量。推广开来，n个CPU的电脑，可接受的系统负荷最大为n.0。

### 查看服务器cpu的总核数

`# grep -c 'model name' /proc/cpuinfo 或者 cat /proc/cpuinfo`


### 截取服务器1分钟、5分钟、15分钟的负载情况

`uptime | awk '{print $8,$9,$10,$11,$12}'`

load average: 0.01, 0.02, 0.00

### 查看截取15分钟的平均负载

```sh
# uptime | awk '{print $12}' （用 '{print $12}' 这个获取的不够准确，如果都用awk取第12个字段的话，结果有可能为空了。而用$NF表输出最后一段的内容）
# uptime | awk '{print $NF}'
```
### 编写系统负载监控的脚本文件

```sh
# vim /scripts/load-check.sh
#!/bin/bash 
#使用uptime命令监控linux系统负载变化 

#取系统当前时间（以追加的方式写入文件>>） 
date >> /scripts/datetime-load.txt 

#提取服务器1分钟、5分钟、15分钟的负载情况 
uptime | awk '{print $8,$9,$10,$11,$12}' >> /scripts/load.txt 

#逐行连接上面的时间和负载相关行数据（每次重新写入文件>） 
paste /scripts/datetime-load.txt /scripts/load.txt > /scripts/load_day.txt

# chmod a+x /scripts/load-check.sh
```

### 编写系统负载结果文件邮件发送脚本

```sh
# vim /scripts/sendmail-load.sh
#!/bin/bash 
#把系统负载监控生成的load_day.txt文件通过邮件发送给用户 

#提取本服务器的IP地址信息 
IP=`ifconfig eth0 | grep "inet addr" | cut -f 2 -d ":" | cut -f 1 -d " "` 

#提取当前日期 
today=`date -d "0 day" +%Y年%m月%d日` 

#发送系统负载监控结果邮件 
echo "这是$IP服务器$today的系统负载监控报告，请下载附件。" | mutt -s "$IP服务器$today的系统负载监控报告" -a /scripts/load_day.txt fuquanjun@xxx.com
# chmod a+x /scripts/sendmail-load.sh
```

### 编写系统负载监控的脚本文件

```sh
# vim /scripts/load-warning.sh
#!/bin/bash 
#使用uptime命令监控linux系统负载变化 

#提取本服务器的IP地址信息 
IP=`ifconfig eth0 | grep "inet addr" | cut -f 2 -d ":" | cut -f 1 -d " "` 

#抓取cpu的总核数 
cpu_num=`grep -c 'model name' /proc/cpuinfo` 

#抓取当前系统15分钟的平均负载值 
load_15=`uptime | awk '{print $NF}'` 

#计算当前系统单个核心15分钟的平均负载值，结果小于1.0时前面个位数补0。 
average_load=`echo "scale=2;a=$load_15/$cpu_num;if(length(a)==scale(a)) print 0;print a" | bc` 

#取上面平均负载值的个位整数 
average_int=`echo $average_load | cut -f 1 -d "."` 

#设置系统单个核心15分钟的平均负载的告警值为0.70(即使用超过70%的时候告警)。 
load_warn=0.70 

#当单个核心15分钟的平均负载值大于等于1.0（即个位整数大于0） ，直接发邮件告警；如果小于1.0则进行二次比较 
if (($average_int > 0)); then 
　　echo "$IP服务器15分钟的系统平均负载为$average_load，超过警戒值1.0，请立即处理！！！" | mutt -s "$IP 服务器系统负载严重告警！！！" fuquanjun@xxx.com 
　　else 
#当前系统15分钟平均负载值与告警值进行比较（当大于告警值0.70时会返回1，小于时会返回0 ） 
load_now=`expr $average_load \> $load_warn` 

#如果系统单个核心15分钟的平均负载值大于告警值0.70（返回值为1），则发邮件给管理员 
　　if (($load_now == 1)); then 
　　　　echo "$IP服务器15分钟的系统平均负载达到 $average_load，超过警戒值0.70，请及时处理。" | mutt -s "$IP 服务器系统负载告警" fuquanjun@xxx.com
　　fi 
fi
# chmod a+x /scripts/load-warning.sh
```

## 监控服务器系统cpu占用情况

### 使用top命令查看linux系统cpu使用情况

```sh
# top -b -n 1 | grep Cpu （-b -n 1 表只需要1次的输出结果）
Cpu(s): 0.0%us, 0.0%sy, 0.0%ni, 99.9%id, 0.0%wa, 0.0%hi, 0.0%si, 0.0%st
```

### 查看截取空闲cpu的百分比数值命令（只取整数部分）

`# top -b -n 1 | grep Cpu | awk '{print $5}' | cut -f 1 -d "."`

### 编写cpu监控的脚本文件

```
# vim /scripts/cpu-check.sh
#!/bin/bash 
#使用top命令监控linux系统cpu变化 

#取系统当前时间（以追加的方式写入文件>>） 
date >> /scripts/datetime-cpu.txt 

#抓取当前cpu的值（以追加的方式写入文件>>） 
top -b -n 1 | grep Cpu >> /scripts/cpu-now.txt 

#逐行连接上面的时间和cpu相关行数据（每次重新写入文件>） 
paste /scripts/datetime-cpu.txt /scripts/cpu-now.txt > /scripts/cpu.txt
# chmod a+x /scripts/cpu-check.sh
```

### 查看CPU监控的结果文件

`# cat /scripts/cpu.txt`

### 编写cpu结果文件邮件发送脚

```sh
# vim /scripts/sendmail-cpu.sh
#!/bin/bash 
#把生成的cpu.txt文件通过邮件发送给用户 

#提取本服务器的IP地址信息 
IP=`ifconfig eth0 | grep "inet addr" | cut -f 2 -d ":" | cut -f 1 -d " "` 

#提取当前日期 
today=`date -d "0 day" +%Y年%m月%d日` 

#发送cpu监控结果邮件 
echo "这是$IP服务器$today的cpu监控报告，请下载附件。" | mutt -s "$IP服务器$today的CPU监控报告" -a /scripts/cpu.txt fuquanjun@xxx.com
```

## 监控系统cpu的情况，当使用超过80%的时候发告警邮件

```sh
# vim /scripts/cpu-warning.sh
#!/bin/bash 
#监控系统cpu的情况脚本程序 

#提取本服务器的IP地址信息 
IP=`ifconfig eth0 | grep "inet addr" | cut -f 2 -d ":" | cut -f 1 -d " "` 

#取当前空闲cpu百份比值（只取整数部分） 
cpu_idle=`top -b -n 1 | grep Cpu | awk '{print $5}' | cut -f 1 -d "."` 

#设置空闲cpu的告警值为20%，如果当前cpu使用超过80%（即剩余小于20%），立即发邮件告警 
if (($cpu_idle < 20)); then 
　　echo "$IP服务器cpu剩余$cpu_idle%，使用率已经超过80%，请及时处理。" | mutt -s "$IP 服务器CPU告警" fuquanjun@xxx.com 
fi
# chmod a+x /scripts/cpu-warning.sh
```

## 使用free命令监控系统内存

### 使用free命令查看linux系统内存使用情况：（以M为单位）

```sh
# free -m 
total used free shared buffers cached
Mem: 3952 3414 538 0 168 484
-/+ buffers/cache: 2760 1191
Swap: 8191 86 8105
```

### 查看截取剩余内存free的数值命令：

1. 物理内存free值： # free -m | grep Mem | awk '{print $4}'
2. 缓冲区的free值： # free -m | grep - | awk '{print $4}'
3. Swap分区free值： # free -m | grep Swap | awk '{print $4}'

### 编写内存监控的脚本文件

```sh
# vim /scripts/free-mem.sh
#!/bin/bash 
#使用free命令监控linux系统内存变化 

#取系统当前时间（以追加的方式写入文件>>） 
date >> /scripts/date-time.txt 

#抓取物理内存free值（以追加的方式写入文件>>） 
echo Mem-free: `free -m | grep Mem | awk '{print $4}'`M >> /scripts/mem-free.txt 

#抓取缓冲区的free值（以追加的方式写入文件>>） 
echo buffers/cache-free: `free -m | grep - | awk '{print $4}'`M >> /scripts/buffers-free.txt 

#抓取Swap分区free值（以追加的方式写入文件>>） 
echo Swap-free: `free -m | grep Swap | awk '{print $4}'`M >> /scripts/swap-free.txt 

#逐行连接上面的时间和内存相关行数据（每次重新写入文件>） 
paste /scripts/date-time.txt /scripts/mem-free.txt /scripts/buffers-free.txt /scripts/swap-free.txt >

/scripts/freemem.txt
# chmod a+x /scripts/free-mem.sh
```

### 查看内存监控的结果文件

`# cat /scripts/freemem.txt`

### 编写free结果文件邮件发送脚本

```
# vim /scripts/sendmail-mem.sh
#!/bin/bash 
#把生成的freemem.txt文件通过邮件发送给用户 

#提取本服务器的IP地址信息 
IP=`ifconfig eth0 | grep "inet addr" | cut -f 2 -d ":" | cut -f 1 -d " "` 

#提取当前日期时间 
today=`date -d "0 day" +%Y年%m月%d日` 

#发送内存监控结果邮件 
echo "这是$IP服务器$today的内存监控报告，请下载附件。" | mutt -s "$IP服务器$today内存监控报告" -a /scripts/freemem.txt

fuquanjun@xxx.com
# chmod a+x /scripts/sendmail-mem.sh
```

### 监控系统交换分区swap的情况，当使用超过80%的时候发告警邮件

```
# vim /scripts/swap-warning.sh
#!/bin/bash 

#提取本服务器的IP地址信息 
IP=`ifconfig eth0 | grep "inet addr" | cut -f 2 -d ":" | cut -f 1 -d " "` 

#系统分配的交换分区总量 
swap_total=`free -m | grep Swap | awk '{print $2}'` 

#当前剩余的交换分区free大小 
swap_free=`free -m | grep Swap | awk '{print $4}'` 

#当前已使用的交换分区used大小 
swap_used=`free -m | grep Swap | awk '{print $3}'` 


if (($swap_used != 0)); then 

#如果交换分区已被使用，则计算当前剩余交换分区free所占总量的百分比，用小数来表示，要在小数点前面补一个整数位0 
swap_per=0`echo "scale=2;$swap_free/$swap_total" | bc` 

#设置交换分区的告警值为20%(即使用超过80%的时候告警)。 
swap_warn=0.20 

#当前剩余交换分区百分比与告警值进行比较（当大于告警值(即剩余20%以上)时会返回1，小于(即剩余不足20%)时会返回0 ） 
swap_now=`expr $swap_per \> $swap_warn` 

#如果当前交换分区使用超过80%（即剩余小于20%，上面的返回值等于0），立即发邮件告警 
if (($swap_now == 0)); then 
echo "$IP服务器swap交换分区只剩下 $swap_free M 未使用，剩余不足20%，使用率已经超过80%，请及时处理。" | mutt -s "$IP 服务器内存告警" fuquanjun@xxx.com 
fi 
fi
# chmod a+x /scripts/swap-warning.sh
```

### 加入任务计划：系统负载与CPU占用率每十分钟检测一次，有告警则立即发邮件(十分钟发一次)，负载与CPU检测结果邮件每天早上8点发

```
# crontab -e
*/10 * * * * /scripts/load-check.sh > /dev/null 2>&1
*/10 * * * * /scripts/load-warning.sh 
0 8 * * * /scripts/sendmail-load.sh 

*/10 * * * * /scripts/cpu-check.sh 
*/10 * * * * /scripts/cpu-warning.sh 
0 8 * * * /scripts/sendmail-cpu.sh

*/10 * * * * /scripts/free-mem.sh 
*/10 * * * * /scripts/swap-warning.sh 
0 8 * * * /scripts/sendmail-mem.sh
# service crond restart
```
