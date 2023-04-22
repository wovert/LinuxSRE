echo
"deb https://mirrors.ustc.edu.cn/kali kali-rolling main non-free contrib
deb-src https://mirrors.ustc.edu.cn/kali kali-rolling main non-free " 
> /etc/apt/sources.list

apt-get update

apt-cache search linux headers

默认安装完成的Kali Linux是没有图形界面的，对于需要一些需要在图形界面下配置的安全工具，比如CobalStrike，命令行操作界面的局限性就暴露出来了。

图形界面的安装分为两部分，首先是linux桌面系统，其次是远程桌面连接方案。linux桌面系统很丰富，从轻量的lxde、xfce到重量的Gnome、KDE，各人偏好不同，这里以xfce为例。Linux的远程桌面连接方案同样有很多种选择，从ssh转发x11、xorg的显示管理器到vnc虚拟终端，主要是远程显示协议的差别，考虑到VNC协议的安全性较差，这里采取RDP协议的方案，也建议采取更具有安全性的远程桌面协议。

依次在Kali Linux命令行界面下执行如下命令。

安装Linux桌面：

`sudo apt install xorg xfce4 xfce4-goodies xorg dbus-x11 x11-xserver-utils`
安装RDP服务：

`sudo apt install xrdp`
开启RDP服务：

`sudo service xrdp start`
查看Kali Linux系统的IP：
`sudo ifconfig`
从Windows 10 系统远程桌面连接Kali Linux系统，打开xfce桌面：
`mstsc /v: 192.168.100.218`
//这里假设Kali Linux系统的IP为192.168.100.218//远程桌面对话框中提示的用户名和密码是Kali Linux系统中的用户名和密码
配置中文环境： Kali Linux下默认的图形桌面环境为英文，要变成中文环境需要安装中文字体和中文输入法，并且将默认语言改为中文，步骤如下。
`sudo apt install locales       //安装语言包`
`sudo locale-gen zh_CN.UTF-8    //语言环境变为中文`
`sudo apt install xfonts-wqy fonts-wqy-zenhei   //安装文泉驿中文字库sudo apt install fcitx` `fcitx-table-wbpy       //安装中文输入法和码表`
`sudo vim /etc/profile`
//用上行命令编辑profile开启启动文件，加下如下内容：

`export LC_ALL="zh_CN.UTF-8"export XMODIFIERS=@im=fcitxexport GTK_IM_MODULE=fcitxexport QT_IM_MODULE=fcitx`

OK，上述步骤完成后，重启Kali Linux系统，再次远程桌面连接至Kali Linux系统，Linux桌面就成为中文环境了，开启安全测试吧。


https://wslstorestorage.blob.core.windows.NET/wslblob/wsl_update_x64.msi

安装完毕之后管理员打开 power shell，将 WSL2 设置为默认版本：

wsl --set-default-version 2

然后打开微软商店，搜索 kali，安装 kaliLinux for Windows：

如果你之前使用 WSL1 安装过这个，执行下面的命令设置为 WSL2：

wsl --set-version kali-linux 2

安装完成之后打开 kali，等待附属模块安装完成之后设置用户名和密码

设置好之后就可以进入下一步了

在 kali 中执行：

sudo apt update

sudo apt install -y kali-win-kex

安装过程可能比较慢，与网速和镜像站有关系，耐心等待

安装完成之后就可以使用图形界面了

输入：kex --win -s

由于这是一个子系统，所以很多kali常用的软件都没有安装，如果需要安装较为完整的kali，只需要执行

sudo apt install kali-linux-large

安装Kali Linux工具包

安装标准工具包

sudo apt install kali-linux-default

安装大工具包（大概7 8G）

sudo apt install kali-linux-large

# 启动

cd ~

kex

# 关闭

kex stop

# 窗口模式

kex --win -s



## 浏览器插件-Firefox

- flashgot 下载
- AutoProxy
- Cookie IMporter
- Cookies Manager
- Download Youtube Videos as MP4
- Firebug
- Flagfox 显示网站服务器的国家
- Hackbar  SQL注入工具
- hashr
- Live HTTP header 拦截HTTP header
- Tamper Data
- SQL Inject Me
- User Agent Switcher
- XSS Me

## 安装显卡驱动

- GPU
  - Nvidia
  - ati

- Nvidia 显卡驱动安装
  - apt-get update
  - apt-get dist-upgrade
  - apt-get install -y linux-headers-$(uname -r)
  - apt-get install nvidia-kernel-dkms
  - sed 's/quiet/quiet nouveau.modeset=0/g' -i /etc/default/grub
    update-grub
    reboot

- 验证
  - glxinfo | grep -i "direct rendering"
    - direct rendering: Yes

## 并发线程限制

- ulimit 用户限制 当前 shell 内进程资源使用

- 查看:ulimit -a
- 全局配置文件: /etc/security/limits
  - <domian><type><item><value>
- 用途距离
 - 限制堆栈大小：ulimit -s 100
 - 限制shell内存使用： ulimit -m 5000 -v 5000
- 没有直接对socket 数量的限制参数
  - ulimit -n 800000




  1. 下载最新的JAVA JDK
jdk-8u91-linux-x64

2. 解压缩文件并移动至/opt
tar -xzvf jdk-8u91-linux-x64.tar.gz
mv jdk1.8.0_91 /opt
cd /opt/jdk1.8.0_91
3. 设置环境变量
1）执行 gedit ~/.bashrc ， 并添加下列内容

# install JAVA JDK
export JAVA_HOME=/opt/jdk1.8.0_91
export CLASSPATH=.:${JAVA_HOME}/lib
export PATH=${JAVA_HOME}/bin:$PATH
2）执行 source ~/.bashrc

4. 安装并注册
执行：

update-alternatives --install /usr/bin/java java /opt/jdk1.8.0_91/bin/java 1
update-alternatives --install /usr/bin/javac javac /opt/jdk1.8.0_91/bin/javac 1
update-alternatives --set java /opt/jdk1.8.0_91/bin/java
update-alternatives --set javac /opt/jdk1.8.0_91/bin/javac
查看结果：

update-alternatives --config java
update-alternatives --config javac
5. 测试
java -version
#output 
java version "1.8.0_91"
Java(TM) SE Runtime Environment (build 1.8.0_91-b14)
Java HotSpot(TM) 64-Bit Server VM (build 25.91-b14, mixed mode)