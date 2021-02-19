# SpringMVC相关

[toc]

## SpringMVC概述

SpringMVC是一种基于Java实现**MVC设计模型**的请求驱动类型的轻量级Web框架，属于，SpringFrameWork的后续产品SpringMVC已经成为目前最主流的MVC框架之一，并且随着Spring3.0的发布，全面超越Struts2，成为最优秀的MVC框架，它通过一套注解，让一个简单的Java类成为处理请求的控制器，而无需实现任何接口，同时它还支持RESTful编程风格的请求

需求：客户发起请求，服务端收到请求，执行逻辑进行视图跳转

开发步骤

1. 导入SpringMVC包
2. 配置SpringMVC核心控制器DispatchServlet
3. 编写controller和视图页面
4. 使用注解配置Controller类中业务方法的映射地址
5. 配置Spring-mvc.xml文件（配置组件扫描）
6. 执行访问测试

```xml
       <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-webmvc</artifactId>
            <version>5.0.5.RELEASE</version>
        </dependency>
```

```xml
<!--配置SpringMVC的前端控制器-->
    <servlet>
        <servlet-name>DispatcherServlet</servlet-name>
        <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
        <init-param>
            <param-name>contextConfigLocation</param-name>
            <param-value>classpath:spring-mvc.xml</param-value>
        </init-param>
        <load-on-startup>1</load-on-startup>
    </servlet>
    <servlet-mapping>
        <servlet-name>DispatcherServlet</servlet-name>
        <url-pattern>/</url-pattern>
    </servlet-mapping>
```

```xml
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:context="http://www.springframework.org/schema/context"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd
       http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context.xsd
">
    <!--spring-mvc.xml controller组件扫描-->
    <context:component-scan base-package="com.kawainekosann.controller"></context:component-scan>
</beans>
```

```java
@Controller
public class UserController {
    @RequestMapping("/quick")
    public String save() {
        System.out.println("controller save running...");
        return "success.jsp";
    }
}
```

```html
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
<h1>success</h1>
</body>
</html>
```



## SpringMVC执行流程

![img](../../img/springMVC执行流程.png)

- 一个请求匹配前端控制器 DispatcherServlet 的请求映射路径(在 web.xml中指定), WEB 容器将该请求转交给 DispatcherServlet 处理

- DispatcherServlet 接收到请求后, 将根据 请求信息 交给 处理器映射器 （HandlerMapping）

- HandlerMapping 根据用户的url请求 查找匹配该url的 Handler，并返回一个执行链 

- DispatcherServlet 再请求 处理器适配器(HandlerAdapter) 调用相应的 Handler 进行处理并返回 ModelAndView 给 DispatcherServlet

- DispatcherServlet 将 ModelAndView 请求 ViewReslover（视图解析器）解析，返回具体 View

- DispatcherServlet 对 View 进行渲染视图（即将模型数据填充至视图中）

- DispatcherServlet 将页面响应给用户 

### 组件说明：
- DispatcherServlet：前端控制器

   **用户请求到达前端控制器，它就相当于mvc模式中的c，dispatcherServlet是整个流程控制的中心，**

  **由它调用其它组件处理用户的请求，dispatcherServlet的存在降低了组件之间的耦合性。**

- HandlerMapping：处理器映射器
　　　**HandlerMapping负责根据用户请求url找到Handler即处理器，springmvc提供了不同的映射器实现不同的映射方式，**

 **例如：配置文件方式，实现接口方式，注解方式等。**
　　　
-  Handler：处理器
　　 **Handler 是继DispatcherServlet前端控制器的后端控制器，在DispatcherServlet的控制下Handler对具体的用户请求进行处理。**
    **由于Handler涉及到具体的用户业务请求，所以一般情况需要程序员根据业务需求开发Handler。**

- HandlAdapter：处理器适配器
　　**通过HandlerAdapter对处理器进行执行，这是适配器模式的应用，通过扩展适配器可以对更多类型的处理器进行执行。**

