# LVM
- **LVM**：Logical Volume Manager, Version: 2
- **dm模块**：device mapper，将一个或多个底层设备组织成一个逻辑设备的模块
- 设备文件：/dev/md-#

- LV(Logical Volume) 
	+ LE (Logic Extend)
- VG(Volume Group)包含
	+ PE(Physical extend)，默认4MB
- PV(physical Volume)，逻辑卷，多个分区

/dev/mapper/VG_NAME-LV_NAME 
	<-- /dev/VG_NAME/LV_NAME
/dev/mapper/vol0-root 
	<-- /dev/vol0/root
    <-- /dev/dm-0

## 创建步骤
1. create pv(pe)
2. create vg
3. create lv(le)

## LVM系统分区ID：**8e, Linux LVM**

## pvcreate：创建 pv
- `$ pvcreate /dev/DEVICE`
	+ `-v:verbose`
	+ `-f:force 覆盖数据`

## pvremove：移除pv
- `$ pvremove /dev/DEVICE`

## pvs,pvdisplay：查看pv
- `$ pvs /dev/DEVICE` 		简要显示信息
- `$ pvdisplay /dev/DEVICE` 详细显示信息
		
## 其他pv管理工具
- pvmove
- pvscan
- pvresize
- pvck
- pvchange

## vgs,vgdisplay: 查看vg
`$ vgs`
`$ vgdisplay [vgName]`

## vgcreate: 创建vg, 默认PE 4MB
`$ vgcreate -s #[kKmMgGtTpPeE] vgName /dev/DEVICE ...`

## vgremove: 移除vg
`$ vgremove -s #[kKmMgGtTpPeE] vgName /dev/DEVICE`

## vgextend: 扩展vg
`$ vgextend vgname /dev/DEVICES`

## vgreduce: 缩减vg
- `$ pvmove /dev/DEVICE`			移动数据
- `$ vgreduce vgname /dev/DEVICE` 后缩减vg

## lvs,lvdisplay: 查看lv
```
$ lvs
$ lvdisplay [/dev/vg0/root]
$ lvdisplay [/dev/mapper/vg0-root]
```

## lvcreate, 创建lv
```
$ lvcreate -L #[mMgGtTpPeE] -n lvName vgName
$ lcreate -L 8G -n lv0 vg0
$ ls -l /dev/mapper/vg0-lv0 --> ../dm-0
```

## lvremove，移除lv
`$ lvremove lvName vgName`

## lextend, 扩展lv
```
$ lvextend -L +#[mMgGtT] /dev/vg0/lv0
$ lvextend -L +2G /dev/vg0/lv0
加多少
目标大小直接写大小
$ umount /lvdata
$ mount /dev/vg0/lv0 /lvdata
大小还是没有变化？
文件系统没有扩展，所以没有显示增加的大小
$ resize2fs /dev/vg0/lv0 扩展文件系统占用空间
$ df -hl
```

## 缩减逻辑卷
1. `# umount /dev/VG_NAME/LV_NAME`
2. `# e2fsck -f /dev/VG_NAME/LV_NAME` 文件系统强制检测
3. `# resize2fs /dev/VG_NAME/LV_NAME #[mMgGtT]` 缩减文件系统大小
4. `# lvreduce -L [-]#[mMgGtT] /dev/VG_NAME/LV_NAME`
5. `# mount`

#　快照：snapshot
- 访问原卷的路径
- 原卷发生变化时，把数据存储到快照卷上，然后修改原数据
- 目的：文件的另一个访问路径，与硬链接相似

## 创建快照,r只读
- `# lvcreate -L sieze -p r -s -n snapshot_lv_name orginal_lv_name`
- `# lvcreate -s -L 512M -n lv0-snap -p r /dev/vg0/lv0` 
- `# mount /dev/vg0/lv0-snap /mnt`

## 删除快照：
- `# umount /mnt`
- `# lvremove /dev/vg0/lv0-snap`

## 练习：
1. 创建一个至少有两个PV组成的大小为20G的名为testvg的VG；要求PE大小为16MB，而后在卷组中创建大小为5G的逻辑卷testlv；挂载至/users目录
2. 新建用户archlinux，其家目录为/users/archlinux，而后su切换至archlinux用户，复制/etc/pam.d目录至自己的家目录
3. 扩展testlv至7G，要求archlinux用户的文件不能丢失
4. 收缩testlv至3G，要求archilnux用户的文件不能丢失
5. 对testlv创建快照，并尝试基于快照备份数据，验证快照的功能；