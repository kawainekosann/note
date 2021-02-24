# Log4j相关

[toc]

## 非web程序简单的配置

```xml
<dependency>
    <groupId>log4j</groupId>
    <artifactId>log4j</artifactId>
    <version>1.2.12</version>
</dependency>
```

### log4j.properties

```properties
### 设置###
log4j.rootLogger = debug,stdout,D,E

### 输出信息到控制抬 ###
log4j.appender.stdout = org.apache.log4j.ConsoleAppender
log4j.appender.stdout.Target = System.out
log4j.appender.stdout.layout = org.apache.log4j.PatternLayout
log4j.appender.stdout.layout.ConversionPattern = [%-5p] %d{yyyy-MM-dd HH:mm:ss,SSS} method:%l%n%m%n

### 输出DEBUG 级别以上的日志到=E://logs/error.log ###
log4j.appender.D = org.apache.log4j.DailyRollingFileAppender
log4j.appender.D.File = C://Users//LIUQI//Desktop//test//log/log.log
log4j.appender.D.Append = true
log4j.appender.D.Threshold = DEBUG 
log4j.appender.D.layout = org.apache.log4j.PatternLayout
log4j.appender.D.layout.ConversionPattern = %-d{yyyy-MM-dd HH:mm:ss}  [ %t:%r ] - [ %p ]  %m%n

### 输出INFO 级别以上的日志到=E://logs/error.log ###
log4j.appender.E = org.apache.log4j.DailyRollingFileAppender
log4j.appender.E.File =C://Users//LIUQI//Desktop//test//log/error.log 
log4j.appender.E.Append = true
log4j.appender.E.Threshold = INFO 
log4j.appender.E.layout = org.apache.log4j.PatternLayout
log4j.appender.E.layout.ConversionPattern = %-d{yyyy-MM-dd HH:mm:ss}  [ %t:%r ] - [ %p ]  %m%n
```

```java
//apache的包
import org.apache.log4j.Logger;
public class MapperTest {
    private Logger logger =  Logger.getLogger(this.getClass());
    @Test
    public void test1() throws IOException {
        InputStream resourceAsStream = Resources.getResourceAsStream("sqlMapConfig.xml");
        SqlSession sqlSession = new SqlSessionFactoryBuilder().build(resourceAsStream).openSession();
        UserMapper mapper = sqlSession.getMapper(UserMapper.class);
        User userCondition = new User();
        userCondition.setId(1);
        userCondition.setUserName("liuqi1");
        List<User> userList = mapper.findByCondition(userCondition);
        System.out.println(userList);
        //打印log
        logger.info(userList);
    }
}
```

mybatis打印日志

```xml
        <!--mybatis setting中添加-->
        <!-- sql 打印到控制台 -->
        <!-- <setting name="logImpl" value="STDOUT_LOGGING"/> -->
        <!-- mybatis sql打印到log4j文件-->
        <setting name="logImpl" value="LOG4J"/>
```



## Log4j简介

Log4j有三个主要的组件：Loggers(记录器)，Appenders (输出源)和Layouts(布局)。这里可简单理解为日志类别，日志要输出的地方和日志以何种形式输出。综合使用这三个组件可以轻松地记录信息的类型和级别，并可以在运行时控制日志输出的样式和位置

## 1. Loggers

Loggers组件在此系统中被分为五个级别：DEBUG、INFO、WARN、ERROR和FATAL。这五个级别是有顺序的，DEBUG < INFO < WARN < ERROR < FATAL，分别用来指定这条日志信息的重要程度，明白这一点很重要，Log4j有一个规则：只输出级别不低于设定级别的日志信息，假设Loggers级别设定为INFO，则INFO、WARN、ERROR和FATAL级别的日志信息都会输出，而级别比INFO低的DEBUG则不会输出。

## 2. Appenders

