# Spring相关

[toc]



## Spring配置文件

### spring标签基本配置

用于配置对象交由Sring来创建；

默认情况下它调用的是类中的无参构造函数，如果没有无参构造函数则不能创建成功。

基本属性

* id：Bean实例在Spring容器中的唯一标识
* class：Bean的全限定名称

### Bean标签范围配置

scope: 指对象的作用范围，取值如下

* singleton:默认的，单例的；
  实例化个数：1
  实例化时机：当Spring核心文件被加载时，实例化配置的Bean实例
  生命周期：
  对象创建：当应用加载，创建容器时，实例化配置Bean实例
  对象运行：只要容器在，对象一直活着
  对象销毁：当应用卸载，销毁容器时，对象被销毁
* prototype:多例的；  新建对象为不同地址
  实例化个数：多个
  实例化时机：当调用getBean()方法时，实例化配置的Bean实例
  生命周期：
  对象创建：当使用对象时，创建对象实例
  对象运行：只要对象使用中，就一直活着
  对象销毁：当对象长时间不用，会被Java的垃圾回收器回收掉
* request:Web项目中，spring创建一个bean对象，将该对象传入request域中；
* session:Web项目中，spring创建一个bean对象，将该对象传入session域中；
* global session： Web项目中，应用在Portlet环境，如果没有Portlet环境那么global Session相当于session

### Bean生命周期配置
* init-method:初始化方法

* destroy-method:销毁方法 

  <font color = "red">销毁时要用转成父类使用父类的close方法,并且此时注入的对象为单例模式</font>

  ```java
  ApplicationContext app = new ClassPathXmlApplicationContext("applicationContext.xml");
  UserService userService = app.getBean(UserService.class);
  userService.save();
  ((ClassPathXmlApplicationContext)app).close();
  ```

  

### Bean实例化的三种方式

* 无参构造方法实例化
* 工厂静态方法实例化 
  设置factory-method指向对应工厂类的静态方法
* 工厂实例方法实例化
  工厂实例方法 先创建工厂的实例然后 factory-bean 和factory-method去创建

### Bean的依赖注入分析

依赖注入：它是Spring核心框架IOC的具体实现

在编写程序是通过控制反转，将对象的创建交给Spring，但是代码中不可能出现没有依赖的情况，IOC解耦只是降低他们的依赖关系，但不会消除，比如：业务层仍然会调用持久层的方法

简单说就是把持久层的对象传入业务层（通过Spring去创建两者的依赖），直接操作业务层就行了

#### 依赖注入方式

* set方法 [将UserDao对象注入setUserDao()方法]

  ```xml
  <bean id = 'UserDao' class="com.kawainekosann.dao.impl.UserDaoImpl" ></bean>
  <bean id="UserService" class="com.kawainekosann.service.impl.UserServiceImpl">
      <!--name : set方法名去掉set，首字母小写  -->
      <property name="userDao" ref="UserDao"></property>
  </bean>
  ```

  * p命名空间（该set写法的一种简写）

    * 引入命名空间 `xmlns:p="http://www.springframework.org/schema/p"`

    * ```xml
      <!--p 命名空间-->
      <bean id="UserService" class="com.kawainekosann.service.impl.UserServiceImpl" p:userDao-ref="UserDao"></bean>
      ```

* 构造方法

  ```java
  public class UserServiceImpl implements UserService {
      private UserDao userDao;
      public UserServiceImpl(UserDao userDao) {
          this.userDao = userDao;
      }
  }
  ```
  
  ```xml
  <!--构造器注入对象-->
  <bean id="UserService" class="com.kawainekosann.service.impl.UserServiceImpl">
      <!--userDao为有参构造器传入的参数名-->
      <constructor-arg name="userDao" ref="UserDao"></constructor-arg>
  </bean>
  ```
  
  

#### 依赖注入的数据类型

注入数据的三种数据类型

