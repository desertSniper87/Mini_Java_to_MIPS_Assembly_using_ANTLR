Author: Yitao Li

http://students.washington.edu/yl790
http://pgp.mit.edu/pks/lookup?op=get&search=0x2702AED610DC39F5

IMPORTANT: to compile this program:
              
             rm -f MiniJavaV3*.java
             java -jar <path of antlr-4.1-complete.jar> MiniJavaV3.g4
             javac -cp <path of antlr-4.1-complete.jar>:. MiniJavaV3*.java

             (this should work in any UNIX operating system)

             (or possibly replace "rm" with "del" and use ";" as path separator in 
              a non-POSIX operating system (e.g., MS Windows))


           to run this program:
             
             java -cp <path of antlr-4.1-complete.jar>:. MiniJavaV3Parser <Java src file>

             (the main function that is compiled and executed should be the one
              specified in this .g4 file not the default ANTLR version) 
