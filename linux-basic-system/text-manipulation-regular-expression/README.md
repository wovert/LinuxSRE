- grep: 文本过滤工具（模式：pattern）
- sed: stream editor，流编辑器，行编辑器
- awk: Linux实现为gawk，文本报告生成器（格式化文本）

# 正则表达式：Regular Expression, RegExp
> 由一类特殊字符及文本字符所编写的模式，其中有些字符不表示其字面意义，而是用于表示控制或通配的功能；

## 正则表达式分两类
- 基本正则表达式：BRE
- 扩展在正则表达式：ERE

## 基本正则表达式
- 字符匹配
  - 元字符：
    - . : 任意单个字符
    - [a-z]：匹配指定范围内的任意单个字符				
    - [^a-z]：匹配指定范围外的任意单个字符
    - [:digit:]
    - [:lower:]
    - [:upper:]
    - [:alpha:]
    - [:alnum:]
    - [:punct:]
    - [:space:]

- 匹配次数：限制前面字符出现的次数；默认工作于贪婪模式
  - `*`：匹配其前面的字符任意次，多次
  - `.*`：匹配任意长度的任意的字符
  - `\?`：匹配其前面的至多1次 {0,1}
  - `\+`：匹配其前面的字符1次或多次；即至少匹配1次；
  - `\{m\}`
  - `\{m,n\}`
  - `\{0,n\}` 至多n次
  - `\{m,\}` 至少m次

- 位置锚定：
  - `$`：行首锚定
  - `^`：行尾锚定
  - `^PATTERN$`：匹配PATTERN来匹配整行
  - `^$`：空白行
  - `^[[:space:]]*$`：空白行或空白字符的行

  - 单词：非特殊字符组成的连续字符（字符串）都称为单词；

  - `\<,\b`：词首锚定
  - `\>,\b`：词尾锚定
  - `\<PATTERN\>`：匹配完整单词

- 分组及引用：
  - `\(\)`：讲一个或多个字符捆绑在一起，当作一个整体进行处理

  - `Note`: 分组；括号内的模式匹配到字符会被记录于正则表达式引擎的内部变量中

  - `反向引用`：
    - `\1`：模式从左侧起，第一个左括号以及与之匹配的右括号之间的模式所匹配到的字符
    - `\2`

  -  注意：括号可嵌套，但不可交叉

### 扩展正则表达式
- `+`
- `?`
- `{m,n}`
- `{m}`
- `{,n}`

## grep: Global regular expression and print out the line
- 作用：文本搜索工具，根据用户指定的“模式（过滤条件）"对目标文件逐行进行匹配检查；打印匹配到的行
- 模式：由正则表达式的元字符及文本字符所编写的过滤条件

- 正则表达式引擎：
  - `grep [OPTIONS] PATTERN [FILE...]`
  - `grep [OPTIONS] [-e PATTERN | -f FILE] [FILE...]`

### OPTIONS:
- 匹配方式："纯文本格式"或pattern

- -d：搜索子目录

- -e PATTERN 可以有多个匹配模式
- -f：文件中查找模式

- --color=auto：对匹配到的文本着色后高亮显示；
- -i,--ignorecase：忽略字符大小写
- -o：仅显示匹配到的字符串本身；
- -v, --invert-match：反向匹配

- -c：值输出匹配行的计数

- -h：查询多文件时不显示文件名
- -l：查询多文件时只输出包含匹配字符的文件名

- -n：显示匹配行及行号
- -s：不显示不存在或无匹配文本的错误信息

- -E,--extended-regexp：支持扩展正则表达式元字符
- -G,--basic-regexp: 支持基本正则表达式，默认选项

- -q,--quiet,--silent：静默模式，即不输出任何信息

- -A # : after n line
- -B # : before n line
- -C # : context n line

## grep -e PATTERN [FILE...]

## egrep PATTERN [FILE...]

- `-G` 基本正则表达式
- `-F` 不支持正则表达式
- 字符匹配：
  - `.`：任意单个字符
  - `[]`：指定范围内的任意单个字符
  - `[^]`：指定范围外的任意单个字符						

