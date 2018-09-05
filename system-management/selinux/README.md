# SELinux

- Secure Enhanced Linux，工作于Linux内核中
- DAC: 自主访问控制
- MAC: 强制访问控制

## SELinux有两种工作级别：

- strict：每个进程都受到selinux的控制
- targeted：仅有限个进程受到selinux控制
  - 只监控容易被入侵的进程

## sandbox

- subject operation object
  - subjecst: 进程
  - object: 进程、文件
    - 文件:open,read,write,close,chown,chmod

  - subject: domain
  - object: type

## SELinux为每个文件提供了安全标签，也为进程提供了安全标签

- user:role:type:
  - user: SELinux的 user
  - role: 角色
  - type: 类型

``` shell
# ls -Z
# ps -efZ
```

## SELinux规则库：

- 规则：哪种域能访问哪种或哪些种类型内文件

## 配置SELinux：

- SELinux是否启用
- 给文件重新打标
- 设定某些布尔型特性

## SELinux的状态：

- enforcing：强制，每个受限的进程都必然受限
- permissive：启用，每个受限的进程选项操作不会被禁止,但会被记录于审计日志
- disabled：关闭

## 相关命令：

- `# getenforce`：获取selinux当前状态
- `# setenforce 0 | 1`
  - 0：设置为permissive
  - 1：设置为enforcing

- 此设定：重启系统后无效

## 配置文件`/etc/sysconfig/selinux, /etc/selinux/config`

- SELINUX={disabled|enforcing|permissive}

## 给文件重新打标

- chcon - change file SELinux secrity context
- chcon [OPTION]... CONTEXT FILE...
- chcon [OPTION]... [-u USER] [-R ROLE] [-T TYPE] FILE...
- chcon [OPTION]... --reference=RFILE FILE...
  - -R：递归打标

- `chcon -t user_tmp_t home.txt`

- 还原文件的默认标签：`# restorecon [-R] /path/to/somewhere`

- 布尔型规则：
  - setsebool
  - getsebool

## getsebool命令：

`# getsebool [-a] [boolean]`

## setsebool命令：

`setsebool [-P] boolean value`

-P 保存在策略库当中，永久有效

`# getsebool ftp_home_dir 1|on`

日志文件：`# tail /var/log/aduit/audit.log`