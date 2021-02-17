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



### **静态代理**

假设现在项目经理有一个需求：在项目现有所有类的方法前后打印日志。

你如何在**不修改已有代码的前提下**，完成这个需求？

我首先想到的是静态代理。具体做法是：

1.为现有的每一个类都编写一个**对应的**代理类，并且让它实现和目标类相同的接口（假设都有）

![img](../../img/静态代理1.jpg)

2.在创建代理对象时，通过构造器塞入一个目标对象，然后在代理对象的方法内部调用目标对象同名方法，并在调用前后打印日志。也就是说，**代理对象 = 增强代码 + 目标对象（原对象）**。有了代理对象后，就不用原对象了

![img](../../img/静态代理2.jpg)


**静态代理的缺陷**

程序员要手动为每一个目标类编写对应的代理类。如果当前系统已经有成百上千个类，工作量太大了。所以，现在我们的努力方向是：如何少写或者不写代理类，却能完成代理功能？

**复习对象的创建**

很多初学Java的朋友眼中创建对象的过程

![img](../../img/对象创建1.jpg)



实际上可以换个角度，也说得通

![img](../../img/对象创建2.jpg)



所谓的Class对象，是Class类的实例，而Class类是描述所有类的，比如Person类，Student类

![img](../../img/对象创建3.jpg)



可以看出，要创建一个实例，最关键的就是**得到对应的Class对象。**只不过对于初学者来说，new这个关键字配合构造方法，实在太好用了，底层隐藏了太多细节，一句 Person p = new Person();直接把对象返回给你了。我自己刚开始学Java时，也没意识到Class对象的存在。

分析到这里，貌似有了思路：

**能否不写代理类，而直接得到代理Class对象，然后根据它创建代理实例（反射）。**

**Class对象包含了一个类的所有信息，比如构造器、方法、字段等**。如果我们不写代理类，这些信息从哪获取呢？苦思冥想，突然灵光一现：代理类和目标类理应实现同一组接口。**之所以实现相同接口，是为了尽可能保证代理对象的内部结构和目标对象一致，这样我们对代理对象的操作最终都可以转移到目标对象身上，代理对象只需专注于增强代码的编写。**还是上面这幅图：

![img](../../img/静态代理2.jpg)

所以，可以这样说：**接口拥有代理对象和目标对象共同的类信息**。所以，我们可以从接口那得到理应由代理类提供的信息。但是别忘了，接口是无法创建对象的，怎么办？



### Jdk动态代理

JDK提供了java.lang.reflect.InvocationHandler接口和 java.lang.reflect.Proxy类，这两个类相互配合，入口是Proxy，所以我们先聊它。

Proxy有个静态方法：getProxyClass(ClassLoader, interfaces)，**只要你给它传入类加载器和一组接口，它就给你返回代理Class对象。**

用通俗的话说，getProxyClass()这个方法，会从你传入的接口Class中，“拷贝”类结构信息到一个新的Class对象中，但新的Class对象带有构造器，是可以创建对象的。打个比方，一个大内太监（接口Class），空有一身武艺（类信息），但是无法传给后人。现在江湖上有个妙手神医（Proxy类），发明了克隆大法（getProxyClass），不仅能克隆太监的一身武艺，还保留了小DD（构造器）...（这到底是道德の沦丧，还是人性的扭曲，欢迎走进动态代理）

所以，一旦我们明确接口，完全可以通过接口的Class对象，创建一个代理Class，通过代理Class即可创建代理对象。

大体思路:

![img](../../img/动态代理1.jpg)

静态代理:

![img](../../img/动态代理2.jpg)

动态代理:

![img](../../img/动态代理3.jpg)

所以，按我理解，Proxy.getProxyClass()这个方法的本质就是：**以Class造Class。**

有了Class对象，就很好办了，具体看代码：

![img](../../img/动态代理4.jpg)

完美。

根据**代理Class的构造器创建对象时，需要传入InvocationHandler**。每次调用代理对象的方法，最终都会调用InvocationHandler的invoke()方法：

![img](../../img/动态代理5.jpg)

怎么做到的呢？

上面不是说了吗，根据代理Class的构造器创建对象时，需要传入InvocationHandler。**通过构造器传入一个引用，那么必然有个成员变量去接收。**没错，代理对象的内部确实有个成员变量invocationHandler，而且**代理对象的每个方法内部都会调用handler.invoke()**！InvocationHandler对象成了代理对象和目标对象的桥梁，不像静态代理这么直接。

