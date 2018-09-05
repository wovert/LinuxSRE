# glibc

- glibc版本
`getconf -a|grep glibc -i`

- 下载[glibc-2.25](http://mirrors.ustc.edu.cn/gnu/libc/glibc-2.25.tar.gz)

1. 安装

`su
cd /usr/src
tar -zxvf glibc-2.25.tar.gz
mkdir glibc-build
cd glibc-build
../glibc-2.25/configure --prefix=/usr
make
make install`

2. 修改软链接

`cd /lib64
LD_PRELOAD=/lib64/libc-2.25.so ln -sf libc-2.25.so libc.so.6
LD_PRELOAD=/lib64/libc-2.25.so ln -sf libm-2.25.so libm.so.6
LD_PRELOAD=/lib64/libc-2.25.so ln -sf libpthread-2.25.so libpthread.so.0
LD_PRELOAD=/lib64/libc-2.25.so ln -sf librt-2.25.so librt.so.1`

3. 验证
`ldd --version`

4. 引用



网上关于升级glibc的文章不少，但没有一篇能成功的，本人被坑过无数次，以至后来能避就避，今天自己在虚拟机上实验，终于成功，我把升级过程记录下来，为网友提供完整的升级方法。



升级是在ubuntu下进行的，但是其他系统升级也类似，我的系统版本：

Linux ubuntu 3.19.0-25-generic #26~14.04.1-Ubuntu SMP Fri Jul 24 21:16:20 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux



准备两个Linux系统, 一个是你要升级glibc的系统B, 另一个A用于glibc升级失败之后恢复, 
它能挂载升级失败的系统的根文件系统, 恢复失败的系统.

首先配置系统B, 
安装 nfs 服务
配置成 A能以root身份访问B

做法:
服务器B安装 nfs服务 
sudo apt-get install nfs-kernel-server

然后启动nfs服务:
sudo /etc/init.d/nfs-kernel-server start

编辑/etc/exports,加入:
/ A_ip(rw,sync,no_root_squash)

然后重启动nfs服务:
sudo /etc/init.d/nfs-kernel-server restart

配好之后 登录系统A
挂载系统B的根文件系统

mkdir /mnt/glibc-upgrade
sudo mount -t nfs B_ip:/ /mnt/glibc-upgrade


1. 登录系统B
下载最新版本的glibc
git clone git://sourceware.org/git/glibc.git
cd glibc
git checkout --track -b local_glibc-2.25 origin/release/2.25/master

2. 
mkdir build-glibc
cd build-glibc
../glibc/configure --prefix=/usr
make
make install install_root=~/share/src-glibc-2.25/system_fake_root

ll ~/share/src-glibc-2.25/system_fake_root 
查看glibc安装时会修改哪些文件,
将这些文件进行备份(安全起见, 以便升级失败恢复原来的系统, 一定要备份)

我的glibc安装会修改以下文件
xxx@ubuntu:~/share/git-glibc-src/system_fake_root$ ll
total 28
drwxrwxr-x 7 liuwb  liuwb  4096 Apr  7 00:26 ./
drwxrwxr-x 5 liuwb  liuwb  4096 Apr  7 00:20 ../
drwxr-xr-x 2 root root 4096 Apr  7 00:26 etc/
drwxr-xr-x 2 root root 4096 Apr  7 00:26 lib64/
drwxr-xr-x 2 root root 4096 Apr  7 00:26 sbin/
drwxr-xr-x 8 root root 4096 Apr  7 00:22 usr/
drwxr-xr-x 3 root root 4096 Apr  7 00:23 var/

以上是glibc源代码 make install 会修改的目录

liuwb@ubuntu:~/share/git-glibc-src/system_fake_root$ ll lib64/
total 18768
drwxr-xr-x 2 root root     4096 Apr  7 00:26 ./
drwxrwxr-x 7 liuwb  liuwb      4096 Apr  7 00:26 ../
-rwxr-xr-x 1 root root   863537 Apr  7 00:26 ld-2.25.90.so*
lrwxrwxrwx 1 root root       13 Apr  7 00:26 ld-linux-x86-64.so.2 -> ld-2.25.90.so*
-rwxr-xr-x 1 root root    75101 Apr  7 00:26 libanl-2.25.90.so*
lrwxrwxrwx 1 root root       17 Apr  7 00:26 libanl.so.1 -> libanl-2.25.90.so*
-rwxr-xr-x 1 root root    19640 Apr  7 00:25 libBrokenLocale-2.25.90.so*
lrwxrwxrwx 1 root root       26 Apr  7 00:26 libBrokenLocale.so.1 -> libBrokenLocale-2.25.90.so*
-rwxr-xr-x 1 root root 10177656 Apr  7 00:26 libc-2.25.90.so*
-rwxr-xr-x 1 root root   275419 Apr  7 00:26 libcidn-2.25.90.so*
lrwxrwxrwx 1 root root       18 Apr  7 00:26 libcidn.so.1 -> libcidn-2.25.90.so*
-rwxr-xr-x 1 root root   136272 Apr  7 00:26 libcrypt-2.25.90.so*
lrwxrwxrwx 1 root root       19 Apr  7 00:26 libcrypt.so.1 -> libcrypt-2.25.90.so*
lrwxrwxrwx 1 root root       15 Apr  7 00:26 libc.so.6 -> libc-2.25.90.so*
-rwxr-xr-x 1 root root    97704 Apr  7 00:26 libdl-2.25.90.so*
lrwxrwxrwx 1 root root       16 Apr  7 00:26 libdl.so.2 -> libdl-2.25.90.so*
-rwxr-xr-x 1 root root  4219769 Apr  7 00:26 libm-2.25.90.so*
-rwxr-xr-x 1 root root    46984 Apr  7 00:26 libmemusage.so*
lrwxrwxrwx 1 root root       15 Apr  7 00:26 libm.so.6 -> libm-2.25.90.so*
-rwxr-xr-x 1 root root   194650 Apr  7 00:26 libmvec-2.25.90.so*
lrwxrwxrwx 1 root root       18 Apr  7 00:26 libmvec.so.1 -> libmvec-2.25.90.so*
-rwxr-xr-x 1 root root   575386 Apr  7 00:26 libnsl-2.25.90.so*
lrwxrwxrwx 1 root root       17 Apr  7 00:26 libnsl.so.1 -> libnsl-2.25.90.so*
-rwxr-xr-x 1 root root   158298 Apr  7 00:26 libnss_db-2.25.90.so*
lrwxrwxrwx 1 root root       20 Apr  7 00:26 libnss_db.so.2 -> libnss_db-2.25.90.so*
-rwxr-xr-x 1 root root    94107 Apr  7 00:26 libnss_dns-2.25.90.so*
lrwxrwxrwx 1 root root       21 Apr  7 00:26 libnss_dns.so.2 -> libnss_dns-2.25.90.so*
-rwxr-xr-x 1 root root   249089 Apr  7 00:26 libnss_files-2.25.90.so*
lrwxrwxrwx 1 root root       23 Apr  7 00:26 libnss_files.so.2 -> libnss_files-2.25.90.so*
-rwxr-xr-x 1 root root    87402 Apr  7 00:26 libnss_hesiod-2.25.90.so*
lrwxrwxrwx 1 root root       24 Apr  7 00:26 libnss_hesiod.so.2 -> libnss_hesiod-2.25.90.so*
-rwxr-xr-x 1 root root    12334 Apr  7 00:26 libpcprofile.so*
-rwxr-xr-x 1 root root   970407 Apr  7 00:26 libpthread-2.25.90.so*
lrwxrwxrwx 1 root root       21 Apr  7 00:26 libpthread.so.0 -> libpthread-2.25.90.so*
-rwxr-xr-x 1 root root   370842 Apr  7 00:26 libresolv-2.25.90.so*
lrwxrwxrwx 1 root root       20 Apr  7 00:26 libresolv.so.2 -> libresolv-2.25.90.so*
-rwxr-xr-x 1 root root   200745 Apr  7 00:26 librt-2.25.90.so*
lrwxrwxrwx 1 root root       16 Apr  7 00:26 librt.so.1 -> librt-2.25.90.so*
-rwxr-xr-x 1 root root    70685 Apr  7 00:26 libSegFault.so*
-rwxr-xr-x 1 root root   238153 Apr  7 00:26 libthread_db-1.0.so*
lrwxrwxrwx 1 root root       19 Apr  7 00:26 libthread_db.so.1 -> libthread_db-1.0.so*
-rwxr-xr-x 1 root root    32122 Apr  7 00:26 libutil-2.25.90.so*
lrwxrwxrwx 1 root root       18 Apr  7 00:26 libutil.so.1 -> libutil-2.25.90.so*


虽然glibc安装时不会修改/lib 下的文件, 也要将 /lib 目录备份, 因为/lib下的lib依赖
的还是旧版本的glibc, 而系统A就是在这里起关键作用, 系统A负责把 /lib 依赖旧版本的lib
改为依赖新版本的lib

3.sudo make install
这个时候通常是失败的, 我的系统提示是
coredump
具体是:
/home/liuwb/share/glibc-2.25-build/elf/sln /home/liuwb/share/glibc-2.25-build/elf/symlink.list
rm -f /home/liuwb/share/glibc-2.25-build/elf/symlink.list
make[1]: *** [install-symbolic-link] Segmentation fault (core dumped)
make[1]: Leaving directory `/home/liuwb/share/glibc'
make: *** [install] Error 2

这是因为/home/liuwb/share/glibc-2.25-build/elf/sln /home/liuwb/share/glibc-2.25-build/elf/symlink.list
修改了 /lib64/ld-linux-x86-64.so.2 它指向了新版本的

#ll /lib64/ld-linux-x86-64.so.2 
/lib64/ld-linux-x86-64.so.2 -> /lib/x86_64-linux-gnu/ld-2.25.90.so* 

然而
ldd /bin/ls
    linux-vdso.so.1 =>  (0x00007fff474e0000)
    libselinux.so.1 => /lib/x86_64-linux-gnu/libselinux.so.1 (0x00007fdceab17000)
    libacl.so.1 => /lib/x86_64-linux-gnu/libacl.so.1 (0x00007fdcea90f000)
    libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007fdcea54a000)
    libpcre.so.3 => /lib/x86_64-linux-gnu/libpcre.so.3 (0x00007fdcea30c000)
    libdl.so.2 => /lib/x86_64-linux-gnu/libdl.so.2 (0x00007fdcea108000)
    /lib64/ld-linux-x86-64.so.2 (0x00007fdcead3a000)
    libattr.so.1 => /lib/x86_64-linux-gnu/libattr.so.1 (0x00007fdce9f03000)
    
ls 依赖的 /lib/x86_64-linux-gnu/libc.so.6 
/lib/x86_64-linux-gnu/libc.so.6 -> libc-2.19.so* 这还是旧版本的libc~

rm 也一样的

所以 Segmentation fault (core dumped) 了

那为啥 ld-VERSION.so 和 libc-VERSION.so 版本不一致会core呢?
这是因为:
ldd /lib/x86_64-linux-gnu/libc.so.6
    /lib64/ld-linux-x86-64.so.2 (0x00007f49dc122000)
    linux-vdso.so.1 =>  (0x00007ffd6f531000)
    
libc.so.6 -> libc-VERSION.so  依赖 /lib64/ld-linux-x86-64.so.2
而 /lib64/ld-linux-x86-64.so.2 -> ld-VERSION.so 

4. A系统登场
只需要
cd 到B系统的根目录,
ln -sf libc-VERSION-NEW.so  /lib/x86_64-linux-gnu/libc.so.6

我的B系统的glibc安装都安装到了 /lib64/ 目录下

把 /lib64/ 目录下的 libxxx-VERSION-NEW.so 拷贝到 /lib/x86_64-linux-gnu/ 下
把 /lib/x86_64-linux-gnu/libxxx.x.1.so.x => /lib/x86_64-linux-gnu/libxxx-VERSION-OLD.x.1.x.so
/lib/x86_64-linux-gnu/libxxx.x.1.so.x => /lib/x86_64-linux-gnu/libxxx-VERSION-NEW.x.1.x.so

5. 再到 B系统验证一下一些常用的命令是否能用
如果命令都能正确运行, 系统的大多数命令就已经可以用了, 也没必要再make install了(上次的make install 不是没成功嘛)

但是我还是进行了第二次 make install, 结果报下面的错误:
/usr/bin/install -c /home/liuwb/share/git-glibc-src/build/elf/ld.so /lib64/ld-2.25.90.so.new
mv -f /lib64/ld-2.25.90.so.new /lib64/ld-2.25.90.so
/usr/bin/install -c /home/liuwb/share/git-glibc-src/build/libc.so /lib64/libc-2.25.90.so.new
mv -f /lib64/libc-2.25.90.so.new /lib64/libc-2.25.90.so
rm -f /lib64/ld-linux-x86-64.so.2
ln -s `../scripts/rellns-sh -p /lib64/ld-2.25.90.so /lib64/ld-linux-x86-64.so.2` /lib64/ld-linux-x86-64.so.2
make[2]: /bin/sh: Command not found
make[2]: *** [/lib64/ld-linux-x86-64.so.2] Error 127
make[2]: Leaving directory `/home/liuwb/share/git-glibc-src/glibc/elf'
make[1]: *** [elf/ldso_install] Error 2
make[1]: Leaving directory `/home/liuwb/share/git-glibc-src/glibc'
make: *** [install] Error 2

注意:
rm -f /lib64/ld-linux-x86-64.so.2
ln -s `../scripts/rellns-sh -p /lib64/ld-2.25.90.so /lib64/ld-linux-x86-64.so.2` /lib64/ld-linux-x86-64.so.2

第一次 make install 的时候, 会修改/lib64/ld-linux-x86-64.so.2 指向新版本的 ld-VERSION-NEW.so
/lib64/ld-linux-x86-64.so.2 -> /lib/x86_64-linux-gnu/ld-2.25.90.so* 
已经是新版本的了

第二次 make install 的话, install还要把/lib64/ld-linux-x86-64.so.2 删掉,
这样就导致了install要执行 ln -s 命令执行不了了,
为啥执行不了呢?
我在A系统上看B系统的/bin/ln
ldd ./bin/ln
    linux-vdso.so.1 =>  (0x00007ffe08b6b000)
    libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007fb14f0c3000)
    /lib64/ld-linux-x86-64.so.2 (0x00007fb14f488000)
它是依赖 /lib64/ld-linux-x86-64.so.2 的,
/lib64/ld-linux-x86-64.so.2 如果都被删掉了, 自然ln命令执行不了了

于是 我又在A系统手动执行下面这两条命令 
cd lib64/
ln -sf ld-2.25.90.so ld-linux-x86-64.so.2

这样B系统又能ls,ln了

总之我觉得第一次make install失败了, 从A系统修改指向旧版本的软连接之后, B系统重新能运行大部分命令
就算升级成功了....
并且用一个小小的输出当前glibc版本的c程序, 也输出新版本了
#include <stdio.h>
#include <gnu/libc-version.h>
int main (void) { puts (gnu_get_libc_version ()); return 0; }

liuwb@ubuntu:~/share/check_glibc_version$ gcc main.c 
liuwb@ubuntu:~/share/check_glibc_version$ ./a.out 
2.25.90

然后我觉得应该成功了, = = ! 如果以后发现还有问题再来补充吧, 继续完成glibc升级大业

如果在B系统执行命令有这样的错误
Illegal Instruction(coredump)

检查一下是否还有一些库没替换成新版本的

--------------------------------------------------------------
../glibc/configure --prefix=/usr --host=i686-pc-linux-gnu 
../glibc/configure --prefix=/usr --host=x86_64-pc-linux-gnu
make CFLAGS+=-mtune=x86_64
make时
make CFLAGS+=-mtune=i686

如果 cc1:all warnings being treated as errors
../glibc/configure --prefix=/usr --host=i686-pc-linux-gnu --disable-werror

#error "glibc cannot be compiled without optimization"',