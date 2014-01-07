class Str {

      public static void main(String [] args) {
           new StrTest().method();   
      }

}

class StrTest {

   public void method() {
       String as;
       String bs;
       String cs;
       String ds;
       
       as = "AAA";
       bs = "BBB";
       cs = "CCC";
       ds = "DDD";
       
       System.out.print(as);
       System.out.print(bs);
       System.out.print(cs);
       System.out.print(ds);
       System.out.print("\n");                     

       as = as+"<";
       bs = bs+"<";
       cs = cs+"<";
       ds = ds+"<";

       System.out.print(as);
       System.out.print(bs);
       System.out.print(cs);
       System.out.print(ds);
       System.out.print("\n");
       
       System.out.print(as+"!"+bs+"!"+cs+"!"+ds+"!");                            
                                                                                           
       
   }


}