- 次数匹配：
  - `*`：任意次，0,1或多次；
  - `?`：0次或1次，其前的字符是可有可无的；
  - `+`：其前字符至少1次；
  - `{m}`：其前的字符m次；
  - `{m,n}`：至少m次，至多n次; 
  - `{0,n}`
  - `{m,}`

- 位置锚定
  - `^`：行首锚定
  - `$`：行尾锚定
  - `\<, \b`：词首锚定
  - `\>, \b`：词尾锚定；

- 分组及引用：
  - `()`：分组；括号内的模式匹配到的字符会被记录于正则表达式引擎的内部变量中；

- 后向引用：`\1, \2`, ...

- 或：
  - `a|b`：a或者b；
  - `C|cat`：C或cat
  - `(c|C)at`：cat或Cat	

## fgrep 字符串 [FILE...] 不支持正则表达式

-E 扩展正则表达式

-G 基本正则表达式

## 练习：

1. 找出/proc/meminfo文件中，所有以大写或小写S开头的行；至少有三种实现方式
```
# grep -i ^s /proc/meminfo
# grep  ^[sS] /proc/meminfo
# egrep -i ^s /proc/meminfo
# egrep ^[sS] /proc/meminfo
```

2. 显示当前系统上root、centos或user1用户的信息

`# grep -E “^(root|centos|user1)\>" /etc/passwd`

3. 找出/etc/rc.d/init.d/functions文件中单词后面跟一个小括号的行

`# grep -o -E  "\<[_[:alnum:]]+\>\(\)" /etc/rc.d/init.d/functions`

4. 找出ifconfig命令结果中的1-255之间的数值

`# ifconfig | grep -E -o "\<([1-9]|[0-9][1-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\>"`

5. 使用echo输出一绝对路径，使用egrep取出基名

`# echo /etc/sysconfig | grep -E -o "[^/]+/?$"`

6. 找出ifconfig命令结果中的IP地址

`# ifconfig | egrep "\<([0-9]{1,2}|1[0-9]{1,2}|2[0-4][0-9]|25[0-5])\.([0-9]{1,2}|1[0-9]{1,2}|2[0-4][0-9]|25[0-5])\.([0-9]{1,2}|1[0-9]{1,2}|2[0-4][0-9]|25[0-5])\.([0-9]{1,2}|1[0-9]{1,2}|2[0-4][0-9]|25[0-5])"`

7. 添加用户bash、testbash、basher以及nologin(其shell为/sbin/nologin)；而后找出/etc/passwd文件中用户名同shell名的行

`# grep -E "^([^:]+\>).*\1$" /etc/passwd`

## nl查看命令：

- `-b` 显示行
- `-b a`：显示空白行行号
- `-b t`：不显示空白行行号，默认

## wc命令：

- `-l`：lines
- `-w`：words
- `-c`：characters

## cut命令：

- `-d, --delimiter`：分隔符
- `-f, --fields`：n,m, n-m
- `--output-delimiter=string` 输出结果的分隔符

## sort命令：，sort=>tk,rn,fu

- `-n, --numeric-sort`
- `-r, --reverse`

- `-t CHAR`
- `-k, --key`

- `-f, --ignore-case`：忽略字符大小写
- `-u`：重复的行只保留一份

- `cut -d: -f7 /etc/passwd | sort -u | wc -l`

## uniq命令

> 报告或移除重复的行, 优衣库=》鸭子

`-u, --unique`：只显示唯一的行

`cut -d: -f7 /etc/passwd | sort | uniq -u` 

`-c, --count`：显示每行的重复次数

`cut -d: -f7 /etc/passwd | sort | uniq -c`

`-d, --repeated`：仅显示重复过的行

`only print duplicate lines, one for each group`

## diff命令：逐行比较两个文件不同之处

- OPTIONS:

`old new > file.patch`

`-i patch old`：老文件打补丁

`old < patch`

`-R -i patch old`: 还原老文件

`# diff fstab fstab.new > fstab.patch` （生成补丁文件）

