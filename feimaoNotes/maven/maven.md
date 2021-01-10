# Maven教程

[toc]

## Maven的安装与配置

1. 安装地址：http://maven.apache.org/download.cgi  ，下载完成后，直接用解压工具解压到自己的一个空目录

2. **配置 MAVEN_HOME**。在系统环境变量中添加 MAVEN_HOME，添加path

    1. windows：MAVEN_HOME定位到解压后的文件夹地址；path添加 %MAVEN_HOME%/bin
2. linux：
       vi /etc/profile
       export MAVEN_HOME=Maven路径
       export PATH=$MAVEN_HOME/bin:$PATH
       配置文件重新加载  source /etc/profile 
    3. MacOS：
       vim ~/.bash_profile
       export M2_HOME="/Users/zwf/apache-maven-3.6.1"
       export PATH="$M2_HOME/bin:$PATH"
       配置文件重新加载  source ~/.bash_profile 
   
    控制台 mvn-v 查看是否安装成功

## Maven的目录结构与内容
### 1）bin
该目录包含了 mvn 运行的脚本，这些脚本用来配置 Java 命令，准备好 classpath 和相关的 Java 系统属性，然后执行 Java 命令。
其中 mvn 是基于 UNIX 平台的 shell 脚本，mvn.bat 是基于 Windows 平台的 bat 脚本。在命令行输入任何一条 mvn 命令时，实际上就是在调用这些脚本。
该目录还包含了 mvnDebug 和 mvnDebug.bat 两个文件，同样，前者是 UNIX 平台的 shell 脚本，后者是 Windows 平台的 bat 脚本。那么 mvn 和 mvnDebug 有什么区别和关系呢？
打开文件我们就可以看到，两者基本是一样的，只是 mvnDebug 多了一条 MAVEN_DEBUG_OPTS 配置，其作用就是在运行 Maven 时开启 debug，以便调试 Maven 本身。
此外，该目录还包含 m2.conf 文件，这是 classworlds 的配置文件，后面会介绍 classworlds。
### 2）boot
该目录只包含一个文件，以 maven 3.3.9 为例，该文件为 plexus-classworlds-2.5.2.jar。
plexus-classworlds 是一个类加载器框架，相对于默认的 java 类加载器，它提供了更丰富的语法以方便配置，Maven 使用该框架加载自己的类库。
更多关于 classworlds 的信息请参考 http://classworlds.codehaus.org/。对于一般的 Maven 用户来说，不必关心该文件。

### 3）conf
该目录包含了一个非常重要的文件 settings.xml。直接修改该文件，就能在机器上全局地定制 Maven 的行为。
一般情况下，我们更偏向于复制该文件至 ～/.m2/ 目录下（～表示用户目录），然后修改该文件，在用户范围定制 Maven 的行为。后面将会多次提到 settings.xml，并逐步分析其中的各个元素。

### 4）lib
该目录包含了所有 Maven 运行时需要的 Java 类库，Maven 本身是分模块开发的，因此用户能看到诸如 maven-core-3.0.jar、maven-model-3.0.jar 之类的文件。
此外，这里还包含一些 Maven 用到的第三方依赖，如 common-cli-1.2.jar、commons-lang-2.6.jar 等。
对于 Maven 2 来说，该目录只包含一个如 maven-2.2.1-uber.jar 的文件，原本各为独立 JAR 文件的 Maven 模块和第三方类库都被拆解后重新合并到了这个 JAR 文件中。可以说，lib 目录就是真正的 Maven。
关于该文件，还有一点值得一提的是，用户可以在这个目录中找到 Maven 内置的超级 POM，这一点教程后面会详细解释。
### 5）LICENSE.txt
记录了 Maven 使用的软件许可证Apache License Version 2.0。
### 6）NOTICE.txt
记录了 Maven 包含的第三方软件。
### 7）README.txt
包含了 Maven 的简要介绍，包括安装需求及如何安装的简要指令等。

## Maven配置文件

###   Maven启用代理访问
​	找到文件 {M2_HOME}/conf/settings.xml,
​	取消注释代理选项，填写您的代理服务器的详细信息。

```xml
<!-- proxies
   | This is a list of proxies which can be used on this machine to connect to the network.
   | Unless otherwise specified (by system property or command-line switch), the first proxy
   | specification in this list marked as active will be used.
   |-->
  <proxies>
      <proxy>
      <id>optional</id>
      <active>true</active>
      <protocol>http</protocol>
      <username>yiibai</username>
      <password>password</password>
      <host>proxy.yiibai.com</host>
      <port>8888</port>
      <nonProxyHosts>local.net|some.host.com</nonProxyHosts>
    </proxy>
  </proxies>
```

### Maven换源

找到文件 {M2_HOME}/conf/settings.xml,

添加阿里源 ，找到  </ mirrors>标签，标签中添加mirror子节点，内容如下：

```xml
<mirror>
    <id>aliyunmaven</id>
    <mirrorOf>*</mirrorOf>
    <name>阿里云公共仓库</name>
    <url>https://maven.aliyun.com/repository/public</url>
</mirror>
```



## Maven本地资源库

默认情况下，Maven的本地资源库默认为用户下的 .m2 目录文件夹：

1. ​		Unix/Mac OS X – ~/.m2 
2. ​		Windows – C:\Documents and Settings\{your-username}\.m2

