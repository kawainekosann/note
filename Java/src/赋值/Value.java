package 赋值;

class Letter {
    int c;
}

public class Value {
    static void f(Letter y){
        y.c = 5;
    }

    public static void main(String args[]) {
        Letter t1 = new Letter();
        Letter t2 = new Letter();
        t1.c = 1;
        t2.c = 2;
        System.out.println(t1.c + "  " + t2.c);
        t1 = t2;
        System.out.println(t1.c + "  " + t2.c);
        t1.c = 3;
        System.out.println(t1.c + "  " + t2.c);

        Letter t3 = new Letter();
        t3.c = 4;
        System.out.println(t3.c);
        f(t3);
        System.out.println(t3.c);
    }
}

