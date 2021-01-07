# Java 相关
[toc]
## Static关键字
**当申请一个事物为Static时，就意味着这个域或者方法不会与包含它那个类的任何对象实例关联在一起，所以要即使从未创建某个类的任何对象，也可以调用其static方法或访问其static域，一般也称为*"类方法，类数据"*(比如卖票将票数设置为静态，就可以不用线程解决)**  
一般引用static变量有两种方法：  

1. 通过一个对象去定位它  
```
StaticTest st1 = new StaticTest();
st1.i
```
2. 通过类名直接引用
```
StaticTest.i++
```
**由上可知：**
* <font color = 'red'>static方法就是没有this的方法（因为static不会与不会与包含它那个类的任何对象实例关联在一起 </font> 
* <font color = 'red'>在static方法内部不能调用非static方法，反过来是可以的（因为static不会与不会与包含它那个类的任何对象实例关联在一起 </font> 

### 静态数据的初始化
**<font color = 'red'>无论创建多少个对象，静态数据都只占用一个存储区域，static关键字不能应用于局部变量，只能作用于域</font>**  
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
Java允许将多个静态初始化动作组织成一个特殊的静态子句（有时也叫静态块）例如：  
```java
public class Spoon{
    static int i;
    static {
        i = 47;
    }
}
```
*上面的方法看起来像个方法，实际上只是一段跟在static关键字后面的代码，与其他静态初始化动作一样，这段代码仅仅执行一次；当首次生成这个类的一个对象时，或首次访问属于那个类的静态数据成员时（即便从未生成那个类的对象），当然不访问则不会初始化。*

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
由上面可以看出，首先在加载构造器之前会将定义的变量初始化，这里使用new关键字首次加载Bowl时，会加载一次Bowl的静态方法，之后不会加载该静态方法。然后会进行变量的初始化，另外每定义一个对象，都会初始化一遍非静态变量。

## this和super关键字


### this关键字
**<font color = 'red'>this方法只能在方法内部使用，表示对"调用方法的那个对象"的引用，特别的, 在构造方法中,通过this关键字调用其他构造方法时,必须放在第一行,否则编译器会报错. 且在构造方法中, 只能通过this调用一次其他构造方法.</font>**

```java
public class This {
    public This(){
        this("a");
        System.out.println("空构造器");
    }
    public This(String a){
        System.out.println("string构造器");
    }
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

### super关键字

**<font color = "red">super是指向父类的引用，如果子类构造方法没有显示地调用父类的构造方法，那么编译器会自动为它加上一个默认的super()方法调用。如果父类此时没有默认的无参构造方法，编译器就会报错，super()语句必须是构造方法的第一个子句。</font>**

super()调用父类无参构造器，super(String a)等调用父类有参构造器，super.参数名 调用父类参数名，super.方法名 调用父类同名方法。

```java
class Person { 
    public static void prt(String s) { 
       System.out.println(s); 
    } 
   
    Person() { 
       prt("父类·无参数构造方法： "+"A Person."); 
    }//构造方法(1) 
    
    Person(String name) { 
       prt("父类·含一个参数的构造方法： "+"A person's name is " + name); 
    }//构造方法(2) 
} 
    
public class Chinese extends Person { 
    Chinese() { 
       super(); // 调用父类构造方法（1） 
       prt("子类·调用父类”无参数构造方法“： "+"A chinese coder."); 
    } 
    
    Chinese(String name) { 
       super(name);// 调用父类具有相同形参的构造方法（2） 
       prt("子类·调用父类”含一个参数的构造方法“： "+"his name is " + name); 
    } 
    
    Chinese(String name, int age) { 
       this(name);// 调用具有相同形参的构造方法（3） 
       prt("子类：调用子类具有相同形参的构造方法：his age is " + age); 
    } 
    
