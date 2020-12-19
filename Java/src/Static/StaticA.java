package Static;

public class StaticA {
    /**
     *@see StaticB;
     */
    public static void main(String[] args){
        System.out.println("StaticB的参数I的值"+StaticB.i);
        StaticB.add();
    }

}
