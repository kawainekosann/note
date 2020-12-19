# Java 相关
[toc]
## Static关键字
**当申请一个事物为Static时，就意味着这个域或者方法不会与包含它那个类的任何对象实例关联在一起，
所以要即使从未创建某个类的任何对象，也可以调用其static方法或访问其static域，一般也称为
***类方法，类数据。*** (比如卖票将票数设置为静态，就可以不用线程解决)**  
_一般引用static变量有两种方法：_  
* 通过一个对象去定位它  
```
StaticTest st1 = new StaticTest();
st1.i
```
* 通过类名直接引用
```
StaticTest.i++
```
**由上可知：**
* static方法就是没有this的方法（因为static不会与不会与包含它那个类的任何对象实例关联在一起）  
* 在static方法内部不能调用非static方法，反过来是可以的（因为static不会与不会与包含它那个类的任何对象实例关联在一起） 

##this关键字
**this方法只能在方法内部使用，表示对"调用方法的那个对象"的引用**
```java
public class This {
    int i = 0;
    This add(){
      i++;
      return this;
    }
     void print(){
        System.out.println("i="+i);
     }

    public static void main(String[] args) {
        This t = new This();
        t.add().add().add().print();
    }
}
```

##赋值
**赋值的时候，是直接将一个地方的内容复制到另一个地方，例如对基本类型使用 a=b； 那么就是将b的值
复制给a；若接着修改a，b不会收到这种修改的影响。**  
**但是在为对象赋值是，<font color = 'red'>对一个对象进行操作时，我们真正操作的是对象的引用，
所以"将一个对象赋值给另一个对象"，实际上是将'引用'从一个地方复制到另一个地方，这意味着若对象 
c = d；那么c和d都指向原本d指向都那个对象，那么修改c的属性，d也会发生变化**<font>

##短路
**当使用逻辑运算符是会遇到短路现象，即一旦能够明确无误的确定整个表达式的值的时候就不会计算表达式剩下的部分了，
true && false &&........ ,当前面判断为false，后面则不会运行，直接返回false。**

##操作符
###三元操作符
`i < 10 ? i*100 : i*10 `
###逗号操作符
```java
public class CommaOperator{
    public static void main(String agres[]){
        for(int i = 1, j = i+10 ; i < 5 ;i++,j= i*2){
            System.out.println(i+"   "+j);
        }
    }
}
```

##重载(Overloading)
在一个类中的多个方法
- 有相同的方法名
- 参数不同(个数或对应位置的类型)

##构造器
**默认构造器（又名：无参构造器）是没有形式参数的 ，他的作用是创建一个"默认对象"。**  
`Bird bird = new Bird（）`  
**常见还有带参构造器，以重载的形式出现**









