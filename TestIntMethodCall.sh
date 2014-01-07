#!/bin/bash
./compile.sh
javac TestIntMethodCall.java
java -cp ../antlr-4.1-complete.jar:. MiniJavaV3Parser TestIntMethodCall.java > /tmp/test.asm
diff <(java TestIntMethodCall | sed '$a\') <(java -jar ../Mars4_4.jar /tmp/test.asm | tail -n +3)
