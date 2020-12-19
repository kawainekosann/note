package This;

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