- ViewResolver：视图解析器
　　**View Resolver负责将处理结果生成View视图，View Resolver首先根据逻辑视图名解析成物理视图名即具体的页面地址，再生成View视图对象，最后对View进行渲染将处理结果通过页面展示给用户。**

- View：视图
　　**springmvc框架提供了很多的View视图类型的支持，包括：jstlView、freemarkerView、pdfView等。我们最常用的视图就是jsp。**
　　**一般情况下需要通过页面标签或页面模版技术将模型数据通过页面展示给用户，需要由程序员根据业务需求开发具体的页面。**

## SpringMVC注解解析

### @RequestMapping

作用：用于建立请求URL和处理请求方法之间的对应关系  

位置：

* 类上，请求URL的第一级访问目录，此处不写的话，就相当于应用的根目录。
* 方法上，请求URL的第二集访问目录，与类上的同注解一起组成访问虚拟路径

```java
@RequestMapping("user")
public class UserController {
    @RequestMapping("/quick")
    public String save() {
        System.out.println("controller save running...");
        return "success.jsp";
    }
}
//此时路径为: /user/quick
```

* 参数：**value**：用于指定请求的URL；它和path属性的作用是一样的

* 参数：**method**：用于指定请求的方式 RequestMethod.GET

* 参数：**params**：用于指定限制请求参数的条件，他支持简单的表达式，要求请求参数的key和value必须和配置的一模一样。

  Params ={"accountName"},表示请求参数必须要有accountName

  Params ={"money!100"},表示请求参数中的money不能是100



## mvc命名空间引入和组件扫描和视图解析器：

```xml
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:context="http://www.springframework.org/schema/context"
       xmlns:mvc="http://www.springframework.org/schema/mvc"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd
       http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context.xsd
       http://www.springframework.org/schema/mvc http://www.springframework.org/schema/mvc/spring-mvc.xsd
">
    <!--controller组件扫描-->
    <context:component-scan base-package="com.kawainekosann">
        <!--不包括-->
        <!--<context:exclude-filter type="annotation" expression="org.springframework.stereotype.Controller"/>-->
        <!--包括  就是器过滤器的作用 只扫描带@Controller注解的类-->
        <context:include-filter type="annotation" expression="org.springframework.stereotype.Controller"/>
    </context:component-scan>

    <!--配置内部资源视图解析器-->
    <bean id="viewResolver" class="org.springframework.web.servlet.view.InternalResourceViewResolver">
        <!--/jsp/syccess.jsp-->
        <!--前缀-->
        <property name="prefix" value="/jsp/"></property>
        <!--后缀-->
        <property name="suffix" value=".jsp"></property>
    </bean>
</beans>
```



### 视图解析器

查看解析器圆满 我们可以看到解析器默认设置

```java
REDIRECT_URL_PREFIX = "redirect:" //重定向前缀
FORWARD_URL_PREFIX = "forward:" //转发前缀
prefix = "" //视图名称前缀
suffix = ""  //视图名称后缀
```

```java
@RequestMapping(value = "/quick",method = RequestMethod.GET,params = {"userName"})
    public String save() {
        System.out.println("controller save running...");
        //转发地址不变 http://localhost:8080/user/quick?userName
        //return "forward:/jsp/success.jsp";
        //转发地址变化 变为http://localhost:8080/success.jsp
        //return "redirect:/jsp/success.jsp";
        //配置前缀后缀后 http://localhost:8080/user/quick?userName
        return "success";
    }
```



## SpringMVC的数据响应方式