    public static void main(String[] args) { 
       Chinese cn = new Chinese(); 
       cn = new Chinese("codersai"); 
       cn = new Chinese("codersai", 18); 
    } 
}
//父类·无参数构造方法： A Person.
//子类·调用父类”无参数构造方法“： A chinese coder.
//父类·含一个参数的构造方法： A person's name is codersai
//子类·调用父类”含一个参数的构造方法“： his name is codersai
//父类·含一个参数的构造方法： A person's name is codersai
//子类·调用父类”含一个参数的构造方法“： his name is codersai
//子类：调用子类具有相同形参的构造方法：his age is 18
```

### super和this的异同：

- super（参数）：调用基类中的某一个构造函数（应该为构造函数中的第一条语句） 
- this（参数）：调用本类中另一种形成的构造函数（应该为构造函数中的第一条语句）
- super:　它引用当前对象的直接父类中的成员（用来访问直接父类中被隐藏的父类中成员数据或函数，基类与派生类中有相同成员定义时如：super.变量名  super.成员函数据名（实参）
- this：它代表当前对象名（在程序中易产生二义性之处，应使用this来指明当前对象；如果函数的形参与类中的成员数据同名，这时需用this来指明成员变量名）
- 调用super()必须写在子类构造方法的第一行，否则编译不通过。每个子类构造方法的第一条语句，都是隐含地调用super()，如果父类没有这种形式的构造函数，那么在编译的时候就会报错。
- super()和this()类似,区别是，super()从子类中调用父类的构造方法，this()在同一类内调用其它方法。
- super()和this()均需放在构造方法内第一行。
- 尽管可以用this调用一个构造器，但却不能调用两个。
- this和super不能同时出现在一个构造函数里面，因为this必然会调用其它的构造函数，其它的构造函数必然也会有super语句的存在，所以在同一个构造函数里面有相同的语句，就失去了语句的意义，编译器也不会通过。
- this()和super()都指的是对象，所以，均不可以在static环境中使用。包括：static变量,static方法，static语句块。
- 从本质上讲，this是一个指向本对象的指针, 然而super是一个Java关键字。



## final关键字

根据上下文环境，final关键字存在细微的差别，但通常它指“无法改变”。以下谈论final关键字使用的三种情况：数据，方法，类

* final数据

  在编译代码的过程中，向编译器告知一块数据是恒定不变的，比如：
  1. 一个永不改变的编译常量。
  2. 一个在运行时被初始化的值，你希望他不会发生改变。    

对于（1）编译常量，在Java中这种编译常量必须是基本数据类型，并以final关键字修饰，在对这个常量进行定义时，必须对其赋值。 
而对于对象引用时，final关键字则是使引用恒定不变，一旦引用被初始化指向一个对象，就无法将它改为指向另一个对象。然而对象本身却是可以修改的。

```java
package JavaBase.Final;
import java.util.Random;
class Final {
    int i;

    public Final(int l) {
        this.i = l;
    }
}

public class Father {
    private static Random rand = new Random(47);
    private String id;
    public Father(String id) {
        this.id = id;
    }
    private final int valueone = 9;
    private static final int VAL_TWO = 99;
    public static final int VAL_THREE = 39;
    private final int i4 = rand.nextInt(20);
    static final int INT_5 = rand.nextInt(20);
    private Final v1 = new Final(11);
    private final Final v2 = new Final(22);
    private static final Final VAL_3 = new Final(33);
    private final int[] a = {1, 2, 3, 4, 5, 6};
    public String toString() {
        return id + ": " + "i4 = " + i4 + "INT_5 = " + INT_5;
    }