* 普通数据类型

  ```java
    public class UserDaoImpl implements UserDao {
        private String userName;
        private int age;
        public void setUserName(String userName) {
            this.userName = userName;
        }
        public void setAge(int age) {
            this.age = age;
        }
    }
  //或者构造器构造
  public UserDaoImpl(String userName, int age) {
          this.userName = userName;
          this.age = age;
  }
  ```

  ```xml
  <bean id = 'UserDao' class="com.kawainekosann.dao.impl.UserDaoImpl" >
    <!--通过value属性传普通数据类型-->
          <property name="userName" value="feimao"></property>
          <property name="age" value="18"></property>
  </bean>
  <!--通过构造器构造-->
  <bean id = 'UserDao' class="com.kawainekosann.dao.impl.UserDaoImpl" >
          <constructor-arg name="userName" value="feimao"></constructor-arg>
          <constructor-arg name="age" value="18"></constructor-arg>
  </bean>
  ```

  

* 引用数据类型（对象）

* 集合数据类型

  ```java
  private List<String> strList;
  private Map<String, User> userMap;
  private Properties properties;
  ```

  ```xml
  <!--集合数据类型注入-->
      <bean id = 'UserDao' class="com.kawainekosann.dao.impl.UserDaoImpl" >
          <property name="strList" >
              <list>
                  <value>feimao2</value>
                  <value>feimao3</value>
              </list>
          </property>
          <property name="userMap">
              <map>
                  <entry key="feimao4" value-ref="User1"></entry>
                  <entry key="feimao5" value-ref="User2"></entry>
              </map>
          </property>
          <property name="properties">
              <props>
                  <prop key="feimao8">kawai</prop>
                  <prop key="feimao9">kawai2</prop>
                  <prop key="feimao10">kawai3</prop>
              </props>
          </property>
      </bean>
      <bean id = "User1" class="com.kawainekosann.domain.User">
          <property name="name" value="feimao6"></property>
          <property name="addr" value="Nantong"></property>
      </bean>
      <bean id = "User2" class="com.kawainekosann.domain.User">
          <property name="name" value="feimao7"></property>
          <property name="addr" value="Nantong1"></property>
      </bean>
  ```




### 引入其他的配置文件

实际开发中 Spring的配置内容非常多，所以可以将部分配置拆解到其他的配置文件中，而在Spring的主配置文件通过import标签进行加载

```xml
<import resource="applicationContext-user.xml"></import>
```



## Spring相关api

### ApplicationContext的实现类

<font color = 'red'>1. ClassPathXmlApplicationContext</font>

它是从类加载路径（resources）下加载配置文件的，推荐使用这种

<font color = 'red'>2. FileSystemXmlApplicationContext</font>

它是从磁盘路径上加载配置文件的，配置文件可以在磁盘的任意位置

<font color = 'red'>3. AnnotationConfigApplicationContext</font>

它是当使用注解配置容器对象时，需要使用此类来创建Spring容器，它用来读取注解



### getBean()方法的使用

```java
//<!--构造器注入对象-->
//<bean id="UserService" class="com.kawainekosann.service.impl.UserServiceImpl">
//    <!--userDao为有参构造器传入的参数名-->
//    <constructor-arg name="userDao" ref="UserDao"></constructor-arg>
//</bean>
UserService userService = (UserService) app.getBean("UserService");
```

```java
//<!--构造器注入对象-->
//<bean id="UserService" class="com.kawainekosann.service.impl.UserServiceImpl">
//    <!--userDao为有参构造器传入的参数名-->
//    <constructor-arg name="userDao" ref="UserDao"></constructor-arg>
//</bean>
//因为UserService.class值固定，当Spring创建多个该class的对象时建议用上面的方法，通过id进行区分，此方法无法区分
UserService userService = (UserService) app.getBean(UserService.class);
```



## Spring配置数据源

### 数据源（连接池）的作用

* 数据源（连接池）是为了提升程序性能出现的
* 事先实例化数据源，初始化部分连接资源
* 使用连接资源时从数据源中获取
* 使用完毕后将连接资源归还给数据源

