# Mybatis相关



## 原始jdbc操作的分析

原始jdbc操作开发存在的问题如下：

1. 数据库连接创建，释放频繁造成的系统资源浪费从而影响系统性能
2. sql语句在代码中硬编码，造成代码不易维护，实际应用sql变化的可能较大，sql变动需要改变Java代码
3. 查询操作时，需要手动将结果集中的数据手动封装到实体中，插入数据时需要手动将实体的数据库设置到sql的占位符位置

应对上述问题给出的解决方案：

1. 使用数据库连接池初始化连接资源
2. 将sql语句抽取到xml配置文件中
3. 使用反射，内省等底层技术，自动将实体与表进行属性与字段的自动映射



## 什么是mybatis

* mybatis是一个基于java的持久层框架，它内部封装了jdbc，使开发者只需要关注sql语句本身，不需要花费精力去加载驱动，创建连接创建statement繁琐的过程
* mybatis通过xml或者注解的方式将要执行的各种statement配置起来并通过Java对象和statement中sql动态参数进行映射生成最终指向的sql语句
* 最后mybatis框架指向sql并将结果映射为Java对象并返回，采用ORM的思想解决了食堂和数据库映射的问题，对jdbc进行了封装，屏蔽了jdbc api底层访问的细节，使我们不用与jdbc api打交道，就可以完成对数据库的持久化操作

## mybatis开发步骤

### 查询操作

1. 添加mybatis坐标。

   ```xml
           <dependency>
               <groupId>mysql</groupId>
               <artifactId>mysql-connector-java</artifactId>
               <version>8.0.23</version>
           </dependency>
           <dependency>
               <groupId>org.mybatis</groupId>
               <artifactId>mybatis</artifactId>
               <version>3.4.6</version>
           </dependency>
   ```

2. 创建user数据表

   ```sql
   DROP TABLE IF EXISTS `user`;
   CREATE TABLE `user` (
     `id` int NOT NULL AUTO_INCREMENT,
     `username` varchar(30) DEFAULT NULL,
     `password` varchar(30) DEFAULT NULL,
     PRIMARY KEY (`id`)
   ) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
   SET FOREIGN_KEY_CHECKS = 1;
   ```

3. 编写User实体类

      ```java
      public class User {
          private int id;
          private String userName;
          private String passWord;
          public int getId() {
              return id;
          }
          public void setId(int id) {
              this.id = id;
          }
          public String getUserName() {
              return userName;
          }
          public void setUserName(String userName) {
              this.userName = userName;
          }
          public String getPassWord() {
              return passWord;
          }
          public void setPassWord(String passWord) {
              this.passWord = passWord;
          }
          @Override
          public String toString() {
              return "User{" +
                      "id=" + id +
                      ", userName='" + userName + '\'' +
                      ", passWord='" + passWord + '\'' +
                      '}';
          }
      }
      
      ```

4. 编写映射文件UserMapper.xml

   ```xml
   <?xml version="1.0" encoding="UTF-8" ?>
   <!DOCTYPE mapper
           PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
           "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
   <!--命名空间，与下面的id组成查询标志 查询操作-->
   <mapper namespace="userMapper">
       <select id="findAll" resultType="com.kawainekosann.domain.User">
           select * from user
       </select>
   </mapper>
   ```

5. 编写核心文件sqlMapConfig.xml

   ```xml
   <?xml version="1.0" encoding="UTF-8" ?>
   <!DOCTYPE configuration
           PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
           "http://mybatis.org/dtd/mybatis-3-config.dtd">
   <!--约束头，这样我们写标签时就会自动提式-->
   <configuration>
       <!--数据源环境-->
       <environments default="development">
           <environment id="development">
               <transactionManager type="JDBC"></transactionManager>
               <dataSource type="POOLED">
                   <property name="driver" value="com.mysql.jdbc.Driver"/>
                   <property name="url" value="jdbc:mysql://localhost:3306/test"/>
                   <property name="username" value="root"/>
                   <property name="password" value="67iwxh1314"/>
               </dataSource>
           </environment>
       </environments>
   
       <!--加载映射文件-->
       <mappers>
           <mapper resource="com/kawainekosann/mapper/UserMapper.xml"></mapper>
       </mappers>
   </configuration>
   ```

