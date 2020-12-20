package JavaBase.Static;

import JavaBase.Test.Test;

public class StaticA {
    /**
     *@see StaticB;
     */
    public static void main(String[] args){
        System.out.println("StaticB的参数I的值"+StaticB.i);
        StaticB.add();
        Test test = new Test();
        //test.bite();
        test.bite2();
        test.bite3();
        Test.bite3();
        //test.bite4();
        //test.bite5();
    }

}
