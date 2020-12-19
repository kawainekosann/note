public class Test {
    public static void main(String[] args) {
        MyObject object1 = new MyObject();
        MyObject object2 = new MyObject();
        object1.childNode = object2;
        object2.childNode = object1;

        object1 = null;
        object2 = null;
        System.out.println(object1);
        System.out.println(object2);
    }
}

class MyObject{
    public MyObject childNode;
};