![img](../../img/动态代理6.jpg)



大家仔细看上图右侧的动态代理，我在invocationHandler的invoke()方法中并没有写目标对象。因为一开始invocationHandler的invoke()里确实没有目标对象，需要我们手动new。

![img](../../img/动态代理7.jpg)



但这种写法不够优雅，属于硬编码。我这次代理A对象，下次想代理B对象还要进来改invoke()方法，太差劲了。改进一下，让调用者把目标对象作为参数传进来：

```java
public class ProxyTest {
	public static void main(String[] args) throws Throwable {
		CalculatorImpl target = new CalculatorImpl();
                //传入目标对象
                //目的：1.根据它实现的接口生成代理对象 2.代理对象调用目标对象方法
		Calculator calculatorProxy = (Calculator) getProxy(target);
		calculatorProxy.add(1, 2);
		calculatorProxy.subtract(2, 1);
	}

	private static Object getProxy(final Object target) throws Exception {
		//参数1：随便找个类加载器给它， 参数2：目标对象实现的接口，让代理对象实现相同接口
		Class proxyClazz = Proxy.getProxyClass(target.getClass().getClassLoader(), target.getClass().getInterfaces());
		Constructor constructor = proxyClazz.getConstructor(InvocationHandler.class);
		Object proxy = constructor.newInstance(new InvocationHandler() {
			@Override
			public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
				System.out.println(method.getName() + "方法开始执行...");
				Object result = method.invoke(target, args);
				System.out.println(result);
				System.out.println(method.getName() + "方法执行结束...");
				return result;
			}
		});
		return proxy;
	}
}
```

这样就非常灵活，非常优雅了。无论现在系统有多少类，只要你把实例传进来，getProxy()都能给你返回对应的代理对象。就这样，我们完美地跳过了代理类，直接创建了代理对象！



不过实际编程中，一般不用getProxyClass()，而是使用Proxy类的另一个静态方法：Proxy.newProxyInstance()，直接返回代理实例，连中间得到代理Class对象的过程都帮你隐藏：

```java
public class ProxyTest {
	public static void main(String[] args) throws Throwable {
		CalculatorImpl target = new CalculatorImpl();
		Calculator calculatorProxy = (Calculator) getProxy(target);
		calculatorProxy.add(1, 2);
		calculatorProxy.subtract(2, 1);
	}

	private static Object getProxy(final Object target) throws Exception {
		Object proxy = Proxy.newProxyInstance(
				target.getClass().getClassLoader(),/*类加载器*/
				target.getClass().getInterfaces(),/*让代理对象和目标对象实现相同接口*/
				new InvocationHandler(){/*代理对象的方法最终都会被JVM导向它的invoke方法*/
					public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
						System.out.println(method.getName() + "方法开始执行...");
						Object result = method.invoke(target, args);
						System.out.println(result);
						System.out.println(method.getName() + "方法执行结束...");
						return result;
					}
				}
		);
		return proxy;
	}
}
```



现在，我想题主应该能看懂动态代理了。

![img](../../img/动态代理8.jpg)





最后讨论一下代理对象是什么类型。

首先，请区分两个概念：代理Class对象和代理对象。

![img](../../img/动态代理9.jpg)

单从名字看，代理Class和Calculator的接口确实相去甚远，但是我们却能将代理对象赋值给接口类型：

![img](../../img/动态代理10.jpg)

千万别觉得名字奇怪，就怀疑它不能用接口接收，只要实现该接口就是该类型。

> 代理对象的本质就是：和目标对象实现相同接口的实例。代理Class可以叫任何名字，whatever，只要它实现某个接口，就能成为该接口类型。



### **小结**
我想了个很骚的比喻，希望能解释清楚：
接口Class对象是大内太监，里面的方法和字段比做他的一身武艺，但是他没有小DD（构造器），所以不能new实例。一身武艺后继无人。
那怎么办呢？
正常途径（implements）：
写一个类，实现该接口。这个就相当于大街上拉了一个人，认他做干爹。一身武艺传给他，只是比他干爹多了小DD，可以new实例。
非正常途径（动态代理）：
通过妙手圣医Proxy的克隆大法（Proxy.getProxyClass()），克隆一个Class，但是有小DD。所以这个克隆人Class可以创建实例，也就是代理对象。
代理Class其实就是附有构造器的接口Class，一样的类结构信息，却能创建实例。



