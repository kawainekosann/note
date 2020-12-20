# Java 相关
[toc]
## Static关键字
**当申请一个事物为Static时，就意味着这个域或者方法不会与包含它那个类的任何对象实例关联在一起，所以要即使从未创建某个类的任何对象，也可以调用其static方法或访问其static域，一般也称为*"类方法，类数据"*(比如卖票将票数设置为静态，就可以不用线程解决)**  
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
* <font color = 'red'>`static方法就是没有this的方法（因为static不会与不会与包含它那个类的任何对象实例关联在一起 `</font> 
* <font color = 'red'>`在static方法内部不能调用非static方法，反过来是可以的（因为static不会与不会与包含它那个类的任何对象实例关联在一起 `</font> 

### 静态数据的初始化
**<font color = 'red'>` 无论创建多少个对象，静态数据都只占用一个存储区域，static关键字不能应用于局部变量，只能作用于域`</font>**  
静态数据的初始化：
```java
public class Test {
    public static void main(String[] args) {
        System.out.println("Create a cupboard");
        new Cupboard();
        System.out.println("Create a cupboard");
        new Cupboard();
        table.f2(1);
        cupboard.f3(1);
    }
    static Table table = new Table();
    static Cupboard cupboard = new Cupboard();
}

class Bowl{
    Bowl(int maker){
        System.out.println("Bowl("+maker+")");
    }

    void f1(int maker){
        System.out.println("f1("+maker+")");
    }
}

class Table{
    static Bowl bowl = new Bowl(1);
    Table(){
        System.out.println("Table");
        bowl2.f1(1);
    }

    void f2(int maker){
        System.out.println("f2("+maker+")");
    }
    static Bowl bowl2 = new Bowl(2);
}
class Cupboard{
    Bowl bowl3 = new Bowl(3);
    static Bowl bowl4 = new Bowl(4);
    Cupboard(){
        System.out.println("Cupboard");
        bowl4.f1(2);
    }
    void f3(int maker){
        System.out.println("f3("+maker+")");
    }
    static Bowl bowl5 = new Bowl(5);
}

//    Bowl(1)
//    Bowl(2)
//    Table
//    f1(1)
//    Bowl(4)
//    Bowl(5)
//    Bowl(3)
//    Cupboard
//    f1(2)
//    Create a cupboard
//    Bowl(3)
//    Cupboard
//    f1(2)
//    Create a cupboard
//    Bowl(3)
//    Cupboard
//    f1(2)
//    f2(1)
//    f3(1)
```

### 显式的静态初始化
**Java允许将多个静态初始化动作组织成一个特殊的静态子句（有时也叫静态块）例如：**
```java
public class Spoon{
    static int i;
    static {
        i = 47;
    }
}
```
*上面的方法看起来像个方法，实际上只是一段跟在static关键字后面的代码，与其他静态初始化动作一样，这段代码仅仅执行一次；当首次生成这个类的一个对象时，或首次访问属于那个类的静态数据成员时（即便从未生成那个类的对象），当然不访问则不会初始化。s*

### 非静态实例初始化

```java
public class Test {
    Bowl bowl1;
    Bowl bowl2;
    {
        bowl1 = new Bowl(1);
        bowl2 = new Bowl(2);
        System.out.println("bowl1 & bowl2 initialized");
    }
    Test(){
        System.out.println("test()");
    }
    Test(int i){
        System.out.println("test" + i);
    }
    public static void main(String[] args) {
        System.out.println("inside main");
        new Test();
        System.out.println("new Test() completed");
        new Test(1);
        System.out.println("new Test(1) completed");
    }
}

class Bowl {
    static {
        System.out.println("static");
    }
    Bowl(int maker) {
        System.out.println("Bowl(" + maker + ")");
    }

    void f1(int maker) {
        System.out.println("f1(" + maker + ")");
    }
}

//inside main
//static
//Bowl(1)
//Bowl(2)
//bowl1 & bowl2 initialized
//test()
//new Test() completed
//Bowl(1)
//Bowl(2)
//bowl1 & bowl2 initialized
//test1
//new Test(1) completed
```
**由上面可以看出，首先在加载构造器之前会将定义的变量初始化，这里使用new关键字首次加载Bowl时，会加载一次Bowl的静态方法，之后不会加载该静态方法。然后会进行变量的初始化，另外每定义一个对象，都会初始化一遍非静态变量。**




## this关键字
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

## 赋值
**赋值的时候，是直接将一个地方的内容复制到另一个地方，例如对基本类型使用 a=b； 那么就是将b的值复制给a；若接着修改a，b不会收到这种修改的影响。**  
**但是在为对象赋值是，<font color = 'red'>对一个对象进行操作时，我们真正操作的是对象的引用，所以"将一个对象赋值给另一个对象"，实际上是将'引用'从一个地方复制到另一个地方，这意味着若对象 c = d；那么c和d都指向原本d指向都那个对象，那么修改c的属性，d也会发生变化**<font>

