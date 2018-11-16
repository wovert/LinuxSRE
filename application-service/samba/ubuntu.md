# ubunt 挂载 samba 共享目录

``` sh
$ sudo apt-get install cifs-utils

挂载指令, 源必须精确到目录
sudo mount.cifs //192.168.1.2/samba共享名 /home/dev -o username=xx,password=samba通用密码, iocharset=utf8, file_mode=0777, dir_mode=0777, uid=0,gid=0, sec=ntlmssp

卸载指令
$ sudo umount /var/www/html/1/NAS --force

$ sudo code --user-data-dir="~/.vscode-root"
```