    public static void main(String[] args) {
        Father fd1 = new Father("fd1");
        fd1.v2.i++;
        fd1.v1 =new Final(9);
        for(int i = 0;i<fd1.a.length;i++){
            fd1.a[i]++;
            //fd1.v2 = new Final(0);
            //fd1.VAL_3 = new Final(1);
            //fd1.a = new int[3];
        }
        System.out.println(fd1);
        System.out.println("Creating new Father");
        Father fd2 = new Father("fd2");
        System.out.println(fd1);
        System.out.println(fd2);

    }
}
//fd1: i4 = 15，INT_5 = 18
//Creating new Father
//fd1: i4 = 15，INT_5 = 18
//fd2: i4 = 13，INT_5 = 18
```

由于`valueone`和`VAL_TWO`都是带有编译时数值的final基本类型。所以他俩都是编译期常量，并没有太大区别。`VALUE_THREE`是一种典型的对常量的一种定义方式：<font color ='red'>1.定义为public，则可以用于包外。2.定义为static，强调只有一份（只会加载一次）。3.定义为final，则说明它是一个常量。</font>注意，带有恒定初始值的final static 基本类型全用大写字母命名，字与字之间以_(下划线)隔开。

我们不能因为某数是final修饰的就认为在编译时就可以知道它的值，用随机数生成的`i4`,`INT_5`说明了这一点。

`fd1`,`fd2`中`i4`的值是唯一的，但`INT_5`的值是static静态的，在装载时已经初始化，每创建对象时并不会再一次初始化。故其不会改变。

`v1`到`VAL_3`说明了final修饰引用的情况：不能因为`v2`是final的就认为无法改变它的值，它是一个引用，final表示无法将`v2`指向一个新的引用。这对数组同理。（数组只不过是另一种引用）。







## 赋值

赋值的时候，是直接将一个地方的内容复制到另一个地方，例如对基本类型使用 a=b； 那么就是将b的值复制给a；若接着修改a，b不会收到这种修改的影响。  
但是在为对象赋值是<font color = 'red'>对一个对象进行操作时，我们真正操作的是对象的引用，所以"将一个对象赋值给另一个对象"，实际上是将'引用'从一个地方复制到另一个地方，这意味着若对象 c = d；那么c和d都指向原本d指向都那个对象，那么修改c的属性，d也会发生变化</font>

## 短路
当使用逻辑运算符是会遇到短路现象，即一旦能够明确无误的确定整个表达式的值的时候就不会计算表达式剩下的部分了，true && false &&........ ,当前面判断为false，后面则不会运行，直接返回false。

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
**可以使用构造器来进行初始化，构造器运行时，可以调用方法或执行某些动作来确定初始值，但无法阻止自动初始化但进行(定义的参数的初始化)，他在构造器之前发生，例：**
```java
public class Counter{
    int i;
    Counter(){
        i=7;
    }
}
```
此时初始化调用构造器，构造器对i赋值，但i的初始化会在构造器之前，且无法阻止，因为<font color = "red">类的每个基本类型数据成员保证都会有个初始值（例如：int为0，float为0.0等）</font>，所以这里的i首先会被置0，然后变成7。

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


## 对象
### 总结一下对象的创建过程，假设有个叫Dog的类  
1. 即使没有显式地使用static关键字，构造器实际上也是静态方法，当首次创建Dog对象时<font color = red>（new关键字）</font>，或者Dog类的静态方法，静态域被首次访问时，Java解释器会现查找路径，定位Dog.class文件。
2. 然后载入Dog.class（这里将创建一个class对象），有关静态初始化的所有动作都会被执行。因此，静态初始化只在class对象首次加载时进行一次。
3. 加载完对应的class后，当用new Dog()创建对象时，首先在堆上为Dog对象分配足够的存储空间（该空间的大小在类加载完成时就已经确定下来了）。
4. 这块存储空间将会被清零，然后自动将Dog对象的基本类型数据设置成默认值（对数字来说就是0 ，对布尔型和字符型也一样），而引用则被设置成null。
5. 执行所有出现于字段定义处的初始化动作
6. 执行构造器   

一般顺序：加载class——>静态块（静态变量）——>new——>成员变量——>构造方法——>静态方法 
1、静态代码块（只加载一次） 2、构造方法（创建一个实例就加载一次）3、静态方法需要调用才会执行

## 对象和引用
**类似<font color = red>Bowl a； Cup b；</font>这种，他们只是对Bowl ，Cup的一个引用（此时你已经为该引用分配了足够的存储空间），并没有给这个对象本身分配任何空间，为了给对象创建相应的存储空间，必须写初始化表达式<font color = red>（new关键字）</font>**

## 数组
**数组只是相同类型的，用一个标识符名称封装到一起的一个对象序列，或基本类型数据序列**

### 数组的初始化
数组的初始化是由一对花括号扩起来对值组成的： 
`int [] a1 = {1,2,3,4,5}`  
有时我们会在没有数组的时候定义一个数组的引用    
`int [] a2`  
在Java中可以将一个数组的值赋值给另一个数字  
`a2 = a1`  
但其实真正做但只是复制了一个数组的引用  
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
此外还可以使用new关键字在数组中创建数据。尽管创建的是基本类型的数组，new也能正常工作<font color = red>（不能用new创建单个的基本类型数据 例如 int i= new 1）</font>    

`int [] a = new int[20]`  
**此时若是打印数组a的内容会发现数组元素中的基本类型的值会自动初始化成空值（对于数字，字符就是0，布尔型是false）**  
**这里即便使用new创建了数组之后，它还只是一个引用数组，并且直到通过创建新对象，并将对象赋值给引用，初始化进程才算结束。**

## 访问权限控制(public private protected)  

### Java方法的调用
* 第一种：先创建对象，通过对象名.方法名进行调用，这是最普通的也是最常见的一种调用方式。
* 第二种：通过new关键字调用构造方法，这种是在实例化对象时使用的方式。
* 第三种：通过类名.方法名调用，当需要调用的那个方法为静态（有static的）方法时使用。

### 包（库单元）  
当编写一个Java源代码文件时，此文件通茶被称为变异单元，（有时候也叫转译单元），每个变异单元都有个.java的后缀名，编译单元内侧可以有一个public类，该类名称须与文件名称相同，每个编译单元只能有一个public类，否则编译器不会接受。如果在该编译单元之中还有额外的类的话，那么在包之外的世界是看不见这些类的，这是因为他们不是public类，他们主要用来为public类提供支持。

#### 代码组织

类库是一组类文件，其中每个文件都有一个public类，以及任意数量的非public类，因此每个文件都是一个构件，如果希望这些构件（每一个都有自己独立的.class和.java文件）丛属同一个群组，则可以使用**package关键字**

**如果使用package语句，它必须是文件中除了注释意外的第一句程序代码**，在文件起始处写

`package access;`

*上述代码表示你申明的编译单元是access类库的一部分，任何想使用该编译单元的人都必须指明全名*

`java.util.ArrayList list = new java.util.ArrayList<>();`

*或者结合使用import关键字*

`import java.util.Arraylist;` 

>一般我们导入一个类都用 import 包名.类名;而静态导入是这样：import static 包名.类名.*;
>　这里的多了个static，还有就是类名后面多了个 .* 。意思是导入这个类里的静态成员（静态方法、静态变量）。当然，也可以只导入某个静态方法，只要把 .* 换成静态方法名就行了。然后在这个类中，就可以直接用方法名调用静态方法，而不必用“类名.方法名（）” 的方式来调用。
>这种方法的好处就是可以简化一些操作，例如一些工具类的静态方法，如果使了静态导入，就可以像使用自己的方法一样使用这些静态方法。
>不过在使用静态导入之前，我们必须了解下面几点：
>
>1. 静态导入可能会让代码更加难以阅读
>2. import static和static import不能替换
>3. 如果同时导入的两个类中又有重命名的静态成员，会出现编译器错误。例如Integer类和Long类的MAX_VALUE。
>4. 可以导入的静态成员包括静态对象引用、静态常量和静态方法。

### Java访问权限修饰词

public；protected；private在使用时是置于每个成员定义之前的，仅控制修饰的成员的访问权，*如果不提供任何形式的访问修饰词，则意味着它是包访问权，<font color = 'red'>仅仅同一个包下的编译单元可以访问。</font>*

```java
package JavaBase.Test;
public class Test {
    void bite(){
        System.out.println("bite");
    }
}