6. 编写测试类

   ```java
       @Test
       public void test1() throws IOException {
           //获得核心配置文件
           InputStream resourceAsStream = Resources.getResourceAsStream("sqlMapConfig.xml");
           //获得session工厂对象
           SqlSessionFactory sqlSessionFactory= new SqlSessionFactoryBuilder().build(resourceAsStream);
           //获得会话对象
           SqlSession sqlSession = sqlSessionFactory.openSession();
           //执行操作 参数 namespace+id
           List<User> userList = sqlSession.selectList("userMapper.findAll");
           System.out.println(userList);
           //释放资源
           sqlSession.close();
       }
   ```

### 插入操作

注意点：

* 插入语句使用insert标签
* 在映射文件中使用parameterType属性指定要插入的数据类型
* sql语句中使用`#{实体类属性名}`引用实体中的属性值
* 插入操作的API是`sqlSession.insert("命名空间.id", 实体对象);`
* 插入操作设计数据库变化，所以要提交事务`sqlSession.commit();`

```java
    @Test
    public void test2() throws IOException {
        //获得核心配置文件
        InputStream resourceAsStream = Resources.getResourceAsStream("sqlMapConfig.xml");
        //获得session工厂对象
        SqlSessionFactory sqlSessionFactory = new SqlSessionFactoryBuilder().build(resourceAsStream);
        //获得会话对象
        SqlSession sqlSession = sqlSessionFactory.openSession();
        //模拟User对象
        User user = new User();
        user.setUserName("liuqi4");
        user.setPassWord("44444444");
        //执行操作 参数 namespace+id
        sqlSession.insert("userMapper.save", user);
        //默认是事务 不提交，这里要提交才有效果
        sqlSession.commit();
        //释放资源
        sqlSession.close();
    }
```

```xml
    <!--插入操作-->
    <insert id="save" parameterType="com.kawainekosann.domain.User">
        insert into user values(#{id},#{userName},#{passWord})
    </insert>
```

### 修改操作

注意点：

* 修改语句使用update标签
* 修改操作使用的API是`sqlSession.update("命名空间.id", 实体对象);`

```java
    @Test
    public void test3() throws IOException {
        //获得核心配置文件
        InputStream resourceAsStream = Resources.getResourceAsStream("sqlMapConfig.xml");
        //获得session工厂对象
        SqlSessionFactory sqlSessionFactory = new SqlSessionFactoryBuilder().build(resourceAsStream);
        //获得会话对象
        SqlSession sqlSession = sqlSessionFactory.openSession();
        //模拟User对象
        User user = new User();
        user.setId(4);
        user.setUserName("liuqi4");
        user.setPassWord("44444444");
        //执行操作 参数 namespace+id
        sqlSession.update("userMapper.update", user);
        //默认是事务 不提交，这里要提交才有效果
        sqlSession.commit();
        //释放资源
        sqlSession.close();
    }
```

```xml
    <!--修改操作-->
    <update id="update" parameterType="com.kawainekosann.domain.User">
        update user set username=#{userName},password=#{passWord} where id=#{id}
    </update>
```



### 删除操作

注意点：

* 删除语句使用delete标签
* sql中使用`#{任意字符串}`方式引入传递的单个参数
* 删除操作使用的是`sqlSession.delete("命名空间.id", Object);`