禁用和使用日志请求只是Log4j的基本功能，Log4j日志系统还提供许多强大的功能，比如允许把日志输出到不同的地方，如控制台（Console）、文件（Files）等，可以根据天数或者文件大小产生新的文件，可以以流的形式发送到其它地方等等。

常使用的类如下：

org.apache.log4j.ConsoleAppender（控制台）
org.apache.log4j.FileAppender（文件）
org.apache.log4j.DailyRollingFileAppender（每天产生一个日志文件）
org.apache.log4j.RollingFileAppender（文件大小到达指定尺寸的时候产生一个新的文件）
org.apache.log4j.WriterAppender（将日志信息以流格式发送到任意指定的地方）

配置模式：
log4j.appender.appenderName = className
log4j.appender.appenderName.Option1 = value1
…
log4j.appender.appenderName.OptionN = valueN

## 3. Layouts

有时用户希望根据自己的喜好格式化自己的日志输出，Log4j可以在Appenders的后面附加Layouts来完成这个功能。Layouts提供四种日志输出样式，如根据HTML样式、自由指定样式、包含日志级别与信息的样式和包含日志时间、线程、类别等信息的样式。

常使用的类如下：
org.apache.log4j.HTMLLayout（以HTML表格形式布局）
org.apache.log4j.PatternLayout（可以灵活地指定布局模式）
org.apache.log4j.SimpleLayout（包含日志信息的级别和信息字符串）
org.apache.log4j.TTCCLayout（包含日志产生的时间、线程、类别等信息）

配置模式：
log4j.appender.appenderName.layout =className
log4j.appender.appenderName.layout.Option1 = value1
…
log4j.appender.appenderName.layout.OptionN = valueN

## 二、配置详解

在实际应用中，要使Log4j在系统中运行须事先设定配置文件。配置文件事实上也就是对Logger、Appender及Layout进行相应设定。Log4j支持两种配置文件格式，一种是XML格式的文件，一种是properties属性文件。下面以properties属性文件为例介绍log4j.properties的配置。

### 1. 配置根Logger：

log4j.rootLogger = [ level ] , appenderName1, appenderName2, …
log4j.additivity.org.apache=false：表示Logger不会在父Logger的appender里输出，默认为true。
level ：设定日志记录的最低级别，可设的值有OFF、FATAL、ERROR、WARN、INFO、DEBUG、ALL或者自定义的级别，Log4j建议只使用中间四个级别。通过在这里设定级别，您可以控制应用程序中相应级别的日志信息的开关，比如在这里设定了INFO级别，则应用程序中所有DEBUG级别的日志信息将不会被打印出来。
appenderName：就是指定日志信息要输出到哪里。可以同时指定多个输出目的地，用逗号隔开。
例如：log4j.rootLogger＝INFO,A1,B2,C3

### 2. 配置日志信息输出目的地（appender）：

log4j.appender.appenderName = className
appenderName：自定义appderName，在log4j.rootLogger设置中使用；
className：可设值如下：