//同一个包
package JavaBase.Test;
public class Test2 {
    public static void main(String[] args) {
        Test test = new Test();
        test.bite();
    }
}
```



#### public访问权限

**使用public关键字，就意味着public紧跟着的成员对自己对所有人都是可用的（无论哪里都能通过新建对象，对象名.方法名()调用）**

#### private访问权限

**关键字private的意思是除了该成员的类以外，其他任何类都无法访问该成员。**  

#### protect访问权限

**被protected修饰的成员对于本包和其子类可见，其可归纳为以下两点**

1. **父类的protected成员是包内可见的，并且对子类可见；**    

2. **若子类与父类不在同一包中，<font color='red'>那么在子类中，子类实例可以访问其从父类继承而来的protected方法，而不能访问父类实例的protected方法。</font>**

     

## 复用类

### 组合(Composition)：

java代码复用的一种方法。顾名思义，就是使用多个已有的对象组合为一个功能更加复杂强大的新对象。（比如一个对象的实例化时，引用了另一个对象的实例化）体现的是整体与部分、拥有的关系。又因为在对象之间，各自的内部细节是不可见的，所以我们也说这种方式的代码复用是黑盒式代码复用。 

```java
class Soap{
	private String s;
	public Soap() {
		// TODO Auto-generated constructor stub
		System.out.println("Soap()");
		s="Constructor";
	}
	public String toString(){
		return s;
	}
}
public class Bath {
	private String s1="happy",s2="happy",s3,s4;
	private Soap castille;
	private int i;
	private float toy;
	public Bath(){
		System.out.println("Inside Bath()");
		s3="Joy";
		toy=3.14f;
		castille=new Soap();
	}
	{i=47;}
	public String toString(){
		if(s4==null)
			s4="Joy";
		return  
				"s1 = "+s1+"\n"+
				"s2 = "+s2+"\n"+
				"s3 = "+s3+"\n"+
				"s4 = "+s4+"\n"+
				"i = "+i+"\n"+
				"toy = "+toy+"\n"+
				"castille = "+castille+"\n";
	}
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		Bath x= new Bath();
		System.out.println(x);
	}
}
/* output
Inside Bath()
Soap()
s1 = happy
s2 = happy
s3 = Joy
s4 = Joy
i = 47
toy = 3.14
castille = Constructor
*/
```

> toString(），一般显示输出该类型时会自动调用，每一个非基本类型的对象都有一个toString（）方法。  

### 继承

**<font color = 'red'>在继承中，子类具有父类的行为，当子类调用父类方法的时候，要确保父类也得到正确的初始化。</font>**  

**为了保证父类能够正常初始化，实际在子类构造方法中，相当于隐含了一个语句super()，调用父类的无参构造。同时如果父类里没有提供默认的无参构造器，那么这个时候就必须使用super(参数)显式调用的父类构造方法。(详细见super关键字)**

```java
class Animal{
    private static int A = printInit("static Animal region init ");
    {
        System.out.println("--Animal代码块--");
    }
    public Animal(){
        System.out.println("---Animal构造器---");
    }
    public static int printInit(String s){
        System.out.println(s);
        return 30;
    }
}
class Bird extends Animal{
    private static int A = printInit("static Bird  region init ");
    {
        System.out.println("--Bird代码块--");
    }