1. 页面跳转

    * 直接返回字符串

      直接返回字符串：此种方式回将返回的字符串与视图解析器的前后缀拼接后跳转

    * 通过ModelAndView对象返回

      ```java
          @RequestMapping("/quick2")
          public ModelAndView save2(){
              //Model模型：作用封装数据
              //view视图：作用展示数据
              ModelAndView modelAndView = new ModelAndView();
              //设置模型数据
              modelAndView.addObject("userName","kawainekosann");
              //设置视图
              modelAndView.setViewName("success");
              return modelAndView;
          }
      
          @RequestMapping("/quick3")
          //此处需要一个ModelAndView对象，这里Spring会帮你注入一个该对象
          public ModelAndView save3(ModelAndView modelAndView){
              //设置模型数据
              modelAndView.addObject("userName","kawainekosann");
              //设置视图
              modelAndView.setViewName("success");
              return modelAndView;
          }
      
          @RequestMapping("/quick4")
          //model和view分离
          public String save4(Model model){
              model.addAttribute("userName","kawainekosann");
              return "success";
          }
      
          @RequestMapping("/quick5")
          public String save5(HttpServletRequest request){
              request.setAttribute("userName","kawainekosann");
              return "success";
          }
      ```

      ```html
      <%@ page contentType="text/html;charset=UTF-8" language="java" %>
      <html>
      <head>
          <title>Title</title>
      </head>
      <body>
      <h1>success ${userName}</h1>
      </body>
      </html>
      ```

      

2. 回写数据

   * 直接返回字符串

     Web基础阶段，客户端访问服务器端，想直接回写字符串作为响应体返回的话只需要使用

     ```java
     response.getWriter().print("hellow word");
     ```

     1. 通过SpringMVC框架注入response对象，使用上面代码回写数据，此时不需要视图跳转，业务方法返回值为void
     2. 将需要回写的字符串直接返回，但此时需要通过`@ResponseBody`注解告知SpringMVC框架，方法返回的字符串不是跳转是直接在http响应体中返回。

     ```java
         @RequestMapping("/quick6")
         public void save6(HttpServletResponse response) throws IOException {
             response.getWriter().print("hellow feimao!");
         }
     
         @RequestMapping("/quick7")
         @ResponseBody  //告知SpringMVC框架 不进行视图跳转 直接进行数据响应
         public String save7(){
          return "hellow feimao!";
         }
     
         @RequestMapping("/quick8")
         @ResponseBody
         public String save8(){
             return "{\"userName\":\"feimao\",\"age\":\"27\"}";
         }
     
         @RequestMapping("/quick9")
         @ResponseBody
         public String save9() throws JsonProcessingException {
             User user = new User();
             user.setUserName("feimao");
             user.setAge(27);
             //使用Json转换工具，将对象转换成json字符串在返回
             ObjectMapper objectMapper = new ObjectMapper();
             String json=objectMapper.writeValueAsString(user);
             return json;
         }
     ```
   
   
   * 返回对象或集合
   
     1. 
     
     ```java
         //返回对象
         @RequestMapping("/quick10")
         @ResponseBody
         //期望SpringMVC自动将User转换成json字符串
         public User save10() throws JsonProcessingException {
             User user = new User();
             user.setUserName("feimao!");
             user.setAge(27);
             return user;
         }
     ```
     
     ```xml
           <!--json工具包-->
           <dependency>
               <groupId>com.fasterxml.jackson.core</groupId>
               <artifactId>jackson-core</artifactId>
               <version>2.12.1</version>
           </dependency>
           <dependency>
               <groupId>com.fasterxml.jackson.core</groupId>
               <artifactId>jackson-databind</artifactId>
               <version>2.12.1</version>
           </dependency>
           <dependency>
               <groupId>com.fasterxml.jackson.core</groupId>
               <artifactId>jackson-annotations</artifactId>
               <version>2.12.1</version>
           </dependency>
     ```
     
     ```xml
         <!--配置处理器映射器，json工具将对象转成json-->
         <bean class="org.springframework.web.servlet.mvc.method.annotation.RequestMappingHandlerAdapter">
             <property name="messageConverters">
                 <list>
                     <bean class="org.springframework.http.converter.json.MappingJackson2HttpMessageConverter"></bean>
                 </list>
             </property>
         </bean>
     ```
     
     2. 在方法上添加`@ResponseBody`就可以返回json格式的字符串，但是这样的配置比较麻烦，配置的代码比较多，因此，我们可以使用MVC的注解驱动代替上述配置。
     
        ```xml
            <!--mvc的注解驱动，先要引入mvc的命名空间-->
            <mvc:annotation-driven></mvc:annotation-driven>
        ```
     
        在SpringMVC的各个组件中，<font color = 'red'>处理器映射器，处理器适配器，视图解析器</font>称为SpringMVC的三大组件，使用`<mvc:annotation-driven>`自动加载RequestMappingHandlerMapping(处理映射器)和RequestMappingHandlerAdapter（处理适配器），可以在Spring-xml.xml配置文件中使用`<mvc:annotation-driven>`替代注解处理器和适配器的配置。
     
        **同时使用`<mvc:annotation-driven>`默认底层就会集成Jackson进行对象或集合的Json格式字符串的转换。**