例：

```java
public class ProxyTest {
    static private Target target = new Target();
    //获得增强对象
    static private Advice advice = new Advice();
    public static void main(String[] args) {
        TargetInterface proxy = (TargetInterface) Proxy.newProxyInstance(
                target.getClass().getClassLoader(),//目标对象的类加载器
                target.getClass().getInterfaces(),//目标对象相同的接口字节码对象
                new InvocationHandler() {
                    //调用代理对象是实际执行invoke方法
                    public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
                        //这里的invoke是通过反射执行方法
                        advice.before();
                        method.invoke(target, args);
                        advice.after();
                        return null;
                    }
                }
        );
        proxy.save();
    }
}
```



### cglib动态代理

例：

```java
public class ProxyTest {
    static private Target target = new Target();
    //获得增强对象
    static private Advice advice = new Advice();
    //返回值 就是动态生成的代理对象 基于cglib
    public static void main(final String[] args) {
        //1.创建增强器
        Enhancer enhancer = new Enhancer();
        //2.设置父类
        enhancer.setSuperclass(Target.class);
        //3.设置回调
        enhancer.setCallback(new MethodInterceptor() {
            public Object intercept(Object o, Method method, Object[] objects, MethodProxy methodProxy) throws Throwable {
                advice.before();
                Object invoke = method.invoke(target,args);
                advice.after();
                return invoke;
            }
        });
        //4.创建代理对象 此处是父子关系
        Target proxy = (Target) enhancer.create();
        proxy.save();
    }
}
```



## AOP相关概念

Spring的AOP实现底层是对上面的动态代理的代码进行了封装，封装后我们只需要对需要关注的部分进行代码编写，并通过配置的方式完成指定目标方法的增强

在正式讲解APO的操作之前，我们必须理解AOP的相关术语，常用的术语如下：

* Target（目标对象）：代理的目标对象
* Proxy（代理）：一个类被AOP织入增强后，就产生了一个结果代理类
* Joinpoint（连接点）（可以被增强的方法）：所谓的连接点是指那些被拦截到的点，在spring中，这些点指的是方法。因为spring只支持方法类型的连接点
* Pointcut（切入点）（在程序运行过程中被增强的方法称为切入点；就是实际被配置了的连接点）：所谓的切入点是指我们要对哪些Joinpoint进行拦截的定义。
* Advice（通知、增强）：所谓通知就是拦截到Joinpoint之后要做的事情（就是增强方法）
* Aspect（切面）（切入点+通知/增强）：是切入点和通知（引介）的结合。
* Weaving（织入）：是指把增强应用到目标对象来创建新的代理对象的过程。spring采用动态代理织入，而AspectJ采用编译器织入和类装载期织入



## AOP开发明确事项

1. 需要编写的内容

* 编写核心业务代码（目标类的方法）
* 编写切面类，切面类中有通知（增强功能方法）
* 在配置文件中，配置织入关系，即将通知与连接点结合

2. AOP技术实现的内容
    spring框架监控切入点方法的执行。一旦监控到切入点方法被运行，使用代理机制，动态创建目标对象的代理对象，根据通知类别，在代理对象的对应位置，将通知对应的功能织入，完成完整代码逻辑运行。

3. AOP底层使用哪种代理方式

  框架会根据是否实现了接口来决定采用哪种动态代理的方式



## 基于XML的AOP开发

### 快速入门

1. 导入aop相关坐标
2. 创建目标接口和目标类（内部有切点）
3. 创建切面类（内部有增强方法）
4. 将目标类和切面类的对象创建权交给spring
5. 在applicationContext.xml中配置织入关系
6. 测试代码

```xml
<!--Spring推荐使用第三方aspectjweaver插件，该插件比自带的好用-->
<dependency>
    <groupId>org.apache.geronimo.bundles</groupId>
    <artifactId>aspectjweaver</artifactId>
    <version>1.6.8_2</version>
</dependency>
```



### 切点表达式写法

表达式语法

```
execution([修饰符] 返回值类型 包名.类名.方法名(参数)) 
```

* 访问修饰符可以省略
* 返回值类型 包名 类名 方法名可以使用星号\* 代表任意
* 包名与类名之间一个点.代表当前包下的类，两点..表示当前包及其子包下的类
* 参数列表可以使用两个点..表示任意个数，任意类型的参数列表

### 通知类型

通知的配置语法

```xml
<aop通知类型 method="切面类中的方法名" pointcut="切点表达式"></aop通知类型>
```