**常见的数据源：<font color ='red'> DBCP, C3p0 , BoneCP , Druid</font>等**

### 抽取jdbc配置文件（properties文件）

首先要引入context的命名空间和约束路径

* 命名空间:`xmlns:context="http://www.springframework.org/schema/context"`

* 约束路径:`http://www.springframework.org/schema/context  http://www.springframework.org/schema/context/spring-context.xsd`

* ```xml
  <!--加载外部的context文件-->
  <context:property-placeholder location="classpath:jdbc.properties"/>
  ........
  <!--EL表达式-->
  <property name="" value="${key}"/></property>
  ```



## Spring注解开发

### Spring原始注解

Spring是轻代码重配置的框架，配置比较繁重，影响开发效率，所以注解开发是一种趋势。注解替代xml配置文件可以简化配置，提高开发效率

**注意**

使用注解开发时，需要在applicationContext.xml中配置组件扫描，作用是指定哪个包及其子包下的Bean需要进行扫描以便识别使用注解配置的类，字段和方法。

```xml
<!--配置组件扫描，不然controller调用service时找不到-->
<context:component-scan base-package="com.kawainekosann"></context:component-scan>
```



Spring原始注解主要是替代<Bean>的配置

| 注解        | 说明                                           |
| ----------- | ---------------------------------------------- |
| @Component  | 使用在类上用于实例化Bean                       |
| @Controller | 使用在web层类上用于实例化Bean                  |
| @Service    | 使用在service层类上用于实例化Bean              |
| @Repository | 使用在dao层类上用于实例化Bean                  |
| @Autowired  | 使用在字段上用于根据类型依赖注入               |
| @Qualifier  | 结合@Autowired一起使用用于根据名称进行依赖注入 |
| @Resource   | 相当于@Autowired+@Qualifier，按照名称进行注入  |
| @Value      | 注入普通属性                                   |
| @Scope      | 标注Bean的作用范围                             |
| @PostConstruct| 使用在方法上标注该方法是Bean的初始化方法     |
| @PreDestroy  |使用在方法上标注该方法是Bean的销毁方法    |

@Component,@Controller,@Service,@Repository

```java
/*<bean id="userDao" class="com.kawainekosann.dao.impl.UserDaoImpl" ></bean>*/
@Repository("userDao")
public class UserDaoImpl implements UserDao 
```

@Autowired,@Qualifier,@Resource

```java
/*<bean id="userService" class="com.kawainekosann.service.impl.UserServiceImpl" >*/
@Service("userService")
public class UserServiceImpl implements UserService {
    /*<property name="userDao" ref="userDao"></property>*/
    //如果只写@Autowired就会按照数据类型从Spring容器中进行匹配这里匹配UserDAO所以可以不写@Qualifier
    //@Autowired
    //@Qualifier("userDao") //这里写要注入的bean的id
    @Resource(name = "userDao")//这里写要注入的bean的id,相当于@Autowired+@Qualifier("userDao")
    private UserDao userDao;
    //使用注解方式时，不需要写set方法，会通过反射自动set
    /*public void setUserDao(UserDao userDao) {
        this.userDao = userDao;
    }*/
```

@Value

```java
//注入普通属性，相当于applicationContext里的value，
//因为applicationContext已经引入了jdbc.properties所以这边可以用EL表达式赋值
@Value("${jdbc.driver}")
private String driver;
```

@Scope

```java
//@Scope("singleton") 单例的
@Scope("prototype") //多例的
public class UserServiceImpl implements UserService {
```

@PostConstruct,@PreDestroy（要转成父类调用close方法，且注入对象为单例）

```java
    @PostConstruct//初始化方法
    public void init(){
        System.out.println("对象初始化方法");
    }

    @PreDestroy//销毁方法
    public void destory(){
        System.out.println("对象销毁方法");
    }
```





### Spring新注解