###  知识要点

1. 页面跳转
   * 直接返回字符串
   * 通过ModelAndView对象返回
2. 回写数据
   * 直接返回字符串
   * 返回对象或集合



## SpringMVC获得请求数据

### 获得请求参数

客户端请求参数格式是：`name=value&name=value....`
服务器端要获得请求的参数，有时还需要进行数据的封装，SpringMVC可以接收如下类型的参数：

* 基本类型参数
* POJO类型参数
* 数组类型
* 集合类型参数

#### 获得基本类型的数据

controller中业务方法的参数名称要与请求参数的name一致，参数值会自动映射匹配

```java
    //http://localhost:8080/user/quick11?userName=liu&age=27
    @RequestMapping("/quick11")
    @ResponseBody //代表不进行页面跳转，页面空白
    //request传过来的参数都是String类型,但是SpringMVC会帮你自动转换
    public void save11(String userName,int age){
        System.out.println(userName);
        System.out.println(age);
    }
```

#### 获得POJO类型参数

Controller中的业务员方法的POJO参数的属性名与请求参数的name一致，参数值会自动映射匹配

```java
    //http://localhost:8080/user/quick12?userName=liu&age=27
    @RequestMapping("/quick12")
    @ResponseBody //代表不进行页面跳转
    //SpringMVC自动将注入User对应的属性
    public void save12(User user){
        System.out.println(user);
    }
```

#### 获得数组类型的参数

controller中业务方法的数组名称要与请求参数的name一致，参数值会自动映射匹配

```java
    //http://localhost:8080/user/quick13?strs=aaa&strs=bbb&strs=ccc
    @RequestMapping("/quick13")
    @ResponseBody //代表不进行页面跳转
    public void save13(String[] strs){
        System.out.println(Arrays.asList(strs));
    }
```

#### 获得集合类型的参数

获得集合参数时，要将集合参数包装到一个POJO中才可以

```html
<form action="${pageContext.request.contextPath}/user/quick14" method="post">
    <%--表面是第几个User对象的userName,age--%>
    <input type="text" name="userList[0].userName"><br/>
    <input type="text" name="userList[0].age"><br/>
    <input type="text" name="userList[1].userName"><br/>
    <input type="text" name="userList[1].age"><br/>
    <input type="submit" value="提交">
</form>
```

```java
    //http://localhost:8080/jsp/form.jsp
    @RequestMapping("/quick14")
    @ResponseBody //代表不进行页面跳转
    public void save14(VO vo){
        System.out.println(vo);
    }
```

```java
public class VO {
    private List<User> userList;
    public List<User> getUserList() {
        return userList;
    }
    public void setUserList(List<User> userList) {
        this.userList = userList;
    }
    @Override
    public String toString() {
        return "VO{" +
                "userList=" + userList +
                '}';
    }
}
```

当使用ajax提交时，可以指定contentType为json形式，那么在方法参数位置使用`@RequestBody`可以直接接收集合数据而无需使用POJO进行包装