**前置通知[Before advice]**：在连接点前面执行，前置通知不会影响连接点的执行，除非此处抛出异常。
**正常返回通知[After returning advice]**：在连接点正常执行完成后执行，如果连接点抛出异常，则不会执行。
**异常返回通知[After throwing advice]**：在连接点抛出异常后执行。
**返回通知[After (finally) advice]**：在连接点执行完成后执行，不管是正常执行完成，还是抛出异常，都会执行返回通知中的内容。
**环绕通知[Around advice]**：环绕通知围绕在连接点前后

```xml
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd
       http://www.springframework.org/schema/aop http://www.springframework.org/schema/aop/spring-aop.xsd"
       xmlns:aop="http://www.springframework.org/schema/aop">
    <!--引入AOP命名空间-->

    <!--目标对象-->
    <bean id="target" class="com.kawainekosann.aop.Target"></bean>
    <!--切面对象-->
    <bean id="myAspect" class="com.kawainekosann.aop.MyAspect"></bean>
    <!--配置织入,告诉spring那些方法需要那些增强-->
    <aop:config>
        <!--声明切面-->
        <aop:pointcut id="myPointcut" expression="execution(* com.kawainekosann.aop.*.*(..))"/>
        <aop:aspect ref="myAspect">
            <!--切面：切点+通知-->
            <!--<aop:before method="before" pointcut="execution(public void com.kawainekosann.aop.Target.save())"></aop:before>-->
            <!--<aop:before method="before" pointcut="execution(* com.kawainekosann.aop.*.*(..))"></aop:before>
            <aop:after-returning method="afterReturning"
                                 pointcut="execution(* com.kawainekosann.aop.*.*(..))"></aop:after-returning>-->
            <aop:around method="arround" pointcut="execution(* com.kawainekosann.aop.*.*(..))"/>
            <aop:after-throwing method="afterThrowing" pointcut="execution(* com.kawainekosann.aop.*.*(..))"/>
            <!--<aop:after method="after" pointcut="execution(* com.kawainekosann.aop.*.*(..))"/>-->
            <aop:after method="after" pointcut-ref="myPointcut"></aop:after>
        </aop:aspect>
    </aop:config>
</beans>
```



## 基于注解的AOP开发

基于直接的AOP开发步骤

1. 创建目标接口和目标类（内部有切点）
2. 创建切面类（内部有增强方法）
3. 将目标类和切面类的对象创建权交给spring
4. 在applicationContext.xml中配置织入关系
5. 在配置文件中开启组件扫描和AOP的自动代理
6. 测试代码

```java
@Component("myAspect")
@Aspect//标注当前类是一个切面类
public class MyAspect {
    @Before("execution(* com.kawainekosann.anno.*.*(..))")
    public void before() {
        System.out.println("前置增强");
    }
    public void afterReturning(){
        System.out.println("后置增强");
    }
    public void afterThrowing(){
        System.out.println("异常抛出增强");
    }

    @Around("pointcut()")
    //Proceeding JoinPoint 正在执行的连接点===切点
    public Object arround(ProceedingJoinPoint pjp) throws Throwable {
        System.out.println("环绕前。。。");
        Object proceed = pjp.proceed();//切点方法
        System.out.println("环绕后。。。");
        return proceed;
    }
    @Around("MyAspect.pointcut()")
    public void after(){
        System.out.println("最终增强");
    }

    //定义切点表达式
    @Pointcut("execution(* com.kawainekosann.anno.*.*(..))")
    public void pointcut(){};
}
```

```xml
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd
       http://www.springframework.org/schema/aop http://www.springframework.org/schema/aop/spring-aop.xsd
       http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context.xsd"
       xmlns:aop="http://www.springframework.org/schema/aop"
       xmlns:context="http://www.springframework.org/schema/context"
>
    <!--引入AOP命名空间 context命名空间（用于组件扫描）-->
    <context:component-scan base-package="com.kawainekosann.anno"></context:component-scan>
    <!--AOP自动代理-->
    <aop:aspectj-autoproxy></aop:aspectj-autoproxy>
</beans>
```

### 总结

#### Spring AOP
1、基于动态代理来实现，默认如果使用接口的，用JDK提供的动态代理实现，如果是方法则使用CGLIB实现
2、Spring AOP需要依赖IOC容器来管理，并且只能作用于Spring容器，使用纯Java代码实现
3、在性能上，由于Spring AOP是基于动态代理来实现的，在容器启动时需要生成代理实例，在方法调用上也会增加栈的深度，使得Spring AOP的性能不如AspectJ的那么好

