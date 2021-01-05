package JavaBase.Static;

import JavaBase.Test.Test;

public class Test3 extends Test {
    public Test3(){
        super("a");
        System.out.println("Test3构造器");
    }
    public void bite2(){
        super.bite2();
        System.out.println("bite2");
    }

    public static void main(String[] args) {
        Test.bite3();
        Test test = new Test();
        //test.bite4();
        //test.bite5();
        Test3 test3 = new Test3();
        test3.bite5();
    }
}