```html
<html>
<head>
    <title>Title</title>
</head>
<script src="${pageContext.request.contextPath}/js/jquery-3.5.1.js"></script>
<script>
    var userList = new Array();
    userList.push({userName:"liu1",age:27})
    userList.push({userName:"liu2",age:28})

    $.ajax({
        type:"post",
        url:"${pageContext.request.contextPath}/user/quick15",
        data:JSON.stringify(userList),
        contentType:"application/json;charset=utf-8"
    })
</script>
<body>
</body>
</html>
```

```java
    @RequestMapping("/quick15")
    @ResponseBody //代表不进行页面跳转
    public void save15(@RequestBody List<User> users){
        System.out.println(users);
    }
```

```xml
    <!--mvc开发资源的访问，/** 匹配目录及其子目录，这里是js目录不会被web.xml里配置的DispatcherServlet匹配到对应的映射中-->
    <!--<mvc:resources mapping="/js/**" location="/js/"></mvc:resources>-->
    <!--这里指mvc映射不到的地址交由原始容器（这里是tomcat）去寻找静态资源-->
    <mvc:default-servlet-handler></mvc:default-servlet-handler>
```



#### 请求数据乱码问题

当post请求时，数据会出现乱码，我们可以设置一个过滤器来进行编码的过滤

```xml
    <!--配置一个全局过滤器-->
    <filter>
        <filter-name>characterEncodingFilter</filter-name>
        <filter-class>org.springframework.web.filter.CharacterEncodingFilter</filter-class>
        <init-param>
            <param-name>encoding</param-name>
            <param-value>UTF-8</param-value>
        </init-param>
    </filter>
    <filter-mapping>
        <filter-name>characterEncodingFilter</filter-name>
        <url-pattern>/*</url-pattern>
    </filter-mapping>
```



#### 参数绑定注解`@requestParam`

当请求的参数名称与Controller的业务方法参数名称不一致时，就需要通过`@requestParam`注解显式的绑定

注解`@requestParam`有如下参数可以使用：

* value：请求参数名称
* required：此参数在指定的请求中是否必须包括，默认是true，提交时没有参数会报错
* defaultValue：当没有指定请求参数时，则使用默认值赋值

```java
@RequestMapping("/quick16")
    @ResponseBody //代表不进行页面跳转
    //http://localhost:8080/user/quick16?name=liu @RequestParam的value写页面链接的属性名
    public void save16(@RequestParam(value = "name",required = false,defaultValue = "feimao") String userName){
        System.out.println(userName);
    }
```



#### 获得Restful风格的参数

`Restful`是一种软件架构，设计风格。而不是标准，只是提供了一组设计原则和约束条件。主要用于客户端和服务器交互的软件，基于这个风格设计的软件可以更简洁，更有层次，更易于实现缓存机制等。

`Restful`风格的请求是使用"url+请求方式"表示一次请求目的的，HTTP协议里面四个表示操作方式的动词如下

* GET：用于获取资源    /user/1 GET：得到id=1的user
* POST：用于新建资源    /user/1 POST：新增user
* PUT：用于更新资源     /user/1 PUT：更新id=1的user
* DELETE：用于删除资源     /user/1 DELETE：删除id=1的user

上述url地址 /user/1中的1就是要获得的请求参数，在SpringMVC中可以使用占位符进行参数绑定。地址 /user/1可以写成 /user/{id},占位符{id}对应就是1的值。在业务方法中我们可以使用@PathVariable注解进行占位符的匹配获取工作。

```java
    /*
     * GET：用于获取资源    /user/1 GET：得到id=1的user
     * POST：用于新建资源    /user/1 POST：新增user
     * PUT：用于更新资源     /user/1 PUT：更新id=1的user
     * DELETE：用于删除资源     /user/1 DELETE：删除id=1的user
     */
    @RequestMapping(value = "/quick17/{name}",method = RequestMethod.GET)
    @ResponseBody //代表不进行页面跳转
    //http://localhost:8080/user/quick17/liu
    public void save17(@PathVariable(value = "name",required = true) String userName){
        System.out.println(userName);
    }
```