`-u`：使用unfield机制，即显示要修改的行的上下文，默认为3行；

```
2c2,3 第一文件2行跟第二文件2，3行
< hi? 第一文件hi?
---
> hello? 第二文件hello?
> 第二文件空白`

`5c6 第一文件5行，第二文件6行
< I'm OK. 第一文件I'm OK
---
> I'm ok. 第二文件I'm ok.`
```

`# patch -i fstab.patch fstab 给老文件打补丁`

`# patch fstab.patch < fstab`

`# diff fstab fstab.new`

`# patch -R -i fstab.patch fstab 还原文件`

`-u：格式`

```
--- hello.txt 2016-10-24 22:35:05.684794237 +0800
+++ hello.txt2 2016-10-24 22:28:11.474780941 +0800
@@ -1,5 +1,6 @@ -第一文件的1行到5行，+第二文件的1行到5行
hi? 同样内容
-hi? 第一文件内容hi?
+hello? 第二文件内容hello?
+ 第二文件空白内容
How are you? 同样内容
I'm fine.And you? 同样内容
-I'm OK. 第一文件内容
+I'm ok. 第二文件内容
```

## 获取帮助

`:help subject`

# sed命令

> 不修改源文件，读取一行放置**pattern space内存空间**

模式匹配之后编辑之后的结果输出到标准输出，也可以把模式编辑的结果保存到**hold space内存空间**与pattern space空间交换数据
默认不能模式匹配的结果直接输出到标准输出，也可以不能模式匹配到的不输出
然后依次读取下一行

## 流程

1. 取每行
2. pattern space内存空间
3. 匹配模式

NO => stdout (-n不输出次内容)

YES => edit => stdout

YES => edit <--> hold space => stdout

`sed [OPTION]...  'script'  [input-file] ...`

> script：地址定界 编辑命令(没有空白字符分割)

## 常用选项：rinfe

-n：不输出模式空间中的编辑匹配的内容至屏幕

-e script, --expression=script：多个编辑命令

-f  /PATH/TO/SED_SCRIPT_FIL：每行一个编辑命令

-r, --regexp-extended：支持使用扩展正则表达式，默认支持标准正则表达式

-i[SUFFIX], --in-place[=SUFFIX]：直接编辑原文件 

`# sed -e 's@^#[[:space:]]*@@' -e '/^UUID/d'  /etc/fstab`

## 地址定界：

1. 空地址：对全文进行处理；

2. 单地址：

`#`：指定行

`/pattern/`：被此模式所匹配到的每一行；

3. 地址范围
`#,#`：

`+ #,+#`：

`#，/pat1/`

`/pat1/,/pat2/`

`$`：最后一行

4. 步进：

1~2：所有奇数行

2~2：所有偶数行

## 编辑命令：

d：删除模式空间的行

`# sed '1,5d' /etc/fstab`

`# sed '/^UUID/d' /etc/fstab`

`# sed '1,5d' /etc/fstab`

`# sed '3d' /etc/fstab 删除第三行`

`# sed -n '1~2' /etc/fstab`

p：显示模式空间中的内容

`# sed '1~2p' /etc/fstab` 显示所有行奇数行显示两遍，

`# sed -n '1~2p' /etc/fstab` 只显示奇数行，默认匹配的都不显示-n效果

a  \text：在行后面追加文本“text"，支持使用\n实现多行追加；

`# sed '/^UUID/a \# add new sed on UUID' /etc/fstab`

- i  \text：在行前面插入文本“text"，支持使用\n实现多行插入；
	+ `# sed '3i \new line' /etc/fstab`

- c  \text：把匹配到的行替换为此处指定的文本“text"
	+ `# sed '/^UUID/c \# add new on UUID' /etc/fstab`

- w /PATH/TO/SOMEFILE：保存模式空间匹配到的行至指定的文件中
	+ `# sed -n '/^[^#]/w /tmp/a.txt' /etc/fstab`

- r /PATH/FROM/SOMEFILE：读取指定文件的内容至当前文件被模式匹配到的行后面；文件合并；
	+ `# sed '3r /etc/issue' /etc/fstab`	