```java
    @Test
    public void test4() throws IOException {
        //获得核心配置文件
        InputStream resourceAsStream = Resources.getResourceAsStream("sqlMapConfig.xml");
        //获得session工厂对象
        SqlSessionFactory sqlSessionFactory = new SqlSessionFactoryBuilder().build(resourceAsStream);
        //获得会话对象
        SqlSession sqlSession = sqlSessionFactory.openSession();
        //执行操作 参数 namespace+id
        sqlSession.delete("userMapper.delete", 5);
        //默认是事务 不提交，这里要提交才有效果
        sqlSession.commit();
        //释放资源
        sqlSession.close();
    }
```

```xml
    <!--删除操作-->
    <delete id="delete" parameterType="java.lang.Integer">
        delete from user where id=#{id}
    </delete>
```



## Mybatis核心配置文件概述

### mybatis核心配置文件的层级关系

* configuration配置
  	* properties 属性
  	* settings 设置
  	* typeAliases 类型别名
  	* typeHandlers 类型处理器
  	* objectFactory 对象工厂
  	* plugins 插件
   * environments 环境
      * environment 环境变量
        	* transactionManager 事务管理器
        	* dataSource 数据源
  * databaseIdProvider 数据库厂商标识
  * mappers 映射器

### environment标签

```xml
<!--数据源环境 default指定默认环境名称-->
    <environments default="development">
        <!--指定当前环境名称-->
        <environment id="development">
            <!--指定事务管理类型是JDBC-->
            <transactionManager type="JDBC"></transactionManager>
            <!--指定数据源类型是连接池-->
            <dataSource type="POOLED">
                <!--数据源基本配置-->
                <property name="driver" value="com.mysql.jdbc.Driver"/>
                <property name="url" value="jdbc:mysql://localhost:3306/test"/>
                <property name="username" value="root"/>
                <property name="password" value="67iwxh1314"/>
            </dataSource>
        </environment>
    </environments>
```

其中事务管理器`transactionManager`有两种

* JDBC：这个配置就是直接使用了JDBC的提交和回滚设置，它依赖于从数据源得到的连接来管理事务作用域
* MANAGED：这还配置几乎没做什么，它从不提交或回滚一个连接，而是让容器来管理事务的整个生命周期(比如JEE应用服务器的上下文)。默认情况下他会关闭连接，然而一些容器并不希望这样，因此需要将closeConnection属性设置为false来阻止它默认的关闭行为

其中数据源`dataSource`有三种

* UNPOOLED：这个数据源的实现只是每次被请求时打开和关闭连接。
* POOLED：这种数据源的实现利用“池”的概念将JDBC对象组织起来
* JNDI：这个数据源的实现是为了能在诸如EJB或应用服务器这类容器中使用，容器可以集中在外部配置数据源，然后放置一个JNDI上下文的引用



### mapper标签

该标签的作用是加载映射的，加载的方式有如下几种

* 使用相对于类路径的资源引用，例如：`<mapper resource="com/kawainekosann/mapper/UserMapper.xml"></mapper>`
* 使用完全限定资源定位符（URL）例如：`<mapper url="file:///var/mappers/SuthorMapper.xml"`
* 使用映射器接口实现类的完全限定类名 例如 `<mapper class="org.mybatis.builder.AuthorMapper"`
* 将包内的映射器接口实现全部注册为映射器 例如 `<package name="org.mybatis.builder"`

### properties标签

实际开发中，习惯将数据源配置信息单独抽取成一个properties文件，该标签可以加载额外配置的properties文件

```xml
<!--加载外部配置文件-->
    <properties resource="jdbc.properties"></properties>
    <!--数据源环境 default指定默认环境名称-->
    <environments default="development">
        <!--指定当前环境名称-->
        <environment id="development">
            <!--指定事务管理类型是JDBC-->
            <transactionManager type="JDBC"></transactionManager>
            <!--指定数据源类型是连接池-->
            <dataSource type="POOLED">
                <!--数据源基本配置-->
                <property name="driver" value="${jdbc.driver}"/>
                <property name="url" value="${jdbc.url}"/>
                <property name="username" value="${jdbc.username}"/>
                <property name="password" value="${jdbc.password}"/>
            </dataSource>
        </environment>
    </environments>
```