    public Bird (){
        System.out.println("---Bird构造器 ---");
    }

}
class Parrot extends Bird{
    private static int A = printInit("static Parrot  region init ");
    {
        System.out.println("--Parrot代码块--");
    }

    public Parrot()
    {
        System.out.println("--Parrot构造器--");
    }

    public static void main(String[] args) {
        Parrot parrot = new Parrot();
    }

}
//static Animal region init
//static Bird region init
//static Parrot region init
//--Animal代码块--
//---Animal构造器---
//--Bird代码块--
//---Bird构造器 ---
//--Parrot代码块--
//--Parrot构造器--
```

**通过代码可以观察到，执行的顺序是父类静态代码块>子类静态代码块>父类代码块>父类代码块>父类构造器>子类代码块>子类构造器**



#### **向上转型**

例：

```java
package JavaBase.Extends;
public class Father {
    public void play(){};
    static void tune(Father fa){
        fa.play();
    }
}
package JavaBase.Extends;

public class Child extends Father{
    public static void main(String[] args) {
        Child child = new Child();
      //父类的方法传入子类的对象不报错
        Father.tune(child);
    }
}

```
由上面的例子可以看出Father类的tune方法可以接受Child类的引用，这说明了Child的对象同时也是一种特殊的Father对象，并且不存在tune方法可以通过Father调用却不能通过Child来调用，在tune方法中，程序方法可以对Father类及其所有的子类起作用，这种将子类的引用转换成父类的引用的动作，称为**向上转型**  

Father
   ↑
Child

由导出类（Child）转换成Father类，在继承图上是向上移动的，所以一般称为**向上转型**，向上转型是一种专用类型向通用类型的转换，所以总是很安全的。




















### 在组合和继承之间选择

**组合技术：通常用于想在新类中使用现有类的功能而非它的接口这种情形，即，在新类中嵌入某个对象，让其实现所需要的功能，但新类的用户看到的只是为新类所定义的接口，而非嵌入对象的接口，需要在新类中嵌入一个现有类的private对象<font color = 'red'>（是一种 has-a 的关系）</font>**

**继承技术：使用某个现有类，开发出他的一个特殊版本，这意味着你在使用一个通用类，并为了某种特殊需要将它特殊化。用“交通工具”对象去构造一个“汽车”类是毫无意义的，因为“汽车”不包含“交通工具”<font color = 'red'>(has-a 的关系)</font>，“汽车”属于一种“交通工具”<font color = 'red'>(is-a 的关系)</font>**