### 更新Maven本地库

找到 {M2_HOME}\conf\setting.xml, 更新 localRepository 到其它名称。



## Maven中央存储库

当你建立一个 Maven 的项目，Maven 会检查你的 pom.xml 文件，以确定哪些依赖下载。首先，Maven 将从本地资源库获得 Maven 的本地资源库依赖资源，如果没有找到，然后把它会从默认的 Maven 中央存储库 – [http://repo1.maven.org/maven2/](http://repo1.maven.org/maven/) 查找下载。

Maven中心储存库网站已经改版本，目录浏览可能不再使用。这将直接被重定向到 http://search.maven.org/



## Maven远程仓库

添加依赖
org.jvnet.localizer 只适用于 Java.net资源库(https://maven.java.net/content/repositories/public/) 
pom.xml

```xml
<dependency>
        <groupId>org.jvnet.localizer</groupId>
        <artifactId>localizer</artifactId>
        <version>1.8</version>
</dependency>
```

默认情况下，Maven从Maven中央仓库下载所有依赖关系。但中央仓库丢失的情况下，就需要添加远程仓库。

添加Java.net远程仓库的详细信息在“pom.xml”文件。 pom.xml 

```xml
<project ...>
<repositories>
    <repository>
      <id>java.net</id>
      <url>https://maven.java.net/content/repositories/public/</url>
    </repository>
 </repositories>
</project>
```

Maven的依赖库查询顺序为：

1. 在 Maven 本地资源库中搜索，如果没有找到，进入第 2 步，否则退出。 
2. 在 Maven 中央存储库搜索，如果没有找到，进入第 3 步，否则退出。 
3. 在java.net Maven的远程存储库搜索，如果没有找到，提示错误信息，否则退出



## Maven依赖机制
假设你想使用 Log4j 作为项目的日志。
### 	1.在传统方式
1. 访问 http://logging.apache.org/log4j/  
2. 下载 Log4 j的 jar 库 
3. 复制 jar 到项目类路径 
4. 手动将其包含到项目的依赖 
5. 所有的管理需要一切由自己做 

​	如果有 Log4j 版本升级，则需要重复上述步骤一次。

### 	2. 在Maven的方式
1. 你需要知道 log4j 的 Maven 坐标，例如：

   ```xml
   <groupId>log4j</groupId>
   <artifactId>log4j</artifactId>
   <version>1.2.14</version>
   ```

2. 它会自动下载 log4j 的1.2.14 版本库。如果“version”标签被忽略，它会自动升级库时当有新的版本时。 	

3. 声明 Maven 的坐标转换成 pom.xml 文件。

   ```xml
   <dependencies>
       <dependency>
   	<groupId>log4j</groupId>
   	<artifactId>log4j</artifactId>
   	<version>1.2.14</version>
       </dependency>
   </dependencies>
   ```

4. 当 Maven 编译或构建，log4j 的 jar 会自动下载，并把它放到 Maven 本地存储库 

5. 所有由 Maven 管理

**如何找到 Maven 坐标？
 访问 Maven 中心储存库，搜索下载您想要的jar。**



## 定制库到Maven本地资源

这里有2个案例，需要手动发出Maven命令包括一个 jar 到 Maven 的本地资源库。
1. 要使用的 jar 不存在于 Maven 的中心储存库中。 
2. 您创建了一个自定义的 jar ，而另一个 Maven 项目需要使用。 
> PS，还是有很多 jar 不支持 Maven 的。

### 	案例学习
例如，kaptcha，它是一个流行的第三方Java库，它被用来生成 “验证码” 的图片，以阻止垃圾邮件，但它不在 Maven 的中央仓库中。

### 	1. mvn 安装
​	下载 “kaptcha”，将其解压缩并将 kaptcha-version.jar 复制到其他地方，比如：C盘。发出下面的命令：

```
mvn install:install-file -Dfile=c:\kaptcha-{version}.jar -DgroupId=com.google.code -DartifactId=kaptcha -Dversion={version} -Dpackaging=jar
```

​	示例：

```
D:\>mvn install:install-file -Dfile=c:\kaptcha-2.3.jar -DgroupId=com.google.code 
-DartifactId=kaptcha -Dversion=2.3 -Dpackaging=jar
[INFO] Scanning for projects...
[INFO] Searching repository for plugin with prefix: 'install'.
[INFO] ------------------------------------------------------------------------
[INFO] Building Maven Default Project
[INFO]    task-segment: [install:install-file] (aggregator-style)
[INFO] ------------------------------------------------------------------------
[INFO] [install:install-file]
[INFO] Installing c:\kaptcha-2.3.jar to 
D:\maven_repo\com\google\code\kaptcha\2.3\kaptcha-2.3.jar
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESSFUL
[INFO] ------------------------------------------------------------------------
[INFO] Total time: < 1 second
[INFO] Finished at: Tue May 12 13:41:42 SGT 2014
[INFO] Final Memory: 3M/6M
[INFO] ------------------------------------------------------------------------
```

​	现在，“kaptcha” jar被复制到 Maven 本地存储库。

### 	2. pom.xml

​	安装完毕后，就在 pom.xml 中声明 kaptcha 的坐标。

```xml
<dependency>
      <groupId>com.google.code</groupId>
      <artifactId>kaptcha</artifactId>
      <version>2.3</version>
 </dependency>
```