### typeAliases标签

类型别名是Java类型设置一个短的名字。原来的类型名称配置如下

```xml
    <select id="findAll" resultType="com.kawainekosann.domain.User">
        select * from user
    </select>
```

配置typeAliases 为类定义别名

```xml
    <!--别名-->
    <typeAliases>
        <typeAlias type="com.kawainekosann.domain.User" alias="user"></typeAlias>
    </typeAliases>
```

```xml
    <!--查询操作-->
    <select id="findAll" resultType="user">
        select * from user
    </select>
```

上面是我们自定义的别名，mybatis已经帮我们设置好了一些常用类型的别名如：

| String   | String   |
| -------- | -------- |
| long     | Long     |
| int      | Integer  |
| double   | Double   |
| Boolean  | Boolean  |
| ........ | ........ |



## Mybatis相应API

### SqlSession工厂构建器SqlSessionBuilder

常用API：`SqlSessionFactory build(InputStream inputStream)`
通过加载mybatis的核心文件的输入流的形式构建一个SqlSessionFactory对象

```java
        //获得核心配置文件
        InputStream resourceAsStream = Resources.getResourceAsStream("sqlMapConfig.xml");
        //获得session工厂对象
        SqlSessionFactory sqlSessionFactory = new SqlSessionFactoryBuilder().build(resourceAsStream);
```

其中,Resources工具类，这个类在org.apache.ibats.io包中。Resource类帮助你从类路径下，文件系统或者一个web URL中加载资源文件



### SqlSession工厂对象 SqlSessionFactory

SqlSessionFactory有多个方法创建SqlSession实例，常用的方法有如下两个：

| openSession                     | 会默认开启一个事务，但事务不会自动提交，也就意味着需要手动提交该事务，更新操作数据才会持久化到数据库中 |
| ------------------------------- | ------------------------------------------------------------ |
| openSession(boolean autoCommit) | 参数为是否自动提交，如果设置为true，那么不需要手动提交事务   |



### SqlSession会话对象

SqlSession实例在Mybatis中是一个非常强大的类。在这里你会看到所有执行语句，提交或回滚事务和获取映射器实例的方法

执行语句的方法主要有：

`selectOne`,`selectList`,`insert`,`update`,`delete`

```java
    @Test
    public void test5() throws IOException {
        //获得核心配置文件
        InputStream resourceAsStream = Resources.getResourceAsStream("sqlMapConfig.xml");
        //获得session工厂对象
        SqlSessionFactory sqlSessionFactory = new SqlSessionFactoryBuilder().build(resourceAsStream);
        //获得会话对象
        SqlSession sqlSession = sqlSessionFactory.openSession();
        //执行操作 参数 namespace+id
        User user = sqlSession.selectOne("userMapper.findById", 4);
        System.out.println(user);
        //释放资源
        sqlSession.close();
    }
```



操作事务的方法主要有：

`commit`,`rollback`



## Mybatis的DAO层实现

### 传统开发方式

传统UserDao接口

```xml
    <dependencies>
        <dependency>
            <groupId>postgresql</groupId>
            <artifactId>postgresql</artifactId>
            <version>9.1-901.jdbc4</version>
        </dependency>
        <dependency>
            <groupId>mysql</groupId>
            <artifactId>mysql-connector-java</artifactId>
            <version>8.0.23</version>
        </dependency>
        <dependency>
            <groupId>org.mybatis</groupId>
            <artifactId>mybatis</artifactId>
            <version>3.4.6</version>
        </dependency>
        <dependency>
            <groupId>junit</groupId>
            <artifactId>junit</artifactId>
            <version>4.13</version>
            <scope>test</scope>
        </dependency>
        <dependency>
            <groupId>log4j</groupId>
            <artifactId>log4j</artifactId>
            <version>1.2.12</version>
        </dependency>
    </dependencies>
```