使用上面的注解还不能全部替代xml配置文件，还需要使用注解替代的配置如下：

* 非自定义的Bean的配置：`<bean>`
* 加载properties文件的配置：`<contextproperty-placeholder>`
* 组件扫描配置：`<contextcomponent-scan>`
* 引入其他文件：`<import>`

Spring新注解

| 注解            | 说明                                                         |
| --------------- | ------------------------------------------------------------ |
| @Configuration  | 用于指定当前类是一个Spring配置类，当创建容器时会从该类上加载注解 |
| @ComponentScan  | 用于知道多Spring在初始化容器时要扫描的包<br/>作用和`<contextcomponent-scan>`一样 |
| @Bean           | 使用在方法上，标注将该方法的返回值存储到Spring容器中         |
| @PropertySource | 用于加载properties文件的配置                                 |
| @Import         | 用于导入其他配置类                                           |

创建Spring核心配置文件后，加载Spring时写法：

```java
ApplicationContext app = new AnnotationConfigApplicationContext();
```



## Spring整合Junit

### 原始Junit测试Spring的问题

在测试类中，每个测试都要写如下代码

```java
ApplicationContext ac = new ClassPathXmlApplicationContext("bean.xml");
UserService userService = ac.getBean("userService");
```

这两行代码作用是获取容器。

### 上述问题解决思路

* 让SpringJunit负责创建Spring容器，需要将配置文件名称告诉他。
* 将需要测试的Bean直接在测试类中注入

#### Spring集成Junit步骤：

1. 导入Spring集成Junit的坐标

2. 使用@Runwith注解替换原来的运行期

3. 使用@ContextConfigration指定配置文件或配置类

4. 使用@Autowired注入需要测试的对象

5. 创建测试方法进行测试

   

## Spring的AOP简介

### 什么是AOP

AOP：<font color= 'red'>面向切面教程（目标加增强称为切面）</font>，是通过预编译方式和运行期动态代理实现程序功能的统一维护的一种技术。

AOP是OOP（面向对象）的延续，是软件开发的一个热点，也是Spring框架中的一个重要内容，是函数式编程的一种衍生泛型。利用AOP可以对业务逻辑的各个部分进行隔离，从而使得业务逻辑各部分之间的耦合度降低。提高程序的可重用性，同时提高开发效率

### AOP的作用及其优势

作用：在程序运行期间，在不修改源码的情况下对方法进行功能增强。

优势：减少重复代码，提高开发效率，便于维护

### AOP的底层实现

实际上，AOP的底层是通过Spring提供的动态代理技术实现的。在运行期间，Spring通过动态代理技术动态的生成代理对象，代理对象执行时进行增强功能的介入，灾区调用目标对象的方法，从而完成功能的增强。

### AOP的动态代理技术

常用的动态代理技术：

* JDK代理： 基于接口的动态代理技术
* cglib代理：基于父类的动态代理技术

### 

### JDK动态代理

#### 简单理解代理

很简单举个例子：

- 现在我是一个明星，拥有很多粉丝。粉丝希望我唱歌给他们听，但是如果都是我来接应他们，我岂不是很忙….于是乎，我就去找了个经纪人。这个**经纪人就代表了我**。当粉丝想要我唱歌的时候，应该是找经纪人，告诉经纪人想让我唱歌。
- 现在我越来越红了，不是粉丝想要我唱歌，我就唱了。我要收费了。但是呢，作为一个公众人物，不可能是我自己说：我要收10000万，我才会去唱歌。于是这就**让经纪人对粉丝说：只有10000万，我才会唱歌。**
- 无论外界是想要我干什么，都要经过我的经纪人。我的**经纪人也会在其中考虑收费、推脱它们的请求。**

**经纪人就是代理，实际上台唱歌、表演的还是我**

#### 静态代理

直接使用例子来说明吧…现在我**有一个IUserDao的接口，拥有save方法()**

```java
// 接口
public interface IUserDao {
    void save();
}
```

