#!/bin/bash
./compile.sh
javac TestMethodRet.java
java -cp ../antlr-4.1-complete.jar:. MiniJavaV3Parser TestMethodRet.java > /tmp/test.asm
diff <(java TestMethodRet | sed '$a\') <(java -jar ../Mars4_4.jar /tmp/test.asm | tail -n +3)