#### 自定义类型转换器

* SpringMVC默认已经提供了一些常用的类型转换器，例如客户端提交的字符串转换成int型进行参数设置
* 但是不是所有的数据类型都提供了转换器，没有提供的就需要自定义转换器，例如：日期类型就需要自定义转换器

自定义转换器的开发步骤：

1. 定义转换器类实现Converter接口
2. 在配置文件中声明转换器
3. 在`<annotation-driven>`中引用转换器

```java
import org.springframework.core.convert.converter.Converter;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
public class DateConverter implements Converter<String, Date> {
    //将日期字符串转换成日期对象，返回
    public Date convert(String dateStr) {
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
        Date date = null;
        try {
            date = format.parse(dateStr);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return date;
    }
}
```

```xml
    <!--mvc的注解驱动-->
    <!--设置转化器-->
    <mvc:annotation-driven conversion-service="conversionService"></mvc:annotation-driven>

    <!--mvc开发资源的访问，/** 匹配目录及其子目录，这里是js目录不会被web.xml里配置的DispatcherServlet匹配到对应的映射中-->
    <!--<mvc:resources mapping="/js/**" location="/js/"></mvc:resources>-->
    <!--这里指mvc映射不到的地址交由原始容器（这里是tomcat）去寻找静态资源-->
    <mvc:default-servlet-handler></mvc:default-servlet-handler>

    <!--声明转换器,时间格式转化-->
    <bean id="conversionService" class="org.springframework.context.support.ConversionServiceFactoryBean">
        <property name="converters">
            <list>
                <bean class="com.kawainekosann.converter.DateConverter"></bean>
            </list>
        </property>
    </bean>
```



#### 获取请求头的数据

1. @RequestHeader

   使用@RequestHeader可以获得请求头信息，相当于web阶段学习的`request.getHeader(name)`

   `@RequestHeader`注解的属性如下：

   * value：请求头的名称
   * required：是否必须携带 

2. @CookieValue

   使用@CookieValue可以获得知道Cookie的值

   @CookieValue注解的属性如下：

   * value：指定cookie的名称
   * required：是否必须携带 

```java
    @RequestMapping("/quick20")
    @ResponseBody //代表不进行页面跳转
    //SpringMVC自动将注入User对应的属性
    public void save20(@RequestHeader(value = "User-agent",required = false)  String user_agent){
        System.out.println(user_agent);
    }

    @RequestMapping("/quick21")
    @ResponseBody //代表不进行页面跳转
    //SpringMVC自动将注入User对应的属性
    public void save21(@CookieValue(value = "JSESSIONID",required = false)  String jsessionId){
        System.out.println(jsessionId);
    }
```



### 文件上传

#### 文件上传三要素

* 表单 type="file"
* 表单提交方式为 post
* 表单的 enctype属性是多部分表单形式 及enctype="multipart/fom-data"

#### 文件上传原理

* 当form表单修改为多部分表单时，request.getParamer()将失效。
* enctype = "application/x-www-form-urlencoded" 时，form表单的正文内容格式是：**key=value&key=value...**
* 当form表单的enctype 为 multipart/fom-data 时，请求正文内容就会变成多部分形式

#### 单文件上传步骤

* 导入fileupload 和 io坐标
* 配置文件上传解析器
* 编写文件上传代码

```xml
        <dependency>
            <groupId>commons-fileupload</groupId>
            <artifactId>commons-fileupload</artifactId>
            <version>1.3.2</version>
        </dependency>
        <dependency>
            <groupId>commons-io</groupId>
            <artifactId>commons-io</artifactId>
            <version>2.5</version>
        </dependency>
```