- **UserDao实现该接口，重写save()方法**

```java
public class UserDao implements IUserDao{
    @Override
    public void save() {
        System.out.println("-----已经保存数据！！！------");
    }
}
```

现在，我想要在**save()方法保存数据前开启事务、保存数据之后关闭事务**…(当然啦，直接再上面写不就行了吗…**业务方法少的时候，确实没毛病**…)

```java
    public void save() {
        System.out.println("开启事务");
        System.out.println("-----已经保存数据！！！------");
        System.out.println("关闭事务");
    }
```

但是呢，现在如果我有好多好多个业务方法都需要开启事务、关闭事务呢？

```java
    public void save() {
        System.out.println("开启事务");
        System.out.println("-----已经保存数据！！！------");
        System.out.println("关闭事务");
    }
    public void delete() {
        System.out.println("开启事务");
        System.out.println("-----已经保存数据！！！------");
        System.out.println("关闭事务");
    }
    public void update() {
        System.out.println("开启事务");
        System.out.println("-----已经保存数据！！！------");
        System.out.println("关闭事务");
    }
    public void login() {
        System.out.println("开启事务");
        System.out.println("-----已经保存数据！！！------");
        System.out.println("关闭事务");
    }
```

…..我们发现就**有了很多很多的重复代码了**…我们要做的就是：当**用户调用UserDao方法的时候，找的是代理对象、而代理帮我在解决这么繁琐的代码**

于是呢，我们就**请了一个代理了**

- **这个代理要和userDao有相同的方法…没有相同的方法的话，用户怎么调用啊？？**
- **代理只是对userDao进行增强，真正做事的还是userDao..**

因此，我们的代理就要实现IUserDao接口，这样的话，代理就跟userDao有相同的方法了。

```java
public class UserDaoProxy implements IUserDao{
    // 接收保存目标对象【真正做事的还是UserDao】，因此需要维护userDao的引用
    private IUserDao target;
    public UserDaoProxy(IUserDao target) {
        this.target = target;
    }
    @Override
    public void save() {
        System.out.println("开始事务...");
        target.save();          // 执行目标对象的方法
        System.out.println("提交事务...");
    }
```

**外界并不是直接去找UserDao,而是要通过代理才能找到userDao**

```java
    public static void main(String[] args) {
        // 目标对象
        IUserDao target = new UserDao();
        // 代理
        IUserDao proxy = new UserDaoProxy(target);
        proxy.save();  // 执行的是，代理的方法
    }
```

这样一来，我们在UserDao中就不用写那么傻逼的代码了…傻逼的事情都交给代理去干了…

#### 为什么要用动态代理？

我们首先来看一下**静态代理的不足**：

- **如果接口改了，代理的也要跟着改，很烦！**
- **因为代理对象，需要与目标对象实现一样的接口。所以会有很多代理类，类太多。**

动态代理比静态代理好的地方：

- 代理对象，不需要实现接口【就不会有太多的代理类了】
- 代理对象的生成，是利用JDKAPI， **动态地在内存中构建代理对象(需要我们指定创建 代理对象/目标对象 实现的接口的类型；**)

------

### 动态代理快速入门

**Java提供了一个Proxy类，调用它的newInstance方法可以生成某个对象的代理对象,该方法需要三个参数：**

![这里写图片描述](/Users/liuqi/Desktop/note/feimaoNotes/temp/../img/JDK动态代理.png)

- 参数一：生成代理对象使用哪个类装载器【一般我们使用的是代理类的装载器】
- 参数二：生成哪个对象的代理对象，通过接口指定【指定被代理类的接口或者代理类的接口 两者接口一样】
- 参数三：生成的代理对象的方法里干什么事【实现handler接口，我们想怎么实现就怎么实现】

在编写动态代理之前，要明确两个概念：