#### AspectJ

- AspectJ来自于Eclipse基金会
- AspectJ属于静态织入，通过修改代码来实现，有如下几个织入的时机：

1、编译期织入（Compile-time weaving）： 如类 A 使用 AspectJ 添加了一个属性，类 B 引用了它，这个场景就需要编译期的时候就进行织入，否则没法编译类 B。 
2、编译后织入（Post-compile weaving）： 也就是已经生成了 .class 文件，或已经打成 jar 包了，这种情况我们需要增强处理的话，就要用到编译后织入。 
3、类加载后织入（Load-time weaving）： 指的是在加载类的时候进行织入，要实现这个时期的织入，有几种常见的方法。1、自定义类加载器来干这个，这个应该是最容易想到的办法，在被织入类加载到 JVM 前去对它进行加载，这样就可以在加载的时候定义行为了。2、在 JVM 启动的时候指定 AspectJ 提供的 agent：`-javaagent:xxx/xxx/aspectjweaver.jar`。 

- AspectJ可以做Spring AOP干不了的事情，它是AOP编程的完全解决方案，Spring AOP则致力于解决企业级开发中最普遍的AOP（方法织入）。而不是成为像AspectJ一样的AOP方案
- 因为AspectJ在实际运行之前就完成了织入，所以说它生成的类是没有额外运行时开销的
#### 对比总结

下表总结了 Spring AOP 和 AspectJ 之间的关键区别:

| Spring AOP                                       | AspectJ                                                      |
| ------------------------------------------------ | ------------------------------------------------------------ |
| 在纯 Java 中实现                                 | 使用 Java 编程语言的扩展实现                                 |
| 不需要单独的编译过程                             | 除非设置 LTW，否则需要 AspectJ 编译器 (ajc)                  |
| 只能使用运行时织入                               | 运行时织入不可用。支持编译时、编译后和加载时织入             |
| 功能不强-仅支持方法级编织                        | 更强大 – 可以编织字段、方法、构造函数、静态初始值设定项、最终类/方法等……。 |
| 只能在由 Spring 容器管理的 bean 上实现           | 可以在所有域对象上实现                                       |
| 仅支持方法执行切入点                             | 支持所有切入点                                               |
| 代理是由目标对象创建的, 并且切面应用在这些代理上 | 在执行应用程序之前 (在运行时) 前, 各方面直接在代码中进行织入 |
| 比 AspectJ 慢多了                                | 更好的性能                                                   |
| 易于学习和应用                                   | 相对于 Spring AOP 来说更复杂                                 |



## jdbc template基本使用

### jdbc template开发步骤

1. 导入spring-jdbc和spring-tx坐标

2. 创建数据库表和实体

3. 创建jdbcTemplate对象

   * ```java
     JdbcTemplate jdbcTemplate = new JdbcTemplate();
     //设置数据源对象，知道数据库在哪儿
     jdbcTemplate.setDataSource(dataSource);
     ```

4. 执行数据库操作

```xml
<dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-jdbc</artifactId>
            <version>4.1.3.RELEASE</version>
   </dependency>
   <dependency>
       <groupId>org.springframework</groupId>
       <artifactId>spring-tx</artifactId>
       <version>5.0.5.RELEASE</version>
</dependency>
```

```xml
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:context="http://www.springframework.org/schema/context"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd
       http://www.springframework.org/schema/context  http://www.springframework.org/schema/context/spring-context.xsd
">

    <context:property-placeholder location="classpath:jdbc.properties"></context:property-placeholder>
    <bean id="dataSource" class="com.alibaba.druid.pool.DruidDataSource">
        <property name="driverClassName" value="${jdbc.driver}"></property>
        <property name="url" value="${jdbc.url}"></property>
        <property name="username" value="${jdbc.username}"></property>
        <property name="password" value="${jdbc.password}"></property>
    </bean>

    <bean id="jdbcTemplate" class="org.springframework.jdbc.core.JdbcTemplate">
        <property name="dataSource" ref="dataSource"></property>
    </bean>
</beans>
```

```properties
jdbc.driver=com.mysql.jdbc.Driver
jdbc.url=jdbc:mysql://localhost:3306/test?useUnicode=true&characterEncoding=utf8
jdbc.username=root
jdbc.password=67iwxh1314
```

