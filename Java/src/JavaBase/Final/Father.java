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
        return id + ": " + "i4 = " + i4 + "，INT_5 = " + INT_5;
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
