#!/bin/bash
./compile.sh
javac Bool.java
java -cp ../antlr-4.1-complete.jar:. MiniJavaV3Parser Bool.java > /tmp/test.asm
diff <(java Bool  | sed '$a\') <(java -jar ../Mars4_4.jar /tmp/test.asm | tail -n +3)
