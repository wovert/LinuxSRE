# Zabbix

> 监控系统

- 监控系统：硬件、软件、业务指标；采用告警；

## What to monitor?

- Devices / Software
  - Server, Router, Switches, I/O System etc.
  - Operating System, Networks, Applications, etc.

- Incidents(意外状况)
  - DB down, Replication stpoped, Server not reachable, etc.

- Critical Events(关键事件)
  - Disk more than n% full or less than m Gbyte free, Replication more than n seconds lagging, Data node down.(磁盘利用率，主从复制从服务器延迟)

- 100% CPU utilization, etc
  - Alert, mmediate intervention, fire fighting

- Trends (includes time)
  - Nginx 结束请求的时间，图形方式获取

- How long des it take until
  - my disk is full?
  - my Index Memory is fiiled up?

- When does is happen
  - Peak? Backup?

- How often does it happen? Does it happen periodically?
  - once a day? Always at sunday night?

- How does it correlate to other infromatioins?
  - I/O problems during 

NMS(Client) ---------协议---------> agent(Server)