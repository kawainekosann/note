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