## 短路
**当使用逻辑运算符是会遇到短路现象，即一旦能够明确无误的确定整个表达式的值的时候就不会计算表达式剩下的部分了，true && false &&........ ,当前面判断为false，后面则不会运行，直接返回false。**

## 操作符
### 三元操作符
`i < 10 ? i*100 : i*10 `
### 逗号操作符
```java
public class CommaOperator{
    public static void main(String agres[]){
        for(int i = 1, j = i+10 ; i < 5 ;i++,j= i*2){
            System.out.println(i+"   "+j);
        }
    }
}
```

## 重载(Overloading)
在一个类中的多个方法
- 有相同的方法名
- 参数不同(个数或对应位置的类型)

## 构造器
**默认构造器（又名：无参构造器）是没有形式参数的 ，他的作用是创建一个"默认对象"。**  
`Bird bird = new Bird（）`  
**常见还有带参构造器，以重载的形式出现**
### 构造器的初始化
**可以使用构造器来进行初始化，构造器运行时，可以调用方法或执行某些动作来确定初始值，但无法阻止自动初始化但进行，他在构造器之前发生，例：**
```java
public class Counter{
    int i;
    Counter(){
        i=7;
    }
}
```
此时初始化调用构造器，构造器对i赋值，但i的初始化会在构造器之前，且无法阻止，因为<font color = "red">`类的每个基本类型数据成员保证都会有个初始值（例如：int为0，float为0.0等）`</font>，所以这里的i首先会被置0，然后变成7。

```java
public class Test {
    Test(int i){
       System.out.println("i的值： "+i);
    }

    public static void main(String[] args) {
        House h = new House();
    }
}

class House{
    Test t = new Test(1);
    House(){
        System.out.println("House");
        t3 = new Test(4);
    }
    Test t2 = new Test(2);
    Test t3 = new Test(3);

};
//         i的值： 1
//         i的值： 2
//         i的值： 3
//         House
//         i的值： 4 
```


## 对象的创建过程
### 总结一下对象的创建过程，假设有个叫Dog的类  
1. 即使没有显式地使用static关键字，构造器实际上也是静态方法，当首次创建Dog对象时<font color = red>`（new关键字）`</font>，或者Dog类的静态方法，静态域被首次访问时，Java解释器会现查找路径，定位Dog.class文件。
2. 然后载入Dog.class（这里将创建一个class对象），有关静态初始化的所有动作都会被执行。因此，静态初始化只在class对象首次加载时进行一次。
3. 加载完对应的class后，当用new Dog()创建对象时，首先在堆上为Dog对象分配足够的存储空间（该空间的大小在类加载完成时就已经确定下来了）。
4. 这块存储空间将会被清零，然后自动将Dog对象的基本类型数据设置成默认值（对数字来说就是0 ，对布尔型和字符型也一样），而引用则被设置成null。
5. 执行所有出现于字段定义处的初始化动作
6. 执行构造器

## 引用
<font color = red>**类似`Bowl a； Cup b；`这种，他们只是对Bowl ，Cup的一个引用（此时你已经为该引用分配了足够的存储空间），并没有给这个对象本身分配任何空间，为了给对象创建相应的存储空间，必须写初始化表达式`（new关键字）`**</font>

## 数组
**数组只是相同类型的，用一个标识符名称封装到一起的一个对象序列，或基本类型数据序列**

### 数组的初始化
**数组的初始化是由一对花括号扩起来对值组成的：**  
`int [] a1 = {1,2,3,4,5}`  
**有时我们会在没有数组的时候定义一个数组的引用**  
`int [] a2`  
**在Java中可以将一个数组的值赋值给另一个数字**  
`a2 = a1`  
**但其实真正做但只是复制了一个数组的引用**  
```java
public class Test {
    public static void main(String[] args) {
        int a1[] = {1, 2, 3, 4, 5};
        int a2[];
        a2 = a1;
        for (int i = 0; i < a2.length; i++) {
            a2[i] += 1;
        }
        for (int k = 0; k < a1.length; k++) {
            System.out.println("a1[" + k + "] = " + a1[k]);
        }
    }
}

//a1[0] = 2
//a1[1] = 3
//a1[2] = 4
//a1[3] = 5
//a1[4] = 6
```
在本例中可以看出代码中给出了a1的初始值，但a2却没有；a2在后面被赋予了数组a1，a1和a2是相同数组的别名，因此a2的修改会影响到a1。  
**此外还可以使用new关键字在数组中创建数据。尽管创建的是基本类型的数组，new也能正常工作<font color = red>`（不能用new创建单个的基本类型数据 例如 int i= new 1）`**</font>    

`int [] a = new int[20]`  
**此时若是打印数组a的内容会发现数组元素中的基本类型的值会自动初始化成空值（对于数字，字符就是0，布尔型是false）**  
**这里即便使用new创建了数组之后，它还只是一个引用数组，并且直到通过创建新对象，并将对象赋值给引用，初始化进程才算结束。**