- =：为模式匹配到的行打印行号， 新行
	+ `# sed '/^UUID/= /etc/fstab`


- ! 条件取反；
- 地址定界!编辑命令
	+ `# sed '/^#/!d' /etc/fstab`

- s///：查找替换，其分隔符可自行指定，常用的有s@@@, s###等；
	+ 替换标记：
		* g 全局替换
		* w /PATH/TO/SOMEFILE：将替换成功的结果保存至指定文件中
		* p 显示替换成功的行

### 练习1：删除/boot/grub/grub2.cfg文件中所有以空白字符开头的行的行首的所有空白字符；
`# sed  's@^[[:space:]]\+@@' /etc/grub2.cfg`

###  练习2：删除/etc/fstab文件中所有以#开头的行的行首的#号及#后面的所有空白字符；
`# sed  's@^#[[:space:]]*@@'  /etc/fstab`

###  练习3：输出一个绝对路径给sed命令，取出其目录，其行为类似于dirname；
`# echo "/var/log/messages/" | sed 's@[^/]\+/\?$@@'`
`# echo "/var/log/messages" | sed -r 's@[^/]+/?$@@'`

## 高级编辑命令：
- h：把模式空间中的内容覆盖至保持空间中
- H：把模式空间中的内容追加至保持空间中
- g：把保持空间中的内容覆盖至模式空间中
- G：把保持空间中的内容追加至模式空间中
- x：把模式空间中的内容与保持空间中的内容互换
- n：覆盖读取匹配到的行的下一行至模式空间中
- N：追加读取匹配到的行的下一行至模式空间中
- d：删除模式空间中的行
- D：删除多行模式空间中的所有行
			
###	示例
`# sed -n 'n;p'  FILE：		显示偶数行`
`# sed '1!G;h;$!d'  FILE：	逆序显示文件的内容`
`# sed '$!d'  FILE：			取出最后一行`
`# sed '$!N;$!D' FILE：		取出文件后两行`
`# sed '/^$/d;G' FILE：		删除原有的所有空白行，而后为所有的非空白行后添加一个空白行`
`# sed 'n;d'  FILE：			显示奇数行`
`# sed 'G' FILE：			在原有的每行后方添加一个空白行`

# GNU awk：
**AWK**: Aho, Weinberger, Kernighan --> New AWK, **NAWK**
GNU awk, **gawk**	
> gawk - pattern scanning and processing language

- 基本用法：gawk [options] 'program' FILE ...
	+ program: PATTERN{ACTION STATEMENTS}
	+ 语句之间用分号分隔

- 选项：
	+ -F：指明输入时用到的字段分隔符
	+ -v var=value: 自定义变量
- 分片：$1,$2,$n, 整行$0

## 1.print
- `print item1, item2, ...`

### (1) 逗号分隔符

### (2) 输出的各item可以字符串，也可以是数值；当前记录的字段、变量或awk的表达式
`# tail -5 /etc/fstab/ | awk '{print "hello",$2,$5,6}'`
`# tail -5 /etc/fstab/ | awk '{print "hello:$1"}'`
> "hello:$1"的$1不会变量替换，只有在引号之外才能变量替换

### (3)如省略item，相当于print $0;打印**整行字符** 		
`# tail -5 /etc/fstab/ | awk '{print}'`
`# tail -5 /etc/fstab/ | awk '{print ""}'`

## 2.变量
### 2.1 内建变量
- FS：input field seperator，输入时字段分隔符，默认为空白字符；
- OFS：output field seperator，输出时字段分隔符，默认为空白字符；
- RS：input record seperator，输入时的换行符；
- ORS：output record seperator，输出时的换行符；

`# awk -F: '{print $1}' /etc/passwd`
`# awk -v FS=':' -v OFS=':' '{print $1,$3,$7}' /etc/passwd`
`# awk -v RS=' ' -v ORS='#' '{print}' /etc/passwd`

- NF：number of field 每行字段数量
`# awk '{print NF}' /etc/fstab`		=> 0 2 3
`# awk '{print $NF}' /etc/fstab` 最后一个字段的值

