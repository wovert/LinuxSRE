# 阿里云ECS裸机配置

## 账号配置

1. 修改root密码：云服务器ECS->实例->实例列表->实例->更多->密码/秘钥->重置实例密码->**重启实例**
2. 使用ssh协议root账号登录并创建普通登录账号和密码

```sh
登录
# ssh root@IP地址
创建普通登录用户
# useradd username
修改普通登录用户密码
# passwd username
```

3. 禁止root账号远程登录

```sh
# vim /etc/ssh/sshd_config
  PermitRootLogin no
# systemctl restart sshd
```

## Setup系统开发工具

```sh
# yum -y groupinstall "Development Tools" "Server Platform Development"
查看系统版本
# lsb_release -a

安装 git 源码构建
# git --versrion

安装编译依赖软件
# yum -y install curl-devel expat-devel gettext-devel openssl-devel zlib-devel asciidoc
# yum -y install gcc perl-ExtUtils-MakeMaker

卸载老版本
# yum remove git

下载最新版本
# cd /usr/local/src/
# wget https://www.kernel.org/pub/software/scm/git/git-2.22.0.tar.xz
# tar -vxf git-2.22.0.tar.xz
# cd git-2.22.0

编译
编译时发生错误，可能未安装依赖软件包
# make prefix=/usr/local/git all
# make prefix=/usr/local/git install

环境变量设置

[Root 用户添加环境变量]
# echo "export PATH=$PATH:/usr/local/git/bin" >> /etc/profile

生效环境变量
# source /etc/profile

或者
# vim /etc/profile.d/git.sh
  export PATH=$PATH:/usr/local/git/bin

生效环境变量
# source /etc/profile.d/git.sh

[其他用户:登录该用户, 配置该用户下的环境变量]

# su - username
$ echo "export PATH=$PATH:/usr/local/git/bin" >> ~/.bashrc
$ source ~/.bashrc

验证
# git --version
```

## Node开发工具

[Install NVM](https://github.com/nvm-sh/nvm)

```sh
# curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash
```