## Spring新注解

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

![这里写图片描述](..\img\JDK动态代理.png)

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

1. protected Proxy(InvocationHandler h)：构造函数，用于给内部的h赋值。

2. static Class getProxyClass (ClassLoaderloader, Class[] interfaces)：获得一个代理类，其中loader是类装载器，interfaces是真实类所拥有的全部接口的数组。

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