```java
@Test
    public void Test2(){
        ApplicationContext app= new ClassPathXmlApplicationContext("applicationContext.xml");
        JdbcTemplate jdbcTemplate = (JdbcTemplate) app.getBean("jdbcTemplate");
        int row = jdbcTemplate.update("insert into account (name,money) values (?,?)", new Object[]{"liu", 500});
        System.out.println(row);
    }
```

```java
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("classpath:applicationContext.xml")
public class JdbcTemplateCRUDTest {
    @Autowired
    private JdbcTemplate jdbcTemplate;
    @Test
    public void testUpdate() {
        jdbcTemplate.update("update account set money = ? where id =?", new Object[]{10000, 4});
    }
    @Test
    public void delete() {
        jdbcTemplate.update("delete from account where id = ?", "5");
    }
    @Test
    public void testQueryAll() {
        List<Account> accountList = jdbcTemplate.query("select * from account", new BeanPropertyRowMapper<Account>(Account.class));
        System.out.println(accountList);
    }
    @Test
    public void testQueryOne() {
        Account account = jdbcTemplate.queryForObject("select * from account where id = ?", new BeanPropertyRowMapper<Account>(Account.class), "3");
        System.out.println(account);
    }
    @Test
    public void testQueryCount() {
        Long account = jdbcTemplate.queryForObject("select count(*) from account",Long.class);
        System.out.println(account);
    }
}
```



## Spring事务

### Spring编程式事务控制相关对象

PlatformTransactionManager接口是spring的事务管理器，它里面提供了我们常用的操作事务的方法

不同的dao层技术有不同的实现类，例如jdbc或mybatis时:org.springframework.jdbc.datasource.DataSourceTransactionManager;

技术是hibernate时:org.springframework.orm.hibernate5.hibernateTransactionManager

### TransactionDefinition

它是事务定义信息对象，有如下方法

| 方法                         | 说明               |
| ---------------------------- | ------------------ |
| int getIsolationLevel()      | 获得事务隔离级别   |
| int getPropogationBehavior() | 获得事务的传播行为 |
| int getTimeOut()             | 获得超时时间       |
| boolean isReadOnly()         | 是否只读           |

#### 事务隔离级别

设置隔离级别可以解决事务并发产生的问题，如脏读，不可重复读和虚读

* ISOLATION_DEFAULT
* ISOLATION_READ_UNCOMMITTED
* ISOLATION_READ_COMMITTED
* ISOLATION_REPEATABLE_READ
* ISOLATION_SERIALIZABLE

#### 事务传播行为

![img](../../img/spring事务传播行为.png)

超时时间：默认是-1，没有超时限制，如果有，以秒为单位进行设置

是否只读：建议查询时设置为只读

### TransactionStatus

TransactionStatus提供的事务具体的运行状态，方法介绍如下

| 方法                     | 说明           |
| ------------------------ | -------------- |
| boolean hasSavepoint()   | 是否存储回滚点 |
| boolean isCompleted()    | 事务是否完成   |
| oolean isNewTransaction  | 是否是新事物   |
| boolean isRollbackOnly() | 事务是否回滚   |

<font color = 'red'>编程式事务控制三大对象</font>

* PlatformTransactionManager
* TransactionDefinition
* TransactionStatus



### 基于xml的声明式事务控制

#### 什么是声明式事务控制

spring的声明式事务控制顾名思义就是<font color ='red'>采用声明的方式来处理事务</font>。这里所说的声明就是，用在spring配置文件中声明，用在spring配置文件中声明式的处理事务来代替代码式的处理事务

#### 声明式事务处理的作用

* 事务管理不侵入开发的组件，具体来说，业务逻辑对象就不会意识到正在事务管理之中，事实上也应该如此，因为事务管理是属于系统层面的服务。而不是业务逻辑的一部分。如果想要改变事务管理策划的话，也只需要在定义文件中重新配置即可。
* 在不需要事务管理的时候，只要在设定文件上修改一下，即可一区事务管理服务，无需改变代码重新编译，这样维护起来极其方便

<font color ='red'>注意：Spring声明式事务控制底层就是AOP</font>



#### 声明式事务控制的实现

声明式事务控制明确事项：

1. 谁是切点  （业务方法）
2. 谁是通知    
3. 配置切面    

#### 声明式事务配置要点

* 平台事务管理器配置

