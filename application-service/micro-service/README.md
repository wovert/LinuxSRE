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

