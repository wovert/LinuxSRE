# VSCode-XDebug

开发环境是这样：一台位于内网环境下的Windows机器使用VSCode作为IDE编写PHP脚本项目，一台位于公网的linux服务器运行lighttpd、fastcgi PHP用于部署调试。开发机所在网络环境不允许或不方便进行端口映射来打开XDebug所需的本地调试监听端口（默认9000），同时也不想安装本机PHP服务器来调试，于是采用本机编写PHP，然后上传linux服务器直接远程调试，记录环境搭建过程如下：
首先配置好开发机的IDE环境，我用的是VSCode 1.6.1，然后安装PHP Debug扩展，完成后选择一个指定文件夹作为项目根目录并在调试页中新建PHP调试配置，这时会在项目文件夹中生成.vscode/launch.json配置文件，按照PHP Debug的说明，加入serverSourceRoot与localSourceRoot，参考如下：

{
  // 使用 IntelliSense 了解相关属性。
  // 悬停以查看现有属性的描述。
  // 欲了解更多信息，请访问: https://go.microsoft.com/fwlink/?linkid=830387
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Listen for XDebug",
      "type": "php",
      "request": "launch",
      "log": true,
      "pathMappings": {
        "/home/chengguo/zj_api": "${workspaceRoot}"
      },
      "port": 9000
    },
    {
      "name": "Launch currently open script",
      "type": "php",
      "request": "launch",
      "program": "${file}",
      "cwd": "${fileDirname}",
      "port": 9000
    }
  ]
}

其中serverSourceRoot为项目位于服务器端的存储位置完整路径，localSourceRoot为本地项目存储位置完整路径，一般用环境变量${workspaceRoot}即可表示项目根目录。

调试用linux服务器端在PHP服务器可用的前提下，安装XDebug PHP调试扩展，在CentOS上可直接运行

`yum install php-pecl-xdebug`

安装，其它环境、安装方式可参考XDebug官方说明。
安装好后修改XDebug配置文件/etc/php.d/xdebug.ini，内容如下：

``` shell
# vim php.ini
zend_extension=xdebug.so
xdebug.remote_enable = 1
xdebug.remote_autostart = 1
xdebug.remote_connect_back = 0
xdebug.remote_host=192.168.2.14
xdebug.remote_port=9000
```

开启XDebug的调试功能，然后重启web服务器以使安装好的XDebug扩展及相关配置生效。重启后可通过phpinfo()内容验证XDebug是否成功启用并且设置的参数是否正确。没问题后开发环境已经算是搭建好了，接下来要解决的就是开发机的内网问题，一般来说，如果开发机和服务器都位于公网或可随意映射端口时，通过XDebug调试的过程是这样：开发机访问服务器的web服务器上的PHP脚本，这时服务器端PHP的XDebug扩展会回连发起HTTP请求设备的调试端口（默认9000），成功后即可开始断点调试等操作。另外这种情况下还可通过xdebug.remote_host的方式指定开发机的IP来选择允许指定IP进行调试操作。但在开发机处于内网环境并无法暴露调试端口的情况下，显然XDebug的回连操作是无法成功的，这时就需要通过某种方式来使调试连接能够成功建立，这里我使用的是ssh tunnel的方式，下面操作是以token2shell作为ssh客户端，通过其自带SSHpf程序来完成隧道建立的，其它ssh客户端如putty等也可实现类似功能：
打开token2shell的SSHpf，编辑连接，输入正确的server信息，并添SSH Port Forwarding，Type使用Remote Forwarding，Remote Port填写9000，Destination Host的Address为127.0.0.1，Port 9000。设置好后点击连接，验证成功后隧道连接即建立完成，可以在服务器端console通过netstat -lap查看到sshd正在侦听9000端口。然后开启VSCode的调试Listen for XDebug，然后设置PHP脚本的断点，打开任意浏览器，访问服务器端的对应php文件（当然，事先需要将本地的php上传到服务器端），一切正确的话断点就可以命中了