```xml
    <!--配置平台事务管理器-->
    <bean id="transactionManager" class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
        <property name="dataSource" ref="dataSource"/>
    </bean>
```

* 事务通知的配置

```xml
<!--通知 事务的管理 tx-->
    <tx:advice id="txAdvice" transaction-manager="transactionManager">
        <!--设置事务的属性信息 name:切点方法名称这里是service方法名称
        isolation:事务隔离级别
        propagation:事务传播行为
        timeout:超时时间
        read-only:是否只读-->
        <tx:attributes>
            <tx:method name="transfer" isolation="DEFAULT" propagation="REQUIRED" read-only="false"></tx:method>
            <tx:method name="*" isolation="DEFAULT" propagation="REQUIRED" timeout="-1" read-only="false"/>
        </tx:attributes>
    </tx:advice>
```

* 事务aop织入的配置

```xml
<!--配置事务AOP织入-->
    <aop:config>
        <!--事务增强advisor-->
        <aop:advisor advice-ref="txAdvice"
                     pointcut="execution(* com.kawainekosann.service.AccountServiceImpl.*(..))">                      </aop:advisor>
   </aop:config>
```



### 事务控制基于注解

```xml
   <context:component-scan base-package="com.kawainekosann"></context:component-scan>

        <!--<bean id="accountDao" class="com.kawainekosann.dao.AccountDaoImpl">
            <property name="jdbcTemplate" ref="jdbcTemplate"></property>
        </bean>
        &lt;!&ndash;目标对象 内部方法就是切点&ndash;&gt;
        <bean id="accountService" class="com.kawainekosann.service.AccountServiceImpl">
            <property name="accountDao" ref="accountDao"></property>
        </bean>-->

    <!--配置平台事务管理器-->
    <bean id="transactionManager" class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
        <property name="dataSource" ref="dataSource"/>
    </bean>
    <!--使用注解时要添加，事务的注解驱动-->
    <tx:annotation-driven transaction-manager="transactionManager"></tx:annotation-driven>

    <!--通知 事务的管理 tx-->
    <!--<tx:advice id="txAdvice" transaction-manager="transactionManager">
        &lt;!&ndash;设置事务的属性信息 name:切点方法名称这里是service方法名称
        isolation:事务隔离级别
        propagation:事务传播行为
        timeout:超时时间
        read-only:是否只读&ndash;&gt;
        <tx:attributes>
            <tx:method name="transfer" isolation="DEFAULT" propagation="REQUIRED" read-only="false"></tx:method>
            <tx:method name="*" isolation="DEFAULT" propagation="REQUIRED" timeout="-1" read-only="false"/>
        </tx:attributes>
    </tx:advice>
    &lt;!&ndash;配置事务AOP织入&ndash;&gt;
    <aop:config>
        &lt;!&ndash;事务增强advisor&ndash;&gt;
        <aop:advisor advice-ref="txAdvice"
                     pointcut="execution(* com.kawainekosann.service.AccountServiceImpl.*(..))"></aop:advisor>
    </aop:config>-->
```

```java
@Service
//写在开头表示这是该类全局配置，如果类和方法上都配置了，以方法为主
//@Transactional(isolation = Isolation.DEFAULT,propagation = Propagation.REQUIRED)
public class AccountServiceImpl implements AccountService{
    @Autowired
    private AccountDao accountDao;

    /*public void setAccountDao(AccountDao accountDao) {
        this.accountDao = accountDao;
    }*/

    @Transactional(isolation = Isolation.DEFAULT,propagation = Propagation.REQUIRED)
    public void transfer(String outMan, String inMan, double money) {
        //开启事务
        accountDao.out(outMan,money);
        int i = 1/0;
        accountDao.in(inMan,money);
        //提交事务
    }
    //每个方法可以配自己的
    @Transactional(propagation = Propagation.REQUIRED)
    public void xxx(){};
}
```



## Spring集成web环境

```xml
        <dependency>
            <groupId>javax.servlet</groupId>
            <artifactId>javax.servlet-api</artifactId>
            <version>4.0.1</version>
        </dependency>
        <dependency>
            <groupId>javax.servlet.jsp</groupId>
            <artifactId>javax.servlet.jsp-api</artifactId>
            <version>2.3.3</version>
        </dependency>
```

* project structure modules中追加web模块

![img](../../img/idea web.png)

* 将maven的包导入web-info/lib文件夹，选中include in project build

![iimg](/Users/liuqi/Desktop/note/feimaoNotes/img/idea web2.png)

