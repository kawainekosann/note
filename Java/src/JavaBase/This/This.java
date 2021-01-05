package JavaBase.This;

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