- NR：number of record, 行数的编号
`# awk '{print NR}' /etc/fstab /etc/issue` 	行数编号
1
2
3
4

- FNR：各文件分别计数；行数编号
`# awk '{print FNR}' /etc/fstab	/etc/issue` 	
1
2
1
2

- FILENAME：当前文件名
- ARGC：命令行参数的个数
- ARGV：数组，保存的是命令行所给定的各参数；

`# awk '{print ARGC}' /etc/fstab /etc/issue`
>每行显示命令参数个数
3
3
...

### BEGIN只执行一次
`# awk 'BEGIN{print ARGV[0]}' /etc/fstab /etc/issue`
awk
`# awk 'BEGIN{print ARGV[1]}' /etc/fstab /etc/issue`
/etc/fstab
`# awk 'BEGIN{print ARGV[2]}' /etc/fstab /etc/issue`
/etc/issue

### 2.2 自定义变量
- (1) -v var=value变量名区分字符大小写
`# awk -v test="hello gawk' 'BEGIN{print test}'`

- (2)在program中直接定义
`# awk 'BEGIN{test="hello gawk";print test}'`

## 3.printf命令
> 格式化输出：printf FORMAT, item1, item2, ...

- (1) FORMAT必须给出; 
- (2) 不会自动换行，需要显式给出换行控制符，\n
- (3) FORMAT中需要分别为后面的每个item指定一个格式化符号；
		
- 格式符：
	+ %c: 显示字符的ASCII码；
	+ %d, %i: 显示十进制整数；
	+ %e, %E: 科学计数法数值显示；
	+ %f：显示为浮点数；
	+ %g, %G：以科学计数法或浮点形式显示数值；
	+ %s：显示字符串；
	+ %u：无符号整数；
	+ %%: 显示%自身；

- 修饰符：
	+ #[.#]：第一个数字控制显示的宽度；第二个#表示小数点后的精度；
	+ %3.1f
	+ -: 左对齐
	+ +：显示数值的符号

## 4.操作符
- 算术操作符：x+y, x-y, x*y, x/y, x^y, x%y, -x, +x: 转换为数值
- 字符串操作符：没有符号的操作符，字符串连接
- 赋值操作符：=, +=, -=, *=, /=, %=, ^=, ++, --
- 比较操作符：>, >=, <, <=, !=, ==
- 模式匹配符：
	+ ~：是否匹配
	+ !~：是否不匹配

- 逻辑操作符：&&, ||, !
- 函数调用：function_name(argu1, argu2, ...)
- 条件表达式：selector?if-true-expression:if-false-expression

`# awk -F: '{$3>=1000?usertype="Common User":usertype="Sysadmin or SysUser";printf "%15s:%-s\n",$1,usertype}' /etc/passwd`

## 5.PATTERN
- (1) empty：空模式，匹配每一行；
- (2) /regular expression/：仅处理能够被此处的模式匹配到的行；
- (3) relational expression: 关系表达式；结果有“真"有“假"；结果为“真"才会被处理；
真：结果为非0值，非空字符串；
- (4) line ranges：行范围，startline,endline：/pat1/,/pat2/
	+ 注意： 不支持直接给出数字的格式
	+ `# awk -F: '(NR>=2&&NR<=10){print $1}' /etc/passwd`

- (5) BEGIN/END模式
	+ BEGIN{}: 仅在开始处理文件中的文本之前执行一次；
	+ END{}：仅在文本处理完成之后执行一次；

## 6.常用的action
(1) Expressions
(2) Control statements：if, while等；
(3) Compound statements：组合语句；
(4) input statements
(5) output statements

## 7.控制语句
if(condition) {statments} 
if(condition) {statments} else {statements}
while(conditon) {statments}
do {statements} while(condition)
for(expr1;expr2;expr3) {statements}
break
continue
delete array[index]
delete array
exit 
{ statements }

### 7.1 if-else
- 语法：if(condition) statement [else statement]

