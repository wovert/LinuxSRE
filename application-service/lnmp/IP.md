二、国家地区IP限制访问
有些第三方也提供设置，如cloudflare，设置更简单，防火墙规则里设置。这里讲讲nginx的设置方法。



出现这个的原因是因为本地yum源中没有我们想要的nginx，那么我们就需要创建一个“/etc/yum.repos.d/nginx.repo”的文件，新增一个yum源。

[root@localhost data]# vim /etc/yum.repos.d/nginx.repo
在这个文件中写入以下内容：

[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/centos/$releasever/$basearch/
gpgcheck=0
enabled=1





1：安装ngx_http_geoip_module模块
ngx_http_geoip_module：官方文档，参数需设置在位置在http模块中。

nginx默认情况下不构建此模块，应使用 –with-http_geoip_module 配置参数启用它。

对于ubuntu系统来说，直接安装 nginx-extras组件，包括几乎所有的模块。

`sudo apt install nginx-extras`


`yum install nginx-module-geoip`



2、下载 IP 数据库
此模块依赖于IP数据库，所有数据在此数据库中读取，所有还需要下载ip库（dat格式）。

MaxMind 提供了免费的 IP 地域数据库，坏消息是MaxMind 官方已经停止支持dat格式的ip库。

在其他地方可以找到dat格式的文件，或者老版本的，当然数据不可能最新，多少有误差。

第三方下载地址：https://www.miyuru.lk/geoiplegacy
下载同时包括Ipv4和Ipv6的country、city版本。

```
#下载国家IP库，解压并移动到nginx配置文件目录，
sudo wget --no-check-certificate https://dl.miyuru.lk/geoip/maxmind/country/maxmind.dat.gz
gunzip maxmind.dat.gz
sudo mv maxmind.dat /etc/nginx/GeoCountry.dat
 
sudo wget https://dl.miyuru.lk/geoip/maxmind/city/maxmind.dat.gz
gunzip maxmind.dat.gz
sudo mv maxmind.dat /etc/nginx/GeoCity.dat
```


### 安装 MaxMind 的 GeoIP 库

MaxMind 提供了免费的 IP 地域数据库（GeoIP.dat），不过这个数据库文件是二进制的，需要用 GeoIP 库来读取，所以除了要下载 GeoIP.dat 文件外（见下一步），还需要安装能读取这个文件的库。

```
# wget http://geolite.maxmind.com/download/geoip/api/c/GeoIP.tar.gz
# tar -zxvf GeoIP.tar.gz
# cd GeoIP-1.4.6
# ./configure
# make; make install
刚才安装的库自动安装到 /usr/local/lib 下，所以这个目录需要加到动态链接配置里面以便运行相关程序的时候能自动绑定到这个 GeoIP 库：

# echo '/usr/local/lib' > /etc/ld.so.conf.d/geoip.conf
# ldconfig
```

### 下载 IP 数据库

MaxMind 提供了免费的 IP 地域数据库，这个数据库是二进制的，不能用文本编辑器打开，需要上面的 GeoIP 库来读取：

```
# wget http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz
# gunzip GeoIP.dat.gz



geoip_country /etc/nginx/GeoCountry.dat;
geoip_city /etc/nginx/GeoCity.dat;
 
server {
    listen  80;
    server_name 144.11.11.33;
 
    location / {
      root  /var/www/html/;
      index index.html index.htm;
      if ($geoip_country_code = CN) {
              return 403;
         #中国地区，拒绝访问。返回403页面
        }
      }
 }
这里，地区国家基础设置就完成了。

Geoip其他参数：

国家相关参数：
$geoip_country_code #两位字符的英文国家码。如：CN, US
$geoip_country_code3 #三位字符的英文国家码。如：CHN, USA
$geoip_country_name #国家英文全称。如：China, United States
城市相关参数：
$geoip_city_country_code #也是两位字符的英文国家码。
$geoip_city_country_code3 #上同
$geoip_city_country_name #上同.
$geoip_region #这个经测试是两位数的数字，如杭州是02, 上海是 23。但是没有搜到相关资料，希望知道的朋友留言告之。
$geoip_city #城市的英文名称。如：Hangzhou
$geoip_postal_code #城市的邮政编码。经测试，国内这字段为空
$geoip_city_continent_code #不知什么用途，国内好像都是AS
$geoip_latitude #纬度
$geoip_longitude #经度

    map $geoip_country_code $allowed_country {
            default yes;
            #RU no;
            CN no;
            KOR no;
    }


        if ($geoip_country_code = CN) {
              return 403;
        }