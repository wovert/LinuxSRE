# 微服务

## 单体架构 VS 微服务

|  | 传统单体架构 |  分布式微服务架构
|  ---- |  :---- |  ----
|  新功能开发 |  需要时间  | 容器开发和实践
|  部署 |  不经常，容易部署  | 经常发布，部署复杂
|  隔离型 |  故障影响范围大  | 故障影响范围小
|  架构设计 |  初期设计选型难度大  | 设计逻辑难度大
|  系统性能 |  响应时间快，吞吐量小  | 响应时间慢，吞吐量大
|  系统运维 |  简单  | 复杂
|  新人上手 |  学习曲线大（应用逻辑）  | 学习曲线大（架构逻辑）
|  技术 |  单一，封闭  | 技术多样，开放
|  测试和差错 |  简单  | 复杂（每个服务都要进行单独测试，集群测试）
|  系统扩展性 |  差  | 优
|  系统管理 |  重点在于开发成本  | 重点在于服务治理和调度

## 为什么使用微服务架构

- 开发简单
- 快速响应需求变化
- 随时随地更新
- 系统更加稳定可靠

## 微服务组建

- 跨语言、跨平台和通信格式: **protobuf**
- 通信协议：**gRPC**
- 调度管理服务发现：**consul**
- 微服务框架：**micro**
- 部署：**docker**

### protobuf

> **平台无关，语言无关，可扩展的序列化数据结构格式，可用于通讯协议和数据存储等领域**。适合用做数据存储和作用为不同应用，不同语言之间相互通信的数据交换格式，只要实现相同的协议格式即统一proto文件被编译成不同的语言版本，加入到各自的工程中去。不同语言可以解析其他语言通过 protobuf 序列化的数据。目前官网提供 C++, Python, Java, Go 等语言的支持。Google 在2008年7月7日将其作为开源项目对外公布。

### 数据交换格式比较

- json
  - Web项目
  - 可读性好
- xml
  - 数据冗余
- protobuf
  - 高性能
  - 对响应速度有要求的数据传输场景
  - protobuf 二进制数据格式，需要编码和解码
  - 数据不具有可读性，只有反序列化得到真正的可读数据

#### protobuf 优势

- 序列化后**体积**相比JSON和XML**很小**，适合网络传输
- 支持**跨平台**多语言
- **消息格式**升级和**兼容性**还不错
- **序列化反序列化速度很快**，快于JSON的处理速度
- 自定义数据结构

## Protobuf 安装

```sh
# donwload protbuf
$ git clone https://github.com/protocolbuffers/protobuf.git
$ unzip protobuf.zip

#安装依赖库
$ sudo apt-get install autoconf automake libtool curl make g++ unzip libffi-dev -y

#安装
$ cd protobuf/
$ ./autoen.sh
$ ./configure
$ make
$ sudo make install

#刷新共享库
$ sudo ldconfig

#安装是比较卡，成功后需要使用命令测试
$ protoc --version
```

### 获取 proto 包

```sh
#Go语言的proto API接口，-u:依赖包
$ go get -v -u github.com/golang/protobuf/proto
```

### protoc-gen-go 插件

是 go程序，编译之后将可执行文件复制到 `\bin` 目录

```sh
#安装
$ go get -v -u github.com/golang/protobuf/protoc-gen-go
#编译
$ cd $GOPATH/src/github.com/golang/protobuf/protoc-gen-go/
$ go build
 
#将生成的 protoc-gen-go 可执行文件，放在 /bin 目录下
$ sudo cp protoc-gen-go /bin/
```

### protobuf 语法

定义 protobuf 文件

```
syntax = "proto3";
message PandaRequest {
  string name = 1;
  int32 height = 2;
  repeated int32 weight = 3;
}
```

没有指定syntax，默认编译器会使用proto2，语法行必须是文件的非空非注释的第一个行

Repeated 表示重复的那么在重复的那么在Go语言中切片进行代表

## grpc


### 环境搭建

