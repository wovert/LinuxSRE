# Manjaro

[Linux排行](https://distrowatch.com/dwres.php?resource=popularity)

## 配置

### 1.切换中国源

```sh
$  sudo vi /etc/pacman-mirrors.conf
  OnlyCountry = China
```

### 2.增加archlinuxcn软件仓库以及各种开发工具源

```sh
$ sudo vi /etc/pacman.conf
  [archlinuxcn]
  SigLevel = Optional TrustedOnly
  Server = http://mirrors.ustc.edu.cn/archlinuxcn/$arch

  [arch4edu]
  SigLevel = Never
  Server = http://mirrors.tuna.tsinghua.edu.cn/arch4edu/$arch
```

### 3.更新并选择最快的源列表

```sh
$ sudo pacman-mirrors -g
```

### 4.更新系统

```sh
$ sudo pacman -Syyu
```

### 5.安装archlinuxcn-keyring

```sh
$ sudo pacman -S archlinuxcn-keyring

如果上面安装失败,则执行以下命令:
$ sudo pacman -Syu haveged
$ sudo systemctl start haveged
$ sudo systemctl enable haveged
$ sudo rm -rf /etc/pacman.d/gnupg
$ sudo pacman-key --init
$ sudo pacman-key --populate archlinux
$ sudo pacman -S archlinuxcn-keyring
$ sudo pacman-key --populate archlinuxcn
```

### 6.安装yaourt

```sh
$ sudo pacman -S yaourt
```

### 7.安装搜狗输入法

```sh
$ sudo pacman -S fcitx-sogoupinyin
$ sudo pacman -S fcitx-im
$ sudo pacman -S fcitx-configtool
$ sudo gedit ~/.xprofile
  export GTK_IM_MODULE=fcitx
  export QT_IM_MODULE=fcitx
  export XMODIFIERS="im=fcitx"
```

### 8.安装配置git

```sh
$ sudo pacman -S git

设置个人github信息：
$ git config --global user.name "github昵称"
$ git config --global user.email "注册邮箱"
```

### 9.安装配置zsh

```sh
$ sudo pacman -S zsh zsh-completions
$ cat /etc/shells
$ chsh -s /bin/zsh
$ sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```

## 安装软件

### chrom

```sh
sudo pacman -S google-chrome
```

### QQ/TIM

```sh
QQ: yaourt -S deepin.com.qq.im
TIM: yaourt -S deepin.com.qq.office
```

### 搜狗输入法

```sh
yaourt -S fcitx-sogoupinyin
sudo gedit ~/.xprofile
  export GTK_IM_MODULE=fcitx
  export QT_IM_MODULE=fcitx
  export XMODIFIERS="@im=fcitx"
```

### 安装wps

```sh
sudo pacman -S wps-office
sudo pacman -S ttf-wps-fonts
```

### 安装迅雷

```sh
yaourt -Sy deepin.com.thunderspeed
```

### 卸载libreoffice

```sh
sudo pacman -Rs libreoffice-fresh
```

### 卸载Transmission

```sh
sudo transmission-gtk
```

### 卸载Evolution

```sh
sudo pacman -Rs evolution
```

### 卸载Galculator

```sh
sudo pacman -Rs galculator
```

### 卸载Brasero

```sh
sudo pacman -Rs brasero
```

### 卸载HexChat

```sh
sudo pacman -Rs hexchat
```

### 安装网易云音乐

```sh
sudo pacman -S netease-cloud-music
```

### FQ软件安装

```sh
在图形界面的添加/删除搜那个Ss的全名关键字就有了，可以装QT5版本
如果浏览器想应用，还得装一下polipo端口转发。具体可以百度
```