```xml
<!--配置文件上传解析器-->
    <bean id="multipartResolver" class="org.springframework.web.multipart.commons.CommonsMultipartResolver">
        <property name="defaultEncoding" value="UTF-8"></property>
        <property name="maxUploadSize" value="500000"></property>
    </bean>
```

```html
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
<form action="${pageContext.request.contextPath}/user/quick22" method="post" enctype="multipart/form-data">
    名称<input type="text" name="userName"><br>
    文件<input type="file" name="uploadFile"><br>
    <input type="submit" value="提交">
</form>

</body>
</html>
```

```java
@RequestMapping("/quick22")
    @ResponseBody
    public void save22(String userName, MultipartFile uploadFile) throws IOException {
        System.out.println(userName);
        //获得上传文件的名称
        String originalFilename = uploadFile.getOriginalFilename();
        uploadFile.transferTo(new File("C:\\Users\\LIUQI\\Desktop\\test\\upload\\"+originalFilename));
    }
```



#### 多文件上传实现

```java
@RequestMapping("/quick22")
    @ResponseBody
    public void save22(String userName, MultipartFile uploadFile,MultipartFile uploadFile2) throws IOException {
        System.out.println(userName);
        //获得上传文件的名称
        String originalFilename = uploadFile.getOriginalFilename();
        uploadFile.transferTo(new File("C:\\Users\\LIUQI\\Desktop\\test\\upload\\"+originalFilename));

        String originalFilename2 = uploadFile2.getOriginalFilename();
        uploadFile2.transferTo(new File("C:\\Users\\LIUQI\\Desktop\\test\\upload\\"+originalFilename2));
    }

//或者数组MultipartFile[] uploadFile
```



## SringMVC拦截器

### 拦截器的作用

SpringMVC的拦截器类似于Servlet开发中的过滤器Filter，用于对处理器进行<font color="red">预处理和后处理</font>

将拦截器按一定顺序联结成一条链，这条链被称为<font color="red">拦截器链</font>，在访问被拦截的方法或者字段时，拦截器链会按之前定义的顺序被调用，拦截器也是AOP思想的具体实现

### 拦截器和过滤器的区别