| 序号 | 值类型                                 | 值                                        | 属性值                                                       | 备注                                                         |
| ---- | -------------------------------------- | ----------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| 1    | 控制台                                 | org.apache.log4j.ConsoleAppender          | *Threshold=WARN* ：指定日志信息的最低输出级别，默认为DEBUG； *ImmediateFlush=true* ：表示所有消息都会被立即输出，设为false则不输出，默认值是true； *Target=System.err* ：默认值是System.out。 |                                                              |
| 2    | 文件                                   | org.apache.log4j.FileAppender             | *Threshold=WARN*; *ImmediateFlush=true*; *Append=false*：true表示消息增加到指定文件中，false则将消息覆盖指定的文件内容，默认值是true; *File=D:/logs/logging.log4j*：指定消息输出到logging.log4j文件中。 |                                                              |
| 3    | 根据具体时间生成日志文件               | org.apache.log4j.DailyRollingFileAppender | *Threshold=WARN*； *ImmediateFlush=true*； *Append=false*； *File=D:/logs/logging.log4j*； *DatePattern=’.'yyyy-MM*：每月滚动一次日志文件，即每月产生一个新的日志文件。当前月的日志文件名为logging.log4j，前一个月的日志文件名为logging.log4j.yyyy-MM。 | 另外，也可以指定按周、天、时、分等来滚动日志文件，对应的格式如下： ’.‘yyyy-MM：每月 ’.‘yyyy-ww：每周 ’.‘yyyy-MM-dd：每天 ’.‘yyyy-MM-dd-a：每天两次 ’.‘yyyy-MM-dd-HH：每小时 ’.'yyyy-MM-dd-HH-mm：每分钟 |
| 4    | 根据指定大小生成日志文件               | org.apache.log4j.RollingFileAppender      | *Threshold=WARN*； *ImmediateFlush=true*； *Append=false*； *File=D:/logs/logging.log4j*； *MaxFileSize=100KB*：后缀可以是KB, MB 或者GB。在日志文件到达该大小时，将会自动滚动，即将原来的内容移到logging.log4j.1文件中； *MaxBackupIndex=2*：指定可以产生的滚动文件的最大数，例如，设为2则可以产生logging.log4j.1，logging.log4j.2两个滚动文件和一个logging.log4j文件。 |                                                              |
| 5    | 将日志信息以流格式发送到任意指定的地方 | org.apache.log4j.WriterAppender           | ？                                                           |                                                              |

### 3. 配置日志信息的输出格式（Layout）：

log4j.appender.appenderName.layout=className
className：可设值如下：

| 序号 | 类型                                   | 值                             | 属性                                                         |
| ---- | -------------------------------------- | ------------------------------ | ------------------------------------------------------------ |
| 1    | 以HTML表格形式布局                     | org.apache.log4j.HTMLLayout    | *LocationInfo=true*：输出java文件名称和行号，默认值是false; *Title=My Logging*： 默认值是Log4J Log Messages。 |
| 2    | 可以灵活地指定布局模式                 | org.apache.log4j.PatternLayout | *ConversionPattern=%m%n*：设定以怎样的格式显示消息。         |
| 3    | 包含日志信息的级别和信息字符串         | org.apache.log4j.SimpleLayout  | ?                                                            |
| 4    | 包含日志产生的时间、线程、类别等等信息 | org.apache.log4j.TTCCLayout    | ?                                                            |

**格式化符号说明：**

| 符号 | 说明                                                         |
| ---- | ------------------------------------------------------------ |
| %p   | 输出日志信息的优先级，即DEBUG，INFO，WARN，ERROR，FATAL。    |
| %d   | 输出日志时间点的日期或时间，默认格式为ISO8601，也可以在其后指定格式，如：%d{yyyy/MM/dd HH:mm:ss,SSS}。 |
| %r   | 输出自应用程序启动到输出该log信息耗费的毫秒数。              |
| %t   | 输出产生该日志事件的线程名。                                 |
| %l   | 输出日志事件的发生位置，相当于%c.%M(%F:%L)的组合，包括类全名、方法、文件名以及在代码中的行数。 例如：test.TestLog4j.main(TestLog4j.java:10)。 |
| %c   | 输出日志信息所属的类目，通常就是所在类的全名。               |
| %M   | 输出产生日志信息的方法名。                                   |
| %F   | 输出日志消息产生时所在的文件名称。                           |
| %L   | 输出代码中的行号。                                           |
| %m   | 输出代码中指定的具体日志信息。                               |
| %n   | 输出一个回车换行符，Windows平台为"rn"，Unix平台为"n"。       |
| %x   | 输出和当前线程相关联的NDC(嵌套诊断环境)，尤其用到像java servlets这样的多客户多线程的应用中。 |
| %%   | 输出一个"%"字符。                                            |

另外，还可以在%与格式字符之间加上修饰符来控制其最小长度、最大长度、和文本的对齐方式。如：

- 1. c：指定输出category的名称，最小的长度是20，如果category的名称长度小于20的话，默认的情况下右对齐。
- 1. %-20c："-"号表示左对齐。
- 1. %.30c：指定输出category的名称，最大的长度是30，如果category的名称长度大于30的话，就会将左边多出的字符截掉，但小于30的话也不会补空格。

## 三、log4j.properties

### 1. log4j.properties配置代码

```properties
#Configure root Logger
log4j.rootLogger=DEBUG,console,D,E
#Indicates that Logger will not output in the appender of parent Logger, defaults to true
log4j.additivity.org.apache=false

############## console: console print ##################
log4j.appender.console=org.apache.log4j.ConsoleAppender
log4j.appender.console.Threshold=DEBUG
log4j.appender.console.Target=System.out
log4j.appender.console.layout=org.apache.log4j.PatternLayout
log4j.appender.console.layout.ConversionPattern=%d{yyyy-MM-dd HH:mm:ss,SSSSSS} [%-5p] [%l]:%m%n

############## D: DEBUG file save ##################
log4j.appender.D=org.apache.log4j.DailyRollingFileAppender
log4j.appender.D.Threshold=DEBUG
log4j.appender.D.ImmediateFlush=true
log4j.appender.D.Append=true
log4j.appender.D.File=${webapp.root}/WEB-INF/log/myweb.log
log4j.appender.D.DatePattern='.'yyyy-MM-dd
log4j.appender.D.layout=org.apache.log4j.PatternLayout
log4j.appender.D.layout.ConversionPattern=%d [%-5p] %l: %m %x %n

############## E: ERROR file save ##################
log4j.appender.E=org.apache.log4j.RollingFileAppender
log4j.appender.E.Threshold=ERROR
log4j.appender.E.ImmediateFlush=true
log4j.appender.E.Append=true
log4j.appender.E.File=${webapp.root}/WEB-INF/log/error.log
log4j.appender.E.MaxFileSize=100KB
log4j.appender.E.MaxBackupIndex=50
log4j.appender.E.layout=org.apache.log4j.PatternLayout
log4j.appender.E.layout.ConversionPattern=[%-5p] %d{yyyy-MM-dd HH:mm:ss,SSSSSS} [%r<--->%t] [%l]:%m --> %x %n
```

其中${webapp.root}为javaweb项目根路径

**注**：
系统默认把web目录的路径压入一个叫webapp.root的系统变量中。

手动更改方式如下：
在web.xml 中配置

```xml
<!-- 配置javaweb项目根目录参数 key 名称 -->
<context-param>     
    <param-name>webAppRootKey</param-name>     
    <param-value>myweb.root</param-value>     
</context-param> 
```

### 2. javaweb项目SSM框架集成配置代码

仅需在 **web.xml** 中添加如下代码：

```xml
	<!--log4j配置文件加载 -->
	<context-param>
		<param-name>log4jConfigLocation</param-name>
		<param-value>classpath:config/log4j.properties</param-value>
	</context-param>

	<!--spring log4j监听器 -->
	<listener>
		<listener-class>org.springframework.web.util.Log4jConfigListener</listener-class>
	</listener>
```

### 3. Mybatis框架控制台打印SQL

在Mybatis配置文件中添加如下代码可实现

```xml
	<settings>
        <!-- 打印sql日志 -->
        <setting name="logImpl" value="STDOUT_LOGGING" />
    </settings>
```

mybatis的日志打印方式比较多，SLF4J | LOG4J | LOG4J2 | JDK_LOGGING | COMMONS_LOGGING | STDOUT_LOGGING | NO_LOGGING，可以根据自己的需要进行配置

**SpringBoot** application.properties 配置

\#设置包下日志打印类型 ，不设置默认sql语句不打印
logging.level.com.xxx.service=INFO
logging.level.com.xxx.dao=DEBUG
\#设置日志打印目录和名称
logging.file=logs/xxx.log