```properties
#jdbc.driver=com.mysql.jdbc.Driver
#jdbc.url=jdbc:mysql://localhost:3306/test?useUnicode=true&characterEncoding=utf8
#jdbc.username=root
#jdbc.password=67iwxh1314

jdbc.driver=org.postgresql.Driver
jdbc.url=jdbc:postgresql://localhost:5432/test
jdbc.username=postgres
jdbc.password=postgres
```

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE configuration
        PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-config.dtd">
<configuration>
    <properties resource="jdbc.properties"/>
    <typeAliases>
        <typeAlias type="com.kawainekosann.domain.User"/>
    </typeAliases>
    <environments default="development">
        <environment id="development">
            <transactionManager type="JDBC"></transactionManager>
            <dataSource type="POOLED">
                <!--数据源基本配置-->
                <property name="driver" value="${jdbc.driver}"/>
                <property name="url" value="${jdbc.url}"/>
                <property name="username" value="${jdbc.username}"/>
                <property name="password" value="${jdbc.password}"/>
            </dataSource>
        </environment>
    </environments>
    <mappers>
        <mapper resource="com.kawainekosann.mapper\UserMapper.xml"></mapper>
    </mappers>
</configuration>
```

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper
        PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="userMapper">
    <select id="findAll" resultType="user">
        select * from public.user
    </select>
</mapper>
```

```java
public class User{
    private int id;
    private String userName;
    private String passWord;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getPassWord() {
        return passWord;
    }

    public void setPassWord(String passWord) {
        this.passWord = passWord;
    }

    @Override
    public String toString() {
        return "User{" +
                "id=" + id +
                ", userName='" + userName + '\'' +
                ", passWord='" + passWord + '\'' +
                '}';
    }
}
```

```java
public class UserDaoImpl implements UserDao {
    public List<User> findAll() throws IOException {
        InputStream inputStream = Resources.getResourceAsStream("sqlMapConfig.xml");
        SqlSessionFactory sqlSessionFactory = new SqlSessionFactoryBuilder().build(inputStream);
        SqlSession sqlSession = sqlSessionFactory.openSession();
        List<User> userList= sqlSession.selectList("userMapper.findAll");
        return userList;
    }
}
```

```java
public class ServiceDemo {
    public static void main(String[] args) throws IOException {
        //创建dao层对象
        UserDao userDao = new UserDaoImpl();
        List<User> userList = userDao.findAll();
        System.out.println(userList);
    }
}
```

### 代理开发方式介绍

采用Mybatis的代理开发方式实现了DAO层的开发，这种方式是我们后面进入企业的主流。

Mapper接口开发方法只需要编写Mapper接口（相当于Dao接口），由Mybatis框架根据接口定义创建接口的动态代理对象，代理对象的方法同Dao接口的实现类方法。

Mapper接口开发需要遵循以下规范：

1. Mapper.xml文件中的namespace与mapper接口的全限定名相同。
2. Mapper接口方法名和Mapper.xml中定义的每个statement的id相同
3. Mapper接口方法的输入参数类型和mapper.xml中定义的每个sql的parameterType的类型相同
4. Mapper接口方法的输出参数类型和mapper.xml中定义的每个sql的resultType的类型相同

mapper接口：

```java
public interface UserDao {
    public List<User> findAll() throws IOException;
}
```

mapper.xml：

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper
        PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<!--1.Mapper.xml文件中的namespace与mapper接口的全限定名相同。-->
<mapper namespace="com.kawainekosann.dao.UserDao">
    <!--Mapper接口方法名和Mapper.xml中定义的每个statement的id相同-->
    <!--Mapper接口方法的输出参数类型和mapper.xml中定义的每个sql的resultType的类型相同-->
    <select id="findAll" resultType="user">
        select * from public.user
    </select>