```sh
$ git clone https://github.com/golang/tools.git

#x.zip解压到 $GOPATH/src/golang.org/x 目录下
$ unzip x.zip -d /GOPATH/src/golang.org/x

#将google.golang.org.zip 解压到 $GOPATH/src/google.golang.org 目录下
```


官方的安装方法是 go get -u google.golang.org/grpc ,但是没有 fq 的 同学是不行的。。所以只能曲线救国了。
具体思路就是我们 从git上 克隆 grpc 的各种 依赖库 ，然后 移到我们 的 GOPATH 目录下面。(网上找的代码，亲测有效）。

```sh
$ git clone https://github.com/grpc/grpc-go.git        $GOPATH/src/google.golang.org/grpc
$ git clone https://github.com/golang/net.git          $GOPATH/src/golang.org/x/net
$ git clone https://github.com/golang/text.git         $GOPATH/src/golang.org/x/text
$ git clone https://github.com/google/go-genproto.git  $GOPATH/src/google.golang.org/genproto
$ cd $GOPATH/src/
$ go install google.golang.org/grpc
```

### 启动服务端

```sh

```

### 启动客户端

## consul 

> 服务网格（微服务间的 TCP/IP，负责服务之间的网络调用、限流、熔断和监控）解决方案，它是一个一个分布式的，高度可用的系统，而且开发使用都很简便。它提供了一个功能齐全的控制平面，主要特点是：服务发现、健康检查、键值存储、安全服务通信、多数据中心

### consul 安装

```sh
$ wget https://releases.hashicorp.com/consul/1.2.0/consul_1.2.0_linux_amd64.zip
$ unzip consul_1.2.0_linux_amd64.zip
$ sudo mv consul /usr/local/bin/

#其他版本下载地址：https://www.consul.io/downloads.html

#验证安装
$ consul
```


## micro

> 分布式系统开发的微服务生态系统，是一个工具集合。通过将微服务架构抽象成一组工具。隐藏了分布式系统的复杂性，为开发人员提供了更简洁的概念。

### micro 环境安装

#### 下载 micro

```sh
$ go get -u -v github.com/go-log/log
$ go get -u -v github.com/gorilla/handlers
$ go get -u -v github.com/gorilla/mux
$ go get -u -v github.com/gorilla/websocket

$ go get -u -v github.com/mitchellh/hashstructure
$ go get -u -v github.com/nlopes/slack
$ go get -u -v github.com/pborman/uuid
$ go get -u -v github.com/pkg/errors
$ go get -u -v github.com/serenize/snaker

# hashicorp_consul.zip 包解压在 github.com/hashicorp/consul
$ unzip hashicorp_consul.zip -d gihtub.com/hashicorp/consul

# miekg_dns.zip 包解压在 github.com/miekg/dns
$ unzip miekg_dns.zip -d github.com/miekg/dns

$ go get github.com/micro/micro
```

#### 编译安装 micro

```sh
$ cd $GOPATH/src/github.com/micro/micro
$ go build -o micro main.go
$ sudo cp micro /bin/
```

#### 插件安装

```sh
$ go get -u github.com/golang/protobuf/{proto,protoc-gen-go}
$ go get -u github.com/micro/protoc-gen-micro
```

### 创建微服务命令详解

```sh
#创建通过指定相对于 $GOPATH 的目录路径，创建一个新的微服务
new Create a new Micro service by specifiying a diretory path relative to your $GOPATH

#用法
USAGE:
micro new [command options][arguments ...]

#服务的命名空间
--namespace "go.micro"    Namespace for the service e.g com.example

#服务类型
--type "srv"              Type of service e.g api, fnc, srv, web

#服务的正式定义全面
--fqdn                    FQDN of service e.g com.example.srv.service(defaults to namespace.type.alias)

#别名是在指定时作为组合名的一部分使用的短名称
--alias                   Alias is the short name used as part of combined name if specified

#运行这个服务时间
run                       Run the micro runtime
```

##### 创建两个服务

```sh

```