- **代理对象拥有目标对象相同的方法【因为参数二指定了对象的接口】**
- **用户调用代理对象的什么方法，都是在调用处理器的invoke方法。**
- **使用JDK动态代理必须要有接口【参数二需要接口】**

#### 对象

小明是一个明星，拥有唱歌和跳舞的方法。实现了人的接口

```java
public class XiaoMing implements Person {
    @Override
    public void sing(String name) {
        System.out.println("小明唱" + name);
    }
    @Override
    public void dance(String name) {
        System.out.println("小明跳" + name);
    }
}
```

------

#### 接口

```java
public interface Person {
    void sing(String name);
    void dance(String name);
}
```

#### 代理类

```java
public class XiaoMingProxy {
    //代理只是一个中介，实际干活的还是小明，于是需要在代理类上维护小明这个变量
    XiaoMing xiaoMing = new XiaoMing();
    //返回代理对象
    public Person getProxy() {
        /**
         * 参数一：代理类的类加载器
         * 参数二：被代理对象的接口或者代理类的接口 他俩一样
         * 参数三：InvocationHandler实现类
         */
        return (Person)Proxy.newProxyInstance(XiaoMingProxy.class.getClassLoader(), xiaoMing.getClass().getInterfaces(), new InvocationHandler() {
            /**
             * proxy : 把代理对象自己传递进来
             * method：把代理对象当前调用的方法传递进来
             * args:把方法参数传递进来
             */
            @Override
            public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
                //如果别人想要让小明唱歌
                if (method.getName().equals("sing")) {
                    System.out.println("给1000万来再唱");
                    //实际上唱歌的还是小明
                    method.invoke(xiaoMing, args);
                }
                return null;
            }
        });
    }
}
```

------

#### 测试类

```java
    public static void main(String[] args) {
        //外界通过代理才能让小明唱歌
        XiaoMingProxy xiaoMingProxy = new XiaoMingProxy();
        Person proxy = xiaoMingProxy.getProxy();
        proxy.sing("我爱你");
    }
```



#### Java 动态代理类 

Java动态代理类位于java.lang.reflect包下，一般主要涉及到以下两个类：

1. Interface InvocationHandler：该接口中仅定义了一个方法

```java
public object invoke(Object obj,Method method, Object[] args)
```

在实际使用时，第一个参数obj一般是指代理类，method是被代理的方法，args为该方法的参数数组。这个抽象方法在代理类中动态实现。

2. Proxy：该类即为动态代理类，其中主要包含以下内容：	

3. protected Proxy(InvocationHandler h)：构造函数，用于给内部的h赋值。

4. static Class getProxyClass (ClassLoaderloader, Class[] interfaces)：获得一个代理类，其中loader是类装载器，interfaces是真实类所拥有的全部接口的数组。

   3. static Object newProxyInstance(ClassLoaderloader, Class[] interfaces, InvocationHandler h)：返回代理类的一个实例，返回后的代理类可以当作被代理类使用(可使用被代理类的在Subject接口中声明过的方法)

      

      所谓DynamicProxy是这样一种class：它是在运行时生成的class，在生成它时你必须提供一组interface给它，然后该class就宣称它实现了这些 interface。你当然可以把该class的实例当作这些interface中的任何一个来用。当然，这个DynamicProxy其实就是一个Proxy，它不会替你作实质性的工作，在生成它的实例时你必须提供一个handler，由它接管实际的工作。
      在使用动态代理类时，我们必须实现InvocationHandler接口
      通过这种方式，被代理的对象(RealSubject)可以在运行时动态改变，需要控制的接口(Subject接口)可以在运行时改变，控制的方式(DynamicSubject类)也可以动态改变，从而实现了非常灵活的动态代理关系。



#### **动态代理步骤**：

1.创建一个实现接口InvocationHandler的类，它必须实现invoke方法
2.创建被代理的类以及接口
3.通过Proxy的静态方法
newProxyInstance(ClassLoaderloader, Class[] interfaces, InvocationHandler h)创建一个代理
4.通过代理调用方法












