| 区别     | 过滤器                                                    | 拦截器                                                       |
| -------- | --------------------------------------------------------- | ------------------------------------------------------------ |
| 使用范围 | 是servlet规范中的一部分，任何JAVA web工程都能使用         | 是SpringMVC框架自己的，只有使用了SpringMVC框架的工程才能用   |
| 拦截范围 | 在url-pattern中配置了 /* 之后，可以对所有要访问的资源拦截 | 只会拦截访问的控制方法，如果访问的是jsp，html，css，image或js是不会进行拦截的 |

#### 拦截器快速入门

步骤：

1. 创建拦截器类实现HandlerInterceptor接口
2. 配置拦截器
3. 测试拦截器拦截效果

```java
public class MyIntersepetor implements HandlerInterceptor {
   //在目标方法执行之前执行
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        System.out.println("preHandle");
        if(request.getParameter("param").equals("yes")){
            return true;
        }else{
            request.getRequestDispatcher("/jsp/error.jsp").forward(request,response);
         return false;
        }
    }

    //在目标方法执行之后，视图返回之前执行
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
        modelAndView.addObject("userName","dafeiao");
        System.out.println("postHandle");//可以修改视图
    }

    //在整个流程都执行完毕后执行
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {
        System.out.println("afterCompletion");
    }
}
```

```java
public class MyIntersepetor2 implements HandlerInterceptor {
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        System.out.println("MyIntersepetor2 preHandle");
        return true;
    }

    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
        System.out.println("MyIntersepetor2 postHandle");
    }

    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {
        System.out.println("MyIntersepetor2 afterCompletion");
    }
}
```

```xml
<!--配置拦截器-->
    <mvc:interceptors>
        <mvc:interceptor>
            <!--对哪些资源执行拦截操作-->
            <mvc:mapping path="/target"/>
            <bean class="com.kawainekosann.interseptor.MyIntersepetor"/>
        </mvc:interceptor>
        <mvc:interceptor>
            <!--对哪些资源执行拦截操作-->
            <mvc:mapping path="/target"/>
            <bean class="com.kawainekosann.interseptor.MyIntersepetor2"/>
        </mvc:interceptor>
    </mvc:interceptors>
```

```java
@RequestMapping("/target")
    public ModelAndView save2(){
        //Model模型：作用封装数据
        //view视图：作用展示数据
        System.out.println("目标资源执行");
        ModelAndView modelAndView = new ModelAndView();
        //设置模型数据
        modelAndView.addObject("userName","kawainekosann");
        //设置视图
        modelAndView.setViewName("success");
        return modelAndView;
    }
```

preHandle
MyIntersepetor2 preHandle
目??源?行
MyIntersepetor2 postHandle
postHandle
MyIntersepetor2 afterCompletion
afterCompletion
执行顺序和配置有关由外到里，然后由里到外

#### 拦截器方法说明
preHandle：方法执行之前执行，返回false时表示请求结束，true时调用下一个interseptor
postHandle：方法执行之后，视图渲染之前执行，可以操作方法处理后的ModelAndView
afterCompletion：在整个请求结束后，即视图渲染完后执行



## SpringMVC异常处理

### 异常处理的两种方式

* 使用SpringMVC提供的简单异常处理器SimpleMappingExceptionResolver

```xml
    <!--配置异常处理器-->
    <bean class="org.springframework.web.servlet.handler.SimpleMappingExceptionResolver">
        <!--内部资源视图解析器已经配置 前缀 后缀-->
        <property name="defaultErrorView" value="error1"></property>
        <!--先匹配下面的异常，匹配不到使用上面的默认的配置-->
        <property name="exceptionMappings">
            <map>
                <entry key="java.lang.ArithmeticException" value="error2"></entry>
            </map>
        </property>
    </bean>
```

* 使用Spring的异常处理接口HandlerExceptionResolver自定义自己的异常处理器

  1. 创建异常处理器类实现HandlerExceptionResolver接口
  2. 配置异常处理器
  3. 编写异常页面
  4. 进行异常跳转

  ```java
  public class MyResolver implements HandlerExceptionResolver {
      public ModelAndView resolveException(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) {
          ModelAndView modelAndView = new ModelAndView();
          //返回值是ModelAndView，对应跳转错误视图的信息
          if(ex instanceof MyException){
              modelAndView.addObject("info","自定义的异常");
              modelAndView.setViewName("error3");
          }else if(ex instanceof ArithmeticException){
              modelAndView.addObject("info","除数为0的异常");
              modelAndView.setViewName("error2");
          }
          return modelAndView;
      }
  }
  ```

  ```java
  public class MyException extends Exception{
      //用详细信息指定一个异常
      public MyException(String message){
          super(message);
      }
  }
  ```

  ```java
  public class TargetController {
      @RequestMapping("/target")
      public ModelAndView save2() throws MyException {
          //Model模型：作用封装数据
          //view视图：作用展示数据
          System.out.println("目标资源执行");
          //int i = 1/0;
          MyException myException = new MyException("自定义异常");
          if("asd".equals("asd")){
              throw myException;
          }
          ModelAndView modelAndView = new ModelAndView();
          //设置模型数据
          modelAndView.addObject("userName","kawainekosann");
          //设置视图
          modelAndView.setViewName("success");
          return modelAndView;
      }
  }
  ```

  ```html
  <%@ page contentType="text/html;charset=UTF-8" language="java" %>
  <html>
  <head>
      <title>Title</title>
  </head>
  <body>
  <h1>error3  ${info}</h1>
  </body>
  </html>
  ```

```xml
<!--自定义异常处理器,抛出异常后，SpringMVC会根据类型找对应处理，所以要配置(猜的)-->
<bean class="com.kawainekosann.resolver.MyResolver"/>
```





