* Tomcat添加artfacts

<img src="../../img/idea web3.png" alt="img" style="zoom:50%;" />



### ApplicationContext应用上下文的获取方式

应用上下文对象是通过<font color='red'>new ClassPathXmlApplicationContext(spring配置文件)</font>方式配置的，每次从容器中获取bean时都要编写<font color='red'>new ClassPathXmlApplicationContext(spring配置文件)</font>，这样的弊端是配置文件多次加载，应用上下文对象创建多次

在web项目中可以使用<font color='red'>ServletContextListener</font>监听web应用的启动，我们可以在web应用启动时，就加在Spring的配置文件，创建应用上下文对象ApplicationContext，再将其存储到最大的域<font color='red'>ServletContext</font>域中，这样就可以在任意位置获得应用上下文的ApplicationContext对象了

```java
public class ContextLoaderListener implements ServletContextListener {
    public void contextInitialized(ServletContextEvent sce) {
        //ApplicationContext app = new ClassPathXmlApplicationContext("applicationContext.xml");
        //将Spring应用的上下文对象存储到servletContext域中
        ServletContext servletContext = sce.getServletContext();
       //读取web.xml中的全局参数
        String contextConfigLocation =servletContext.getInitParameter("contextConfigLocation");
        ApplicationContext app = new ClassPathXmlApplicationContext(contextConfigLocation);
        servletContext.setAttribute("app",app);
        System.out.println("spring容器创建完毕");
    }
    public void contextDestroyed(ServletContextEvent sce) {

    }
}
```

```xml
<!-- web.xml-->
<web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee http://xmlns.jcp.org/xml/ns/javaee/web-app_4_0.xsd"
         version="4.0">
    <!--全局初始化参数-->
    <context-param>
        <param-name>contextConfigLocation</param-name>
        <param-value>applicationContext.xml</param-value>
    </context-param>
    <!--配置监听器-->
    <listener>
        <listener-class>com.kawainekosann.listener.ContextLoaderListener</listener-class>
    </listener>
    <servlet>
        <servlet-name>UserServlet</servlet-name>
        <servlet-class>com.kawainekosann.web.UserServlet</servlet-class>
    </servlet>
    <servlet-mapping>
        <servlet-name>UserServlet</servlet-name>
        <url-pattern>/userServlet</url-pattern>
    </servlet-mapping>
</web-app>
```

```java
public class UserServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        //从ServletContext域中获取应用上下文
        //req.getContextPath();
        ServletContext servletContext = this.getServletContext();
        ApplicationContext app = (ApplicationContext) servletContext.getAttribute("app");
        //ApplicationContext app = new ClassPathXmlApplicationContext("applicationContext.xml");
        UserService userService = app.getBean(UserService.class);
        userService.save();
    }
}
```

### spring提供获取应用上下文的工具

上面的分析不需要手动实现，Spring提供了一个监听器<font color='red'>ContextLoaderListener</font>就是对上述功能的封装，该监听器内部加载Spring配置文件，创建应用上下文，并存储到<font color='red'>ServletContext</font>域中，提供了一个客户端工具<font color='red'>WebApplicationContextUtils</font>供开发者获得应用上下文对象

步骤

1. 在web.xml中配置<font color='red'>ContextLoaderListener</font>监听器（导入spring-web坐标）
2. 使用<font color='red'>WebApplicationContextUtils</font>获得应用上下文对象ApplicationContext

```xml
    <!--全局初始化参数-->
    <context-param>
        <param-name>contextConfigLocation</param-name>
        <!--参数名一样，值为配置文件路径-->
        <param-value>classpath:applicationContext.xml</param-value>
    </context-param>
    <!--配置监听器-->
    <listener>
        <listener-class>org.springframework.web.context.ContextLoaderListener</listener-class>
    </listener>
```

```java
protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        //从ServletContext域中获取应用上下文
        //req.getContextPath();
        ServletContext servletContext = this.getServletContext();
        //ApplicationContext app = WebApplicationContextUtils.getWebApplicationContext(servletContext);
        //ApplicationContext app = (ApplicationContext) servletContext.getAttribute("app");
        //ApplicationContext app = new ClassPathXmlApplicationContext("applicationContext.xml");
        WebApplicationContext app = WebApplicationContextUtils.getWebApplicationContext(servletContext);
        UserService userService = app.getBean(UserService.class);
        userService.save();
    }
```