`# awk -F: '{if($3>=1000) {printf "Common user: %s\n",$1} else {printf "root or Sysuser: %s\n",$1}}' /etc/passwd`

`# awk -F: '{if($NF=="/bin/bash") print $1}' /etc/passwd`

`# awk '{if(NF>5) print $0}' /etc/fstab`

`# df -h | awk -F[%] '/^\/dev/{print $1}' | awk '{if($NF>=20) print $1}'`

- 使用场景：对awk取得的整行或某个字段做条件判断；

### 7.2 while循环
- 语法：while(condition) statement
条件“真"，进入循环；条件“假"，退出循环；
使用场景：对一行内的多个字段逐一类似处理时使用；对数组中的各元素逐一处理时使用；

`# awk '/^[[:space:]]*linux16/{i=1;while(i<=NF) {print $i,length($i); i++}}' /etc/grub2.cfg`

`# awk '/^[[:space:]]*linux16/{i=1;while(i<=NF) {if(length($i)>=7) {print $i,length($i)}; i++}}' /etc/grub2.cfg`

### 7.3 do-while循环
语法：do statement while(condition) 意义：至少执行一次循环体

### 7.4 for循环
- 语法：for(expr1;expr2;expr3) statement

for(variable assignment;condition;iteration process) {for-body}

`# awk '/^[[:space:]]*linux16/{for(i=1;i<=NF;i++) {print $i,length($i)}}' /etc/grub2.cfg`

### 特殊用法：能够遍历数组中的元素；
- 语法：for(var in array) {for-body}

### 7.5 switch语句
- 语法：switch(expression) {case VALUE1 or /REGEXP/: statement; case VALUE2 or /REGEXP2/: statement; ...; default: statement}

### 7.6 break和continue
- break
- continue

### 7.7 next
- 提前结束对本行的处理而直接进入下一行；
`# awk -F: '{if($3%2!=0) next; print $1,$3}' /etc/passwd`

## 8. array
- 关联数组：array[index-expression]

### index-expression:
- (1) 可使用任意字符串；字符串要使用双引号；

- (2) 如果某数组元素事先不存在，在引用时，awk会自动创建此元素，并将其值初始化为“空串"；

- 若要判断数组中是否存在某元素，要使用"index in array"格式进行
weekdays[mon]="Monday"

- 若要遍历数组中的每个元素，要使用for循环；
	+ for(var in array) {for-body}

`# awk 'BEGIN{weekdays["mon"]="Monday";weekdays["tue"]="Tuesday";for(i in weekdays) {print weekdays[i]}}'`
注意：var会遍历array的每个索引；
state["LISTEN"]++
state["ESTABLISHED"]++

`# netstat -tan | awk '/^tcp\>/{state[$NF]++}END{for(i in state) { print i,state[i]}}'`

`# awk '{ip[$1]++}END{for(i in ip) {print i,ip[i]}}' /var/log/httpd/access_log`

- 练习1：统计/etc/fstab文件中每个文件系统类型出现的次数；
`# awk '/^UUID/{fs[$3]++}END{for(i in fs) {print i,fs[i]}}' /etc/fstab`

- 练习2：统计指定文件中每个单词出现的次数；
`# awk '{for(i=1;i<=NF;i++){count[$i]++}}END{for(i in count) {print i,count[i]}}' /etc/fstab`

## 9.函数
### 9.1 内置函数
- 数值处理：rand()：返回0和1之间一个随机数；
- 字符串处理：
	+ length([s])：返回指定字符串的长度；
	+ sub(r,s,[t])：以r表示的模式来查找t所表示的字符中的匹配的内容，并将其第一次出现替换为s所表示的内容；
	+ gsub(r,s,[t])：以r表示的模式来查找t所表示的字符中的匹配的内容，并将其所有出现均替换为s所表示的内容；
	+ split(s,a[,r])：以r为分隔符切割字符s，并将切割后的结果保存至a所表示的数组中；

`# netstat -tan | awk '/^tcp\>/{split($5,ip,":");count[ip[1]]++}END{for (i in count) {print i,count[i]}}'`

### 9.2 自定义函数
《sed和awk》