</mapper>
```

```java
public class ServiceDemo {
    public static void main(String[] args) throws IOException {
        InputStream resourceAsStream = Resources.getResourceAsStream("sqlMapConfig.xml");
        SqlSession sqlSession = new SqlSessionFactoryBuilder().build(resourceAsStream).openSession();
        UserDao mapper = sqlSession.getMapper(UserDao.class);

        List<User> users = mapper.findAll();
        System.out.println(users);

        User user = mapper.findById(2);
        System.out.println(user);
    }
}
```



## Mybatis映射文件深入

### 动态sql语句概述

Mybatis的映射文件中，前面我们的sql都是比较简单的，有时候业务逻辑复杂时，我们SQL是动态变化的

### `<if>`

```xml
<mapper namespace="com.kawainekosann.mapper.UserMapper">
    <!--Mapper接口方法名和Mapper.xml中定义的每个statement的id相同-->
    <!--Mapper接口方法的输出参数类型和mapper.xml中定义的每个sql的resultType的类型相同-->
    <!--Mapper接口方法的输入参数类型和mapper.xml中定义的每个sql的parameterType的类型相同-->
    <select id="findByCondition" resultType="user" parameterType="user">
        select * from public.user
        <where>
            <if test="id!=0">
                and id = #{id}
            </if>
            <if test="userName!=null">
                and "userName"=#{userName}
            </if>
        </where>
    </select>
</mapper>
<!--where标签，根据你传递的动态条件去决定添加不添加-->
```

### `<foreach>`

```xml
<!--select * from public.user where id=1 or id=2-->
<!--select * from public.user where id in (1,2)-->
    <!--foreach collection list是集合 array传数组
    open:sql以什么为开始 close:sql以什么为结束 item：集合里的每一项
    separator：以什么符号为分隔符-->
    <select id="findByIds" parameterType="list" resultType="user">
        select * from public.user
        <where>
        <foreach collection="list" open="id in(" close=")" item="id" separator=",">
            #{id}
        </foreach>
        </where>
    </select>
```



### sql语句抽取

```xml
<mapper namespace="com.kawainekosann.mapper.UserMapper">
    <!--sql语句的抽取-->
    <sql id="selectUser">select * from public.user</sql>

    <!--Mapper接口方法名和Mapper.xml中定义的每个statement的id相同-->
    <!--Mapper接口方法的输出参数类型和mapper.xml中定义的每个sql的resultType的类型相同-->
    <!--Mapper接口方法的输入参数类型和mapper.xml中定义的每个sql的parameterType的类型相同-->
    <select id="findByCondition" resultType="user" parameterType="user">
        <include refid="selectUser"></include>
        <where>
            <if test="id!=0">
                and id = #{id}
            </if>
            <if test="userName!=null">
                and "userName"=#{userName}
            </if>
        </where>
    </select>
    <!--foreach collection list是集合 array传数组
    open:sql以什么为开始 close:sql以什么为结束 item：集合里的每一项
    separator：以什么符号为分隔符-->
    <select id="findByIds" parameterType="list" resultType="user">
        <include refid="selectUser"></include>
        <where>
            <foreach collection="list" open="id in(" close=")" item="id" separator=",">
                #{id}
            </foreach>
        </where>
    </select>
</mapper>
```



## Mybatis核心配置文件深入

### typeHandlers标签

typeHandlers又叫类型处理器，无论是mybatis在预处理语句（PreparedStatement）中设置一个参数时，还是从结果集中取出一个值时，都会用类型处理器将获取的值以合适的方式转换成Java类型，在MyBatis中使用typeHandler来实现。所以说白了，typeHandlers就是用来完成javaType和jdbc Type之间的转换

#### 开发步骤：

1. 定义转换类继承`BaseTypeHandler<T>`
2. 覆盖4个实现方法，其中`setNonNullParameter`为`java程序设置数据到数据库的回调方法，getNullableResult为查询时mysql的字符串类型转换成java的Type类型的方法
3. 在mybatis核心配置文件中进行注册
4. 测试